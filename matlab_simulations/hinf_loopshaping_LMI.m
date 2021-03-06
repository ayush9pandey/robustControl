s=tf('s');
%%% Example 1 : Translatory motion of three wheeled front steered robot. BLDC motor model %%%%

b= [0 0.001011 0.0006967 1.801e-06];
a= [1 1.16 0.3351 0.007859];
G=tf(b,a)
%%%Finding shaped plant

W1=10*(s+0.3)/(s*(s+8))
Gs=G*W1;
Gs=ss(Gs,'min');
[A,B,C,D]=ssdata(Gs)
%Gamma is 1.3937

% %%%% Example 2 : Aircraft F8 state space model %%%%
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
% [A,B,C,D]=ssdata(Gs) %shaped plant state space
% Gamma is 2.5095

% 
% %%%% F16 aicraft longitudinal model %%%
% A = [
% -0.3220 0.0640 0.0364 -0.9917 0.0003 0.0008 0
% 0 0 1 -0.0037 0 0 0
% -30.6492 0 -3.6784 0.6646 -0.7333 0.1315 0
% 8.5396 0 -0.0254 -0.4764 -0.0319 -0.0620 0
% 0 0 0 0 -20.2 0 0
% 0 0 0 0 0 -20.2 0
% 0 0 0 57.2958 0 0 -1 ];
% 
% B = [
% 0 0
% 0 0
% 0 0
% 0 0
% 20.2 0
% 0 20.2
% 0 0 ];
% 
% C= [
% 0 0 0 57.2958 0 0 -1
% 0 0 57.2958 0 0 0 0
% 57.2958 0 0 0 0 0 0
% 0 57.2958 0 0 0 0 0 ];
% 
% D=zeros(4,2);
% Gss=ss(A,B,C,D);
% G=tf(Gss);
% W1=[10*(s+0.3)/(s*(s+8)) 0;0 20*(s+1.5)/(s*(s+1))];
% Gs=G*W1;    
% Gs=ss(Gs,'min');
% [A,B,C,D]=ssdata(Gs) %shaped plant state space
% 
% %%% gamma= 

% % %%%Example 3 : Mobile robot 2nd order model taken from a research paper referenced in the report%%%
% G=0.3961/(0.2256*s^2+0.3645*s+1.469)
% G=ss(G,'min');
% [Ag,Bg,Cg,Dg]=ssdata(G);
% % W1=10*(s+0.3)/(s*(s+8))min
% W1=(87.3* s^2 + 365.5 *s + 83.3)/(s^2 + 10*s)
% Gs=G*W1;
% Gs=ss(Gs,'min');
% [A,B,C,D]=ssdata(Gs)
% % %Gamma is 1.0393...with weight 1.2761.

%%% Example 4 Attitude control of flexible spacecraft -- McFarlane Glover
% %%% Book
% omega=1.539;
% zeta=0.003;
% 
% A=[0 1 0 0;
% 0 0 0 0;
% 0 0 0 1;
% 0 0 -omega^2 -2*zeta*omega];
% B=[0; 1.7319e-5; 0;3.7859e-4];
% C=[1 0 1 0];
% D=0;
% G=ss(A,B,C,D);
% %Design 1%
% % W1=2000;
% W1=(s+0.4)/s;
% W1=W1*10000;
% Gs=W1*G;
% Gs=ss(Gs,'min');
% [A,B,C,D]=ssdata(Gs);
% 



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
[Y,L1,Gu]=care(A',C',B*B');
L=-Y*C';
assa_gam=assa-gamma*ctc+C'*L'*S+S*L*C;
lmi_S=assa_gam<=-1e-6;
lmi_R=[arra_gam rct -L;cr gam eye(n_out);-L' eye(n_out) gam]<=-1e-6;
lmi_RS=[R eye(order);eye(order) S]>=0;
lmi_RR=R>=1e-2;
lmi_SS=S>=1e-2;
lmi=lmi_S+lmi_R+lmi_RS+lmi_RR+lmi_SS;
%P
options=sdpsettings('solver','lmilab','cachesolvers',1,'verbose',0);
% diag=optimize(lmi,gamma,options);
% 
% display('The value of gamma after solving the set of LMIs is');
% gamma=double(gamma)
diag=optimize(lmi,R,options);
diag1=optimize(lmi,S,options);
diag2=optimize(lmi,gamma,options);
R=double(R);
S=double(S);
gamma=double(gamma)+0.1;


%controller reconstruction
k=rank(eye(order)-R*S);
if(k<=order)
    display('Rank(I-RS) is less than or equal to the controller order k --reduced order controller synthesis');
    pause(2);
end
% N=eye(order,k);
% M=(eye(order)-R*S)*pinv(N');
% %calculating Xcl
% 
% Xcl=[S eye(order);N' zeros(k,order)]/[eye(order) R;zeros(k,order) M'];
% [~,p]=chol(Xcl);
% if (p ~= 0)
%     display('Xcl is not positive definite and/or symmetric, returning');
%     return
% end
% 
%     
% % syms Xcl
% % lmeq_Xcl=([S eye(order);N' zeros(k,order)]==Xcl*[eye(order) R;zeros(k,order) M']);
% % sol_Xcl=solve(lmeq_Xcl,Xcl);
% % Xcl=double(sol_Xcl);
% %finding theta, the controller state space
% A0=[A zeros(order,k);zeros(k,order) zeros(k,k)];
% B0=[-L;zeros(k,n_out)];
% C1=[zeros(n_in,order);C];
% C0=[C1 zeros(n_out+n_in,k)];
% D11=[zeros(n_in,n_out);eye(n_out)];
% B_b=[zeros(order,k) B;eye(k) zeros(k,n_in)];
% D12=[eye(n_in);zeros(n_out,n_in)];
% D_d12=[zeros(n_out+n_in,k) D12];
% C2=C;
% C_c=[zeros(k,order) eye(k);C2 zeros(n_out,k)];
% D21=eye(n_out);
% D_d21=[zeros(k,n_out);D21];
% 
% si_xcl=[A0'*Xcl+Xcl*A0 Xcl*B0 C0';B0'*Xcl -gamma*eye(n_out) D11';C0 D11 -gamma*eye(n_out+n_in)];
% P_xcl=[(B_b')*Xcl zeros(n_in+k,n_out) D_d12'];
% D_d=[C_c D_d21 zeros(n_out+k,n_in+n_out)];
% theta=basiclmi(si_xcl,P_xcl,D_d);
% size(theta);
% W1ss=ss(W1);
% thetass=ss(theta)
% gamma
% % K=W1*tf(theta)
% % Kss=ss(K,'min')
% % K1=tf(theta)*W1
% % K1ss=ss(K1)
display('Robust stability margin in percentage is');
robstabmargin=(1/gamma)*100

%%% controller design method from there %%

Bc=(S\inv(R) - eye(order))\(L-gamma*(S\(C')));
Cc=-(gamma*B')/R;
Ac=-(S\inv(R) - eye(order))\(gamma*B*(B'/R) + L*C - gamma*(S\C')*C + A + (S\A')/R + (S\C')*(L'/R));
thetass=ss(Ac,Bc,Cc,0);

K=W1*tf(thetass)
% ML=G*K;
% CL=feedback(ML,1)
% hold on
% 
% step(G,'r')
% 
% 
% title('Step responses of controlled and uncontrolled plants');
% hold off
