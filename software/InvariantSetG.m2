computeInvariantSetG = method()
computeInvariantSetG(String, List) := (u,X)->(
---Extracting polynomial mappings, an inequation and initial values from an example.
t1=cpuTime();
i = 0;
N=0;
load u;
X = g;
Xt = Compose(X,F,n);
print(Xt);
while InRadical(Xt, X) == false do(
X = join(X, Xt);
Xt= Compose(Xt, F,n);
N= N+1;
);
t4 = cpuTime();
<< "The running time is " <<t4-t1<< endl;
return X;
);

