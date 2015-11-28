% Example 9.4
%
s = tf('s');
%
% Plant transfer matrix
g11 = 6/((0.9*s + 1)*(0.1*s + 1));
g12 = -0.05/(0.1*s + 1);
g21 = 0.07/(0.3*s + 1);
g22 = 5/((1.8*s - 1)*(0.06*s+1));
G = [g11 g12; g21 g22];
%
% Controller transfer matrix
k11 = 7*(s + 1)/(0.3*s + 1);
k12 = 0;
k21 = 0;
k22 = 18*(s + 2)/(s + 1);
K = [k11 k12; k21 k22];
%
% Determine sensitivity functions
looptransfer = loopsens(G,K);
looptransfer.Poles
Si = looptransfer.Si;
Ti = looptransfer.Ti;
So = looptransfer.So;
To = looptransfer.To;
Li = looptransfer.Li;
Lo = looptransfer.Lo;
%
figure(1)
subplot(2,1,1)
sigma(Si)
title('Input sensitivity function')
grid
figure(1)
subplot(2,1,2)
sigma(Ti)
title('Input complementary sensitivity function')
grid
%
figure(2)
subplot(2,1,1)
sigma(So)
title('Output sensitivity function')
grid
figure(2)
subplot(2,1,2)
sigma(To)
title('Output complementary sensitivity function')
grid
%
figure(3)
sigma(K*So)
title('Sensitivity to noise at plant input')
grid
%
figure(4)
sigma(Lo)
title('Output loop transfer function')
grid