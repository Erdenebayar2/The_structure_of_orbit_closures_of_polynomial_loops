inputs = {{"loops/yagzhev9.m2", 6},{"loops/yagzhev9.m2", 5}} 

---{"loops/ex3.m2", 1}, {"loops/fibzero.m2", 1},{"loops/fibzero.m2", 2},{"loops/fibzero.m2", 3},{"loops/fibzero.m2", 4} }

------------------------------------------------------------
-- File containing all definitions needed by OrbitClosure
------------------------------------------------------------

orbitClosureLoadFile :=
    currentDirectory() | "main.m2";


------------------------------------------------------------
-- Run OrbitClosure on many inputs and save results to CSV
------------------------------------------------------------

runOrbitClosuresToCSV = method();

runOrbitClosuresToCSV(List, String, ZZ) :=
(inputs, outputFile, timeLimit) -> (

    out := openOut outputFile;

    out
    << "Input,Integer,Status,Wall time,Orbit closure,Log file"
    << endl;

    close out;

    if #inputs == 0 then (
        print "The input list is empty.";
        return null;
    );

    for i from 0 to (#inputs - 1) do (

        u := (inputs#i)#0;
        d := (inputs#i)#1;

        workDir := temporaryFileName()
                   | "-orbitclosure-"
                   | toString(i);

        run(
            "mkdir -p "
            | toExternalString(workDir)
        );

        jobFile := workDir
                   | "/job_"
                   | toString(i)
                   | ".m2";

        resultFile := workDir
                      | "/result_"
                      | toString(i)
                      | ".txt";

        logFile := workDir
                   | "/job_"
                   | toString(i)
                   | ".log";

        startFile := workDir | "/start.txt";
        endFile := workDir | "/end.txt";
        elapsedFile := workDir | "/elapsed.txt";

        ----------------------------------------------------
        -- Create an independent Macaulay2 script
        ----------------------------------------------------

        jobOut := openOut jobFile;

        jobOut
        << "load "
        << toExternalString(orbitClosureLoadFile)
        << ";"
        << endl;

        jobOut
        << "resultInput = OrbitClosure("
        << toExternalString(u)
        << ","
        << toString(d)
        << ");"
        << endl;

        jobOut
        << "resultString = toExternalString(resultInput);"
        << endl;

        jobOut
        << toExternalString(resultFile)
        << " << resultString << close;"
        << endl;

        jobOut
        << "exit 0;"
        << endl;

        close jobOut;

        print(
            "Starting input "
            | toString(i + 1)
            | " of "
            | toString(#inputs)
            | ": "
            | toString(u)
            | ", "
            | toString(d)
        );

        ----------------------------------------------------
        -- Record starting wall-clock time
        ----------------------------------------------------

        run(
            "date +%s.%N > "
            | toExternalString(startFile)
        );

        ----------------------------------------------------
        -- Run with the time limit
        ----------------------------------------------------

        command :=
            "timeout --signal=TERM --kill-after=5s "
            | toString(timeLimit)
            | " M2 --script "
            | toExternalString(jobFile)
            | " > "
            | toExternalString(logFile)
            | " 2>&1";

        rawExitCode := run command;

        ----------------------------------------------------
        -- Macaulay2 run() may return 256 times shell status
        ----------------------------------------------------

        exitCode := if rawExitCode >= 256 then
            floor(rawExitCode / 256)
        else
            rawExitCode;

        ----------------------------------------------------
        -- Record ending wall-clock time
        ----------------------------------------------------

        run(
            "date +%s.%N > "
            | toExternalString(endFile)
        );

        run(
            "awk 'NR==FNR {start=$1; next} "
            | "{printf \"%.3f\", $1-start}' "
            | toExternalString(startFile)
            | " "
            | toExternalString(endFile)
            | " > "
            | toExternalString(elapsedFile)
        );

        elapsedString := "";

        if fileExists elapsedFile then (
            elapsedString = replace(
                "\n",
                "",
                get elapsedFile
            );
        );

        ----------------------------------------------------
        -- Determine computation status
        ----------------------------------------------------

        status := "";
        resultString := "";

        if exitCode == 0 then (

            if fileExists resultFile then (
                status = "Success";
                resultString = get resultFile;
            )
            else (
                status = "Failed: no result file";
            );

        )
        else if exitCode == 124 then (

            status = "Timeout";

        )
        else if exitCode == 137 then (

            status = "Timeout: force terminated";

        )
        else (

            status = "Failed: exit code "
                     | toString(exitCode);

        );

        ----------------------------------------------------
        -- Print the log automatically when a job fails
        ----------------------------------------------------

        if status =!= "Success" then (

            print(
                "Input "
                | toString(i + 1)
                | " failed."
            );

            print(
                "Status: "
                | status
            );

            print(
                "Log file: "
                | logFile
            );

            if fileExists logFile then (
                print "------------- CHILD LOG -------------";
                print(get logFile);
                print "-------------------------------------";
            );
        );

        ----------------------------------------------------
        -- Escape values for CSV
        ----------------------------------------------------

        inputString := replace(
            "\"",
            "\"\"",
            toString(u)
        );

        statusString := replace(
            "\"",
            "\"\"",
            status
        );

        resultString = replace(
            "\"",
            "\"\"",
            resultString
        );

        logString := replace(
            "\"",
            "\"\"",
            logFile
        );

        ----------------------------------------------------
        -- Append one row and close the file
        ----------------------------------------------------

        out = openOutAppend outputFile;

        out
        << "\"" << inputString << "\","
        << toString(d) << ","
        << "\"" << statusString << "\","
        << elapsedString << ","
        << "\"" << resultString << "\","
        << "\"" << logString << "\""
        << endl;

        close out;

        print(
            "Saved row "
            | toString(i + 1)
            | " of "
            | toString(#inputs)
            | " with status: "
            | status
        );
    );

    print(
        "Results saved to "
        | outputFile
    );

    outputFile
);
