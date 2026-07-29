parallelIndependentApplyFirst = method();

parallelIndependentApplyFirst(List, String, List, String) :=
(ringData, u, IrrComCan, workerFile) -> (

    R := ringData#0;
    ringString := ringData#1;

    if #IrrComCan == 0 then return null;

    -- Create a unique working directory
    workDir := temporaryFileName() | "-first-result";

    run("mkdir -p " | toExternalString workDir);

    -- Create one independent Macaulay2 script for every input
    scan(#IrrComCan, i -> (

        jobFile := workDir | "/job_" | toString i | ".m2";
        resultFile := workDir | "/result_" | toString i | ".txt";

        jobFile << ///
load /// << toExternalString workerFile << ///;

R = value /// << toExternalString ringString << ///;
use R;

girrInput = value /// <<
            toExternalString(toExternalString(IrrComCan#i)) <<
            ///;

resultInput = InvariantVarietyIrr(
    /// << toExternalString u << ///,
    girrInput
    );

resultString = toExternalString resultInput;

/// << toExternalString resultFile << /// << resultString << close;

exit 0;
/// << close;
    ));

    -- Create the Bash controller
    controllerFile := workDir | "/controller.sh";

    controllerFile << ///#!/usr/bin/env bash

workdir=/// << toExternalString workDir << ///

pids=()
indices=()

for job in "$workdir"/job_*.m2
do
    index="${job##*_}"
    index="${index%.m2}"

    M2 --script "$job" \
        > "$workdir/job_${index}.log" 2>&1 &

    pids+=("$!")
    indices+=("$index")
done

winner=""

while [ -z "$winner" ]
do
    for index in "${indices[@]}"
    do
        if [ -f "$workdir/result_${index}.txt" ]
        then
            winner="$index"
            break
        fi
    done

    if [ -z "$winner" ]
    then
        sleep 0.1
    fi
done

echo "$winner" > "$workdir/winner.txt"

# Stop every computation except the winner
for position in "${!pids[@]}"
do
    pid="${pids[$position]}"
    index="${indices[$position]}"

    if [ "$index" != "$winner" ]
    then
        kill -TERM "$pid" 2>/dev/null || true
    fi
done

sleep 1

# Force-stop computations that ignored SIGTERM
for position in "${!pids[@]}"
do
    pid="${pids[$position]}"
    index="${indices[$position]}"

    if [ "$index" != "$winner" ]
    then
        kill -KILL "$pid" 2>/dev/null || true
    fi
done

wait 2>/dev/null || true
/// << close;

    run("chmod +x " | toExternalString controllerFile);

    -- Return after the first result is found
    run("bash " | toExternalString controllerFile);

    winnerFile := workDir | "/winner.txt";

    if not fileExists winnerFile then (
        error "No independent computation returned a result";
    );

    winnerString := replace("\n", "", get winnerFile);
    winnerIndex := value winnerString;

    resultFile := workDir |
                  "/result_" |
                  winnerString |
                  ".txt";

    if not fileExists resultFile then (
        error(
            "The winning job did not produce its result file. See " |
            workDir |
            "/job_" |
            winnerString |
            ".log"
        );
    );

    resultString := get resultFile;

    -- Convert the string into elements of the parent ring
    use R;
    resultRingElements := value resultString;

    {
        winnerIndex,
        resultRingElements,
        workDir
    }
);
