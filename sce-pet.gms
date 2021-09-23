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
component_combinations_MS(i,j) /#componentsM.#componentsS/
component_combinations_ML(i,j) /#componentsM.#componentsL/
component_combinations_MI(i,j) /#componentsM.#componentsI/;


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

* multi-objective optimization
  

parameter gwpC,costC,thetaC;

$if not set gwpC $set gwpC -1;
gwpC=%gwpC%;
equation addCons1;
addCons1$(gwpC>0).. gwp=l=gwpC;

$if not set costC $set costC -1;
costC=%costC%;
equation addCons2;
addCons2$(costC>0).. lcc=l=costC;

$if not set thetaC $set thetaC -1;
thetaC=%thetaC%;
equation addCons3;
addCons3$(thetaC>0).. theta=g=thetaC;



Model SCE_Prob /ALL/;
Option NLP=BARON;

*$onecho > baron.opt
*DoLocal 0
*NumLoc 0
*$offecho


parameter zD,zG,zC;
If(thetaC<0, Solve SCE_Prob Using NLP maximizing theta; 
zD = theta.l;
theta.lo=zD;
zG = gwp.l;
gwp.l=zG;
Solve SCE_Prob Using NLP minimizing gwp;
zG = gwp.l;
gwp.up=zG;
Solve SCE_Prob Using NLP minimizing lcc;
zC=cost.l;
cost.up=zC;

Elseif (gwpC<0), Solve SCE_Prob Using NLP minimizing gwp;
zG = gwp.l;
gwp.up=zG;
*Solve SCE_Prob Using NLP minimizing lcc;
zC=lcc.l;
lcc.up=zC;
*Solve SCE_Prob Using NLP maximizing theta;
zD = theta.l;
theta.fx=zD;

else  Solve SCE_Prob Using NLP minimizing lcc;
zC = lcc.l;
lcc.up=zC;
*Solve SCE_Prob Using NLP maximizing theta;
zD = theta.l;
theta.lo=zD;
*Solve SCE_Prob Using NLP minimizing gwp;
zG=gwp.l;
gwp.fx=zG;
);





