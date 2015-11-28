% Example 9.2
%
s = tf('s');
g11 = 6/((0.9*s + 1)*(0.1*s + 1));
g12 = -0.05/(0.1*s + 1);
g21 = 0.07/(0.3*s + 1);
g22 = 5/((1.8*s - 1)*(0.06*s+1));
G = [g11 g12; g21 g22]
%
% Plant singular values
figure(1)
sigma(G,{10^(-2) 10^3})
title('Plant singular values')
grid