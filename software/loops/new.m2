
ringString = "QQ[x_1..x_" | toString n |
             ",y_1..y_" | toString n |
             ",e]";

firstResult = parallelIndependentApplyFirst(
    ringString,
    u,
    IrrComCan,
    "IndependentWorker.m2"
);
