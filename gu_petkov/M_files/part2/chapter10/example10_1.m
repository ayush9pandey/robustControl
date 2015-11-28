% Example 10.1
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
figure(1)
omega = logspace(0,4,200);
bodemag(W1,'r-',W2,'b--',omega), grid
title('Magnitude responses of weighting filters')
legend('W_1','W_2',2)
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
% Robust stability analysis by using the input complementary sensitivity
[PeakNorm,freq] = norm(W*Ti.Nominal,'inf')
%
% Robust stability analysis with robuststab
omega = logspace(-1,2,200);
To_g = ufrd(To,omega);
opt = robopt('Display','on');
[stabmarg,destabunc,report,info] = robuststab(To_g,opt);
stabmarg
%
report
%
destabunc.Delta1
destabunc.Delta2
%
tf(destabunc.Delta1)
tf(destabunc.Delta2)
%
pole(usubs(To,destabunc))
%
figure(2)
semilogx(info.MussvBnds(1,1),'r-',info.MussvBnds(1,2),'b--')
grid
title('Robust stability')
xlabel('Frequency (rad/s)')
ylabel('mu')
legend('\mu-upper bound','\mu-lower bound',2)

%
% Robust stability analysis with mussv
[M,Delta,BlockStructure] = lftdata(To);
size_Delta = size(Delta);
M11 = M(1:size_Delta(2),1:size_Delta(1));
omega = info.Frequency;
M11_g = frd(M11,omega);
rbounds = mussv(M11_g,BlockStructure);
figure(3)
semilogx(rbounds(1,1),'r-',rbounds(1,2),'b--')
grid
title('Robust stability')
xlabel('Frequency (rad/s)')
ylabel('mu')
legend('\mu-upper bound','\mu-lower bound',2)