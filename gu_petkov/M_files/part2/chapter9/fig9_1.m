% Singular Value Plot of a multivariable system
%
a0 = [ 0     1.0   0     0.1   0     0
      -1.0  -0.7   0     0     0     0
       0     0     0     1.0   0     0.1
       0     0    -1.0  -0.5   0     0
       0     0     0     0     0     1.0
       0     0     0     0    -1.0  -0.2];
   
b0 = [-1     0     2     1
       3     1     0    -1
       0     2    -3     1
       1    -2     1     3
       2     1    -2    -1
       1     5    -2     4];

c0 = [-2     3     1     0     3     4
       1     0    -2     5    -1     3
       0     7     2     1     0    -1
       4    -1     8     3     1    -6];
    
s = [1     0     1     0     0    -1
     0     1     0     1     0     0
     0     0     1     0     0     1
     0     0     0     1     0     0
     0     0     0     0     1     0
     0     0     0     0     0     1];
 
t = s/s';
a = t*a0/t; b = t*b0; c = c0/t; d = zeros(4);
sys = ss(a,b,c,d);
omega = logspace(-2,4,200);
sigma(sys,omega) 
grid
title('Singular Value Plot')