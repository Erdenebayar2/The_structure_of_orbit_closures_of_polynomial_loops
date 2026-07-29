OrbitClosure = method()
OrbitClosure(String, ZZ) := (u,di)->(
t1OrCo = cpuTime();
itrun=1;
Itrun = computeInvariants(u,1);
while (n-codim(ideal Itrun)) != di do(
	if (n-codim(ideal Itrun)) < di then(
		return "Infeasible";
	);
	itrun=itrun+1;
	print(itrun);
	Itrun = computeInvariants(u,itrun);
);
IrrCom=primaryDecomposition(ideal(Itrun));
IrrComCan = {};
i =0;
while i < length(IrrCom) do(
	IrrComCan = append(IrrComCan, flatten entries gens(IrrCom_i));
	i = i+1;
);
print(IrrComCan);
allowableThreads = maxAllowableThreads;
---AAA = InvariantVarietyIrr(u, IrrComCan_0);
ringString := "QQ[x_1..x_" | toString n |
              ",y_1..y_" | toString n |
              ",e]";

ringData := {R, ringString};
firstResult = parallelIndependentApplyFirst(
    ringData,
    u,
    IrrComCan,
    "IndependentWorker.m2"
);
i =0;
while i<length(firstResult)-1 do(
	if instance(firstResult_i,List)  then(
		lastcom = length(firstResult_i_1)-1;
		OrCo =InvariantVarietyIrr(u, firstResult_i_1_lastcom);
		i = length(firstResult)-1;
	);
	i = i +1;
);
t4OrCo = cpuTime();
<< "The running time is " <<t4OrCo-t1OrCo<< endl;
return {t4OrCo-t1OrCo, OrCo};
);

---Generating a polynomial matirx

