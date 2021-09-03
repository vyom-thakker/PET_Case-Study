Sets
i products //
j process //
k interventions //;

sets
intermediates(i)//
consumers(j);

parameter
demand(j) //;

parameters
A(i,j)
B(j,k);

variables
s(j)
f(i)
g(k);


*LCA, Allocation and Displacement
equations
eqAsf(i)
eqZeroF(i)
eqgBs(k);

eqAsf(i).. sum(j,A(i,j)*s(j))=e=f(i);
eqgBs(k).. sum(j,B(k,j)*s(j))=e=g(k);
eqZeroF(i)$intermediates(i).. f(i)=e=0;

*Utility satisfaction
equations
eqUtility(j);
eqUtility(j) $ consumers(j) .. s(j)=e=demand(j);

set
componentsM(j) //
componentsL(j) //
ComponentsS(j) //
component_combinations_MS(i,j) //
component_combinations_ML(i,j) //
component_combinations_MI(i,j) //;


variable
comp(j);

equations
eqComp(j);

eqComp(j)$componentsM(j) .. comp(j)*demand(j)=e=s(j);

alias(j,jd1,jd2,jd3);

*Governing equations
equations
eqGE1, eqGE2, eqGE3;
eqGE1(jd1,jd2) $ component_combinations_MS(i,j) .. s(jd2)=e=comp(jd1);
eqGE2(jd1,jd3) $ component_combinations_ML(i,j) .. s(jd2)=e=comp(jd1);
eqGE3(jd1,jd3) $ component_combinations_MI(i,j) .. s(jd3)=e=comp(jd1);

positive variable theta;
equation eqCircularity;
eqCircularity.. theta*sum(j$manufacturing(j),A(i,j)*s(j))=e=sum(j$circularFlows(j),A(i,j)*s(j));

positive variable gwp;
equation eqGWP;
eqGWP.. gwp=e=g('');

positive variable lcc;
equation eqLCC;
eqLCC.. lcc=e=g('');

*fractional programming

  
