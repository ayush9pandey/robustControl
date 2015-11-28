% Example 9.3
%
s = tf('s');
g11 = 10*(s + 1)/(s^2 + 0.2*s + 100);
g12 = 1/(s + 1);
g21 = (s + 2)/(s^2 + 0.1*s + 10);
g22 = 5*(s + 1)/((s + 2)*(s + 3));
G = [g11 g12 ;g21 g22];
%
figure(1)
sigma(G,{10^0 10^2})
grid
norm(G,'inf')