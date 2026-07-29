load "InRadical.m2";
load "Compose.m2";
load "CheckPI.m2";
load "InvariantVarietyIrr.m2";

workerInvariantVarietyIrr = (ringString, uInput, girrString) -> (
    R = value ringString;
    use R;

    girrInput := value girrString;

    resultInput := InvariantVarietyIrr(
        uInput,
        girrInput
        );

    toExternalString resultInput
);
