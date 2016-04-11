s=tf('s');
%%% Example 1 %%%%

% b= [0 0.001011 0.0006967 1.801e-06];
% a= [1 1.16 0.3351 0.007859];
% G=tf(b,a)
% [A,B,C,D]=tf2ss(b,a)

% Gamma is 1.0

%%%% Example 2 %%%%
% A=[-0.8 -0.0006 -12 0;0 -0.014 -16.64 -32.2;1 -0.0001 -1.5 0;1 0 0 0];
% B=[-19 -3;-0.66 -0.5;-0.16 -0.5;0 0];
% C=[0 0 0 1;0 0 -1 1];
% D=zeros(2,2);
% Gss=ss(A,B,C,D);
% G=tf(Gss);
% W1=[10*(s+0.3)/(s*(s+8)) 0;0 20*(s+1.5)/(s*(s+1))];
% % [W1a,W1b]=tfdata(W1);
% % [A1,B1,C1,D1]=tf2ss(W1a,W1b);
% Gs=G*W1;
% Gs=ss(Gs,'min');
% [A,B,C,D]=ssdata(Gs)

% Gamma is 2.5095

%%%Example 3%%%
G=0.3961/(0.2256*s^2+0.3645*s+1.469);
G=ss(G);
% [A,B,C,D]=ssdata(G);
W1=[10*(s+0.3)/(s*(s+8)) 0;0 20*(s+1.5)/(s*(s+1))];
Gs=G*W1;
Gs=ss(Gs,'min');
[A,B,C,D]=ssdata(Gs);
%Gamma is 1.0393...with weight 3.2502.


order=size(A);
order=order(1);
order_s=num2str(order);
n_out=size(C);
n_out=n_out(1);
nout_s=num2str(n_out);
n_in=size(B);
n_in=n_in(2);
nin_s=num2str(n_in);
order_s=['The plant order is ',order_s];
display(order_s); 
nout_s=['The number of output(s) ',nout_s];
display(nout_s); 
nin_s=['The number of input(s) ',nin_s];
display(nin_s); 
gamma=sdpvar(1,1); 
S=sdpvar(order,order,'symmetric');
R=sdpvar(order,order,'symmetric');

assa=A'*S+S*A;
arra=A*R+R*A';
rct=R*C';
cr=C*R;
bbt=B*B';
ctc=C'*C;
zero=zeros(order,n_out);
gam=-gamma*eye(n_out);

arra_gam=arra-gamma*bbt;
% size(arra_gam)
% size(rct)
% size(zero)
% size(cr)
% size(gam)
% size(eye(n_out))
% size(c)
% size(d)
[Y,L1,G]=care(A',C',B*B');
L=-Y*C';
assa_gam=assa-gamma*ctc+C'*L'*S+S*L*C;
lmi_S=assa_gam<0;
lmi_R=[arra_gam rct -L;cr gam eye(n_out);-L' eye(n_out) gam]<0;
lmi_RS=[R eye(order);eye(order) S]>=0;
lmi=lmi_S+lmi_R+lmi_RS;
%P
options=sdpsettings('solver','lmilab');
diag=optimize(lmi,gamma,options);

display('The value of gamma after solving the set of LMIs is');
gamma=double(gamma)