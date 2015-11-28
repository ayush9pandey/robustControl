% Example 10.2
%
s = tf('s');
%
% Nominal plant transfer matrix
g11 = 6/((0.9*s + 1)*(0.1*s + 1));
g12 = -0.05/(0.1*s + 1);
g21 = 0.07/(0.3*s + 1);
g22 = 5/((1.8*s - 1)*(0.06*s+1));
Gnom = [g11 g12; g21 g22];
%
% Input uncertainty
W1 = makeweight(0.20,35,10);
W2 = makeweight(0.25,40,10);
Delta1 = ultidyn('Delta1',[1 1]);
Delta2 = ultidyn('Delta2',[1 1]);
%
% Uncertainty model
W = blkdiag(W1,W2);
Delta = blkdiag(Delta1,Delta2);
G = Gnom*(eye(2) + Delta*W)
%
% Controller transfer matrix
k11 = (2*s + 1)/s;
k12 = -s/(3*s + 1);
k21 = -5*(s + 1)/(0.8*s + 1);
k22 = 4*(0.7*s + 1)/s;
K  = [k11 k12; k21 k22];
%
% Closed-loop connection with weighting functions
wp = 0.04*(s + 10)/(s + 0.005);
Wp = blkdiag(wp,wp);
wu = 4.0*10^(-2)*(0.01*s+1)/(0.005*s+1);
Wu = blkdiag(wu,wu);
systemnames = ' G K Wp Wu ';
inputvar = '[ ref{2}; dist{2} ]';
outputvar = '[ Wp; Wu ]';
input_to_G = '[ K ]';
input_to_K = '[ ref-G-dist ]';
input_to_Wp = '[ ref-G-dist ]';
input_to_Wu = '[ K ]';
clp = sysic;
%
% Nominal performance
norm(clp.Nom,'inf')
%
% Robust performance analysis
omega = logspace(-1,2,200);
clp_g = ufrd(clp,omega);
opt = robopt('Display','on');
[perfmarg,perfmargunc,report,info] = robustperf(clp_g,opt);
perfmarg
%
report
%
perfmargunc.Delta1
perfmargunc.Delta2
%
% Worst-case performance
figure(1)
omega = logspace(-1,3,500);
sigma(clp,'b-',usubs(clp,perfmargunc),'r-',omega)
axis([10^(-1) 10^3 -40 10])
grid
legend('Random perturbations','Worst-case perturbations')
%
figure(2)
semilogx(info.MussvBnds(1,1),'r-',info.MussvBnds(1,2),'b--')
grid
title('Robust performance')
xlabel('Frequency (rad/s)')
ylabel('mu')
legend('\mu-upper bound','\mu-lower bound',2)
%
[pkl,pklidx] = max(info.MussvBnds(1,2).ResponseData(:));
[pku,pkuidx] = max(info.MussvBnds(1,1).ResponseData(:));
pkmu.UpperBound = pku;
pkmu.LowerBound = pkl;
pkmu
%
% closed-loop system
systemnames = ' G K ';
inputvar = '[ ref{2}; dist{2} ]';
outputvar = '[ G+dist; K  ]';
input_to_G = '[ K ]';
input_to_K = '[ ref-G-dist ]';
cls = sysic;
%
To = cls(1:2,1:2);
So = cls(1:2,3:4);
KSo = cls(3:4,3:4);
%
figure(3)
omega = logspace(-2,2,100);
sigma(To,'b--',usubs(To,perfmargunc),'r-',omega)
grid
title('Closed-loop singular value plot')
legend('Random perturbations','Worst-case perturbations',3)
%
figure(4)
omega = logspace(-3,2,100);
sigma(inv(Wp),'r-',So,'b--',omega)
axis([10^(-3) 10^2 -100 40])
grid
title('Output sensitivity of the uncertain system')
legend('1/Wp','S_o',4)
%
figure(5)
omega = logspace(-2,4,100);
sigma(inv(Wu),'r-',KSo,'b--',omega)
grid
title('Sensitivity of control to disturbance')
legend('1/Wu','K*S_o',4)
%
% Transient responses
%
tfin = 5;
%
% reference response 
nsample = 30;
[To30,samples] = usample(To,nsample);
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 1.0; ref2(1:nstep) = 0.0;
ref = [ref1' ref2'];
nsample = 30;
[To30,samples] = usample(To,nsample);
figure(6)
subplot(2,2,1)
hold off
for i = 1:nsample
    [y,t] = lsim(To30(1:2,1:2,i),ref,time);
    plot(t,y(:,1),'r-')
    hold on
end 
grid
title('From inp 1 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
figure(6)
subplot(2,2,3)
hold off
for i = 1:nsample
    [y,t] = lsim(To30(1:2,1:2,i),ref,time);
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
figure(6)
subplot(2,2,2)
hold off
for i = 1:nsample
    [y,t] = lsim(To30(1:2,1:2,i),ref,time);
    plot(t,y(:,1),'r-')
    hold on
end 
grid
title('From inp 2 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
%
figure(6)
subplot(2,2,4)
hold off
for i = 1:nsample
    [y,t] = lsim(To30(1:2,1:2,i),ref,time);
    plot(t,y(:,2),'b-')
    hold on
end 
grid
title('From inp 2 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
clear ref1;  clear ref2;