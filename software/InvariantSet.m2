computeInvariantSet = method()
computeInvariantSet(String, ZZ, ZZ) := (u,n,d)->(
---Extracting polynomial mappings, an inequation and initial values from an example.
t1=cpuTime();
i = 0;
N=0;
g = {generalpolynomial(n,d)};
load u;
X = g;
Xt = Compose(X,F,n);
---print(Xt);
while InRadical(Xt, X) == false do(
X = join(X, Xt);
Xt= Compose(Xt, F,n);
N= N+1;
);
t4 = cpuTime();
<< "The running time is " <<t4-t1<< endl;
return X;
);

---Computing Invariant sets
---while radicalContainment(Xt_0, ideal(X)) == false do(
