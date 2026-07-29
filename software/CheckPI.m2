CheckPI = method()
CheckPI(List, List, List) := (initialvalue, g, map)->(
---Extracting polynomial mappings, an inequation and initial values from an example.
t1 := cpuTime();
i := 1;
F := map_0;
A := {x_1=>initialvalue_0};
t :=  2;
while t<length(F)+1 do(
	A =join(A,{x_t=>initialvalue_(t-1)});
	t=t+1; 
	);
---print A;
X := g;
Xt := Compose(X,{F},length(F));
---print(Xt);
N := 0;
while InRadical(Xt, X) == false do(
X = join(X, Xt);
Xt= Compose(Xt, {F},length(F));
N= N+1;
);
verifyinv := 0;
i=0;
while i<length(X) do(
	verifyinv=verifyinv+(sub(X_i,A))^2;
	i=i+1;
);
bool := false;
if verifyinv ==0 then (bool = true);
t4 := cpuTime();
<< "The running time is " <<t4-t1<< endl;
return bool;
);

---Computing Invariant sets
---while radicalContainment(Xt_0, ideal(X)) == false do(
