A=[-1 0;0 -3];
B=[0 1;2 1];
C=[1 2;1 0];
D=[0 0;0 0];
G=ss(A,B,C,D);
k=0; %gain only controller
for k=0.1:0.1:10
    N=lft(G,k);
end
display('the inf norm using hinfnorm function is');
hinfnorm(G)
display('now solving LMI using bounded real lemma, using YALMIP toolbox');
gamma=sdpvar(1,1); 
P=sdpvar(2,2,'symmetric');
appa=A'*P+P*A;
pb=P*B;
c_d=C';
bp=B'*P;
gam=-gamma*eye(2);
d_d=D';
c=C ;
d=D ;
% size(appa)
% size(pb)
% size(c_d)
% size(bp)
% size(gam)
% size(d_d)
% size(c)
% size(d)
P=P>0;
lmi=[appa pb c_d;bp gam d_d;c d gam]<0;
lmi=lmi+P;
%P
options=sdpsettings('solver','lmilab');
diag=optimize(lmi,gamma,options);

display('the value of gamma after solving the lmi is');
gamma=double(gamma)