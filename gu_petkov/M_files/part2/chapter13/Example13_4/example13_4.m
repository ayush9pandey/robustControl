% Example 13.4
%
% Gain scheduling design of Parameter-Dependent System 
%
plant_parameters
%
% servo system time constant
Ts = 3;
%
% construct the parameter-dependent plant
A_0 = [-1/Ts  0;2/Ts  0]; B_0 = [1/Ts  -2/Ts]'; C_0 = [0  1]; D_0 = 0;
S_0 = ltisys(A_0,B_0,C_0,D_0,1);
%
A_p = [0   0;1  -1]; B_p = [0  0]'; C_p = [0  0]; D_p = 0;
S_p = ltisys(A_p,B_p,C_p,D_p,0);
%
% determine the range of time constant Tw
P0 = 1.0;
Tw1 = L*P0*Pr/(ag*kp*Hr^2);
P0 = 0.1;
Tw2 = L*P0*Pr/(ag*kp*Hr^2);
%
pv = pvec('box',[2.0/Tw1 2.0/Tw2]);
pds = psys(pv,[S_0 S_p]);
%
% plant interconnection
[pdP,nmc] = sconnect('r','e=r-G(1);K','K:[r;G]','G:K',pds);
display('Number of measurements and controls')
nmc
%
% weighting functions
wts_ht_gs
%
% plant extension with weighting functions 
Paug = smult(pdP,sdiag(Wp,Wu,eye(2)));
%
% Hinf gain scheduling design
[gopt,pdK] = hinfgs(Paug,nmc);
gopt
%
% closed-loop system
pCL = slft(pdP,pdK);
%
% stability analysis
tmin = pdlstab(pCL)
%
% closed-loop simulation
figure(1)
plot_par_ht
tf = 100;
[t,x,y] = pdsimul(pCL,'traj_ht',tf);
figure(2)
plot(t,1-y(:,1)) % r-e
title('System output')
xlabel('Time (s)')
ylabel('P_m(t)')
grid
figure(3)
plot(t,y(:,2))   % u
title('Gain-scheduled controller action')
xlabel('Time (s)')
ylabel('Controller action')
grid
%
% computation of K_1 and K_2
K_1 = psinfo(pdK,'sys',1)
K_2 = psinfo(pdK,'sys',2)
% 
[ns,ni,no] = sinfo(K_1);
%
% controller matrices
Ac1 = K_1(1:ns,1:ns);
Ac2 = K_2(1:ns,1:ns);
Bc1 = K_1(1:ns,ns+1:ns+ni);
Bc2 = K_2(1:ns,ns+1:ns+ni);
Cc1 = K_1(ns+1:ns+no,1:ns);
Cc2 = K_2(ns+1:ns+no,1:ns);