InvariantVarietyIrr = method()
InvariantVarietyIrr(String, List) := (u,girr)->(
t1 = cpuTime();
---Loading an example 
load u;
Fmap = (mapping())_0;
initialvalue = initial();
i =0;
while i<n do(
	initialvalueprime_i =initialvalue_i;
	i=i+1;
);
A = {x_1=>initialvalueprime_0};
t =  2;
print("fine");
while t<n+1 do(
	A =join(A,{x_t=>initialvalueprime_(t-1)});
	t=t+1; 
	);
i=0;
invariety =0;
while i<length(girr) do(
	invariety =invariety+(sub(girr_i,A))^2;
	i = i+1;
);
soutside =0;
while invariety != 0 do(
	invariety =0;
	i=0;
	while i< n do(
		initialvalueprime_i =sub(Fmap_i, A);
		i = i+1;
	);
	A = {x_1=>initialvalueprime_0};
	t =  2;
	while t<n+1 do(
		A =join(A,{x_t=>initialvalueprime_(t-1)});
		t=t+1; 
	);
	i=0;
	while i<length(girr) do(
		invariety =invariety+(sub(girr_i,A))^2;
		i = i+1;
	);
	soutside=soutside+1;
);
initialvaluecorrect = {};
i=0;
while i<n do(
    initialvaluecorrect = append(initialvaluecorrect, initialvalueprime_i);
    i = i+1;
);
xList = {};
for i from 1 to n do (
    xList = append(xList, x_i);
);
changevar = {};
for i from 1 to n do (
    changevar = join(changevar, {y_i=>x_i});
);
Pirr_0 = girr;
r =0;
h = girr;
while CheckPI(initialvaluecorrect,h,{Fmap}) == false do(
	r = r+1;
	Ielim = girr;
	for i from 1 to n do (
    		Ielim = append(Ielim, y_i-Fmap_(i-1));
	);
	Ielim = ideal(Ielim);
	---print(Ielim);
	girr = eliminate(Ielim, xList);
	girr = sub(girr, changevar);
	---print(girr);
	h = ideal(h)*girr;
	h = trim h;
	h = flatten entries gens h;
	---print(h);
	girr = flatten entries gens girr;
	Pirr_r = girr;
);
print("Finished");
Pcom = {};
i =0;
while i<r+1 do(
	Pcom=append(Pcom,Pirr_i);
	---print(Pcom);
	i = i+1;
);
--- Now find the number of isolated points since we knowe the maximal components of the orbit closure
initialvalue = initial();
i =0;
while i<n do(
	initialvalueprime_i =initialvalue_i;
	i=i+1;
);
A = {x_1=>initialvalueprime_0};
t =  2;
print("fine");
while t<n+1 do(
	A =join(A,{x_t=>initialvalueprime_(t-1)});
	t=t+1; 
	);
i=0;
invariety =0;
while i<length(h) do(
	invariety =invariety+(sub(h_i,A))^2;
	i = i+1;
);
soutside =0;
while invariety != 0 do(
	invariety =0;
	i=0;
	while i< n do(
		initialvalueprime_i =sub(Fmap_i, A);
		i = i+1;
	);
	A = {x_1=>initialvalueprime_0};
	t =  2;
	while t<n+1 do(
		A =join(A,{x_t=>initialvalueprime_(t-1)});
		t=t+1; 
	);
	i=0;
	while i<length(h) do(
		invariety =invariety+(sub(h_i,A))^2;
		i = i+1;
	);
	soutside=soutside+1;
);
t4 = cpuTime();
<< "The running time is " <<t4-t1<< endl;
return {soutside,Pcom};
);
