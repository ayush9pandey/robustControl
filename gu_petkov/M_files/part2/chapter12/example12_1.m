% Example 12.1
%
% mu-synthesis of two-channel MIMO system
%
s = tf('s');
%
k1 = ureal('k1',12,'Percentage',15);
T1 = ureal('T1',0.2,'Percentage',20);
k2 = ureal('k2',5,'Percentage',15);
T2 = ureal('T2',0.7,'Percentage',20);
%
g11 = tf(k1,[T1 1]);
g12 = tf(-0.05,[0.1 1]);
g21 = tf(0.1,[0.3 1]);
g22 = tf(k2,[T2  -1]);
G = [g11 g12; g21 g22];
%
% open-loop connection with weighting functions
wp = 0.5*(s + 10)/(s + 0.3);
Wp = blkdiag(wp,wp);
wu = 10^(-1)*(0.001*s+1)/(0.0001*s+1);
Wu = blkdiag(wu,wu);
systemnames = ' G Wp Wu ';
inputvar = '[ ref{2}; dist{2}; control{2} ]';
outputvar = '[ Wp; Wu; ref-G-dist ]';
input_to_G = '[ control ]';
input_to_Wp = '[ ref-G-dist ]';
input_to_Wu = '[ control ]';
sys_ic = sysic;
%
nmeas = 2;
ncont = 2;
fv = logspace(-3,3,100);
opt = dkitopt('FrequencyVector',fv, ...
              'DisplayWhileAutoIter','on', ...
              'NumberOfAutoIterations',3)
[K,cl_mu,bnd_mu,dkinfo] = dksyn(sys_ic,nmeas,ncont,opt);
get(K)
%
figure(1)
clf
omega = logspace(-1,2,100);
sigma(G.Nominal,'r-',G,'b--',omega), grid
title('Singular value plot of the uncertaint plant')
legend('Nominal system','Random samples')
%
figure(2)
clf
omega = logspace(-1,3,100);
sigma(K,omega)
grid
title('Singular values of K')
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
looptransfer = loopsens(G,K);
Lo = looptransfer.Lo;
So = looptransfer.So;
To = looptransfer.To;
KSo = K*So;
%
figure(5)
omega = logspace(-1,3,100);
sigma(To.Nominal,'r-',To,'b--',omega)
grid
title('Singular values of the closed-loop system')
legend('Nominal system','Random samples')
%
figure(6)
omega = logspace(-2,2,100);
sigma(inv(Wp),'r-',So,'b--',omega)
grid
title('Output sensitivity of the uncertain system')
legend('1/Wp','So',4)
%
figure(7)
omega = logspace(-1,4,100);
sigma(inv(Wu),'r-',KSo,'b--',omega)
grid
title('Input sensitivity of the uncertain system')
legend('1/Wu','KSo',3)
%
% Transient responses of the uncertain system
tfin = 4;
%
% reference response 
nsample = 30;
[T30,samples] = usample(To,nsample);
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 1.0; ref2(1:nstep) = 0.0;
ref = [ref1' ref2'];
figure(8)
subplot(2,2,1)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,1),'r-')
    hold on
end 
grid
title('From inp 1 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
figure(8)
subplot(2,2,3)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,2),'b-')
    hold on
end 
grid
title('From inp 1 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
%
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 0.0; ref2(1:nstep) = 1.0;
ref = [ref1' ref2'];
figure(8)
subplot(2,2,2)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,1),'r-')
    hold on
end 
grid
title('From inp 2 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
%
figure(8)
subplot(2,2,4)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,2),'b-')
    hold on
end 
grid
title('From inp 2 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
clear ref1;  clear ref2;