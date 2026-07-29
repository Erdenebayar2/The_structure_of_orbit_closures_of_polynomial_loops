Compose = method()
Compose(List,List, ZZ) := (pol, Maps,n)->(
pol1 := {};
---print(pol);
i := 0;
	while i< length pol do (
	j := 0;
	while j<length Maps do(
	 AA := {x_1=>Maps_j_0};
	    t :=  2;
	    while t<n+1 do(
		AA =join(AA,{x_t=>Maps_j_(t-1)});
		t=t+1; 
		);
		j=j+1;
	pol1 = join(pol1, {sub(pol_i, AA)});
	);
	i = i+1;
	);
return pol1;
);
end--
