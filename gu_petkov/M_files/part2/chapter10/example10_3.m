% Example 10.3
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
% Determine sensitivity functions
looptransfer = loopsens(G,K);
Ti = looptransfer.Ti;
To = looptransfer.To;
%
% Worst-case gain
[maxgain,wcunc,info] = wcgain(To);
maxgain
wcunc
tf(wcunc.Delta1)
tf(wcunc.Delta2)
info.Sensitivity
figure(1)
Twc = usubs(To,wcunc);
omega = logspace(-1,3,100);
sigma(Twc,'r-',To.Nominal,'b--',omega), grid
legend('Worst-case gain','Nominal system',3)
figure(2)
step(Twc,'r-',To.Nominal,'b--'), grid
legend('Worst-case gain','Nominal system',4)
%
figure(3)
sigma(Twc,'r-',To,'b--',omega), grid
title('Worst-case gain')
legend('Worst-case gain','Uncertain system',3)
%
figure(4)
step(Twc,'r-',To,'b--'), grid
legend('Worst-case gain','Uncertain system',4)