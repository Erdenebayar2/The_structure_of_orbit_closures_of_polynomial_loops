generalpolynomial = method()
generalpolynomial(ZZ,ZZ) :=(n,d)-> (
M = binomial(n+d,d)+n;
R = QQ[x_1..x_M,e];
S = 1;
j=1 ;
while j< n+1 do (
	S = S+x_j;
    	j= j+1;
);
C = first entries monomials S^d;
j =0;
g=0;
while j< length C do (
        g = g+x_(M-j)*C_j;
	j=j+1;	
);
return g;
)

end --
Generating polynomial invariants up to given degree.
