% Example 12.2
%
% mu-synthesis of 1-dof controller for the mass/damper/spring system
%
s = tf('s');
%
% Uncertain model of the Mass/Damper/Spring system
m = ureal('m',3,'Percentage',40);
c = ureal('c',1,'Percentage',20);
k = ureal('k',2,'Percentage',30);
%
u = icsignal(1);
x = icsignal(1);
xdot = icsignal(1);
M = iconnect;
M.Input = u;
M.Output = x;
M.Equation{1} = equate(x,tf(1,[1,0])*xdot);
M.Equation{2} = equate(xdot,tf(1/m,[1,0])*(u-k*x-c*xdot));
G = M.System;
%
% Extended system
%
% model
nuM = 1;
dnM = [1.0^2  2*0.7*1.0  1];     % T = 1.0 s, ksi = 0.7
gainM = 1.0;
M = gainM*tf(nuM,dnM);
%
% performance weight
tol = 10^(-2);
nuWp = [2  1];  
dnWp = [2  tol];
gainWp = 5*10^(-1);
Wp = gainWp*tf(nuWp,dnWp);
%
% control action weight
nuWu = [0.05    1];
dnWu = [0.0001  1];
gainWu = 5.0*10^(-2);
Wu = gainWu*tf(nuWu,dnWu);
%
% open-loop connection with the weighting functions
systemnames = ' G M Wp Wu ';
inputvar = '[ ref; dist; control ]';
outputvar = '[ Wp; Wu; ref-G-dist ]';
input_to_G = '[ control ]';
input_to_M = '[ ref ]';
input_to_Wp = '[ G+dist-M ]';
input_to_Wu = '[ control ]';
sys_ic = sysic;
%
nmeas = 1;
ncont = 1;
fv = logspace(-3,2,200);
iter = 3;
opt = dkitopt('FrequencyVector',fv, ...
              'DisplayWhileAutoIter','on', ...
              'NumberOfAutoIterations',iter)
[K_mu,CL_mu,bnd_mu,dkinfo] = dksyn(sys_ic,nmeas,ncont,opt);
K = K_mu;
get(K)
%
figure(1)
clf
omega = logspace(-1,1,100);
bode(G.Nominal,'r-',G,'b--',omega), grid
title('Bode plot of the uncertaint plant')
legend('Nominal system','Random samples')
%
figure(2)
omega = logspace(-3,2,100);
bode(K,'r-',omega)
grid
title('Controller Bode plot')
%
% Weighted closed-loop system
clp_ic = lft(sys_ic,K);
omega = logspace(-2,2,100);
clp_g = ufrd(clp_ic,omega);
%
% Robust stability 
opt = robopt('Display','on');
[stabmarg,destabu,report,info] = robuststab(clp_g,opt);
report
figure(3)
semilogx(info.MussvBnds(1,1),'r-',info.MussvBnds(1,2),'b--')
grid
title('Robust stability')
xlabel('Frequency (rad/s)')
ylabel('mu')
legend('\mu-upper bound','\mu-lower bound',1)
%
% Robust performance 
opt = robopt('Display','on');
[perfmarg,perfmargunc,report,info] = robustperf(clp_g,opt);
report
figure(4)
semilogx(info.MussvBnds(1,1),'r-',info.MussvBnds(1,2),'b--')
grid
title('Robust performance')
xlabel('Frequency (rad/s)')
ylabel('mu')
legend('\mu-upper bound','\mu-lower bound',1)
%
% open-loop system
systemnames = ' G ';
inputvar = '[ ref; dist; control ]';
outputvar = '[ G+dist; control; ref-G-dist ]';
input_to_G = '[ control ]';
sim_ic = sysic;
%
% closed-loop system
cls = lft(sim_ic,K);
To = cls(1,1);
So = cls(1,2);
KSo = -cls(2,2);
%
figure(5)
omega = logspace(-2,2,100);
T64 = gridureal(To,'c',4,'k',4,'m',4);
bode(M,'r-',T64,'b--',omega)
grid
title('Closed-loop Bode plot')
legend('Model','Uncertain system',3)
%
figure(6)
omega = logspace(-3,2,100);
S64 = gridureal(So,'c',4,'k',4,'m',4);
bodemag(1/Wp,'r-',S64,'b--',omega)
grid
title('Output sensitivity of the uncertain system')
legend('1/Wp','So',4)
%
figure(7)
omega = logspace(-3,2,100);
KSo64 = gridureal(KSo,'c',4,'k',4,'m',4);
bodemag(1/Wu,'r-',KSo64,'b--',omega)
grid
title('Input sensitivity of the uncertain system')
legend('1/Wu','KSo',3)
%
% Transient response of the uncertain system
cls64 = gridureal(cls,'c',4,'k',4,'m',4);
tfin = 20;   % final time
ti = 0.1;    % sampling time
[ref1,time] = gensig('square',40,60,ti);
ref = 1 - 2*ref1;
nstep = size(time,1);
dist(1:nstep) = 0.0;
figure(8)
hold off
figure(9)
hold off
nsample = 64;
for i = 1:nsample
    [y,t] = lsim(cls64(1:2,1:2,i),[ref,dist'],time);
    figure(8)
    plot(t,ref,'r--',t,y(:,1),'b-')
    hold on
    figure(9)
    plot(t,y(:,2),'r-')
    hold on
end 
figure(8)
grid
title('Closed-loop transient response')
xlabel('Time (secs)')
ylabel('y(t)')
hold off
figure(9)
grid
title('Control action')
xlabel('Time (secs)')
ylabel('u(t)')
hold off
%
% Determine worst case uncertainty
[maxgain,maxgainunc] = wcgain(To);
Twc = usubs(To,maxgainunc);
%
% Worst case frequency response
omega = logspace(-1,2,400);
figure(10)
bodemag(Twc,'r-',T64,'b-.',omega), grid
title('Worst case closed-loop system Bode plot')
legend('Worst case','Uncertain system',3)
%
% Worst case closed-loop transient response
figure(11)
[y,t] = lsim(Twc,ref,time);
plot(t,ref,'r--',t,y(:,1),'b-'), grid
title('Worst case closed-loop transient response')
xlabel('Time (secs)')
ylabel('y(t)')
%
clear ref; clear dist 