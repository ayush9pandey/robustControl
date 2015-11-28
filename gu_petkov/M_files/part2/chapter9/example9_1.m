% Example 9.1
%
A = [-1  0  5 
      2  1 -4 
     -6 -3 -2 ];
B = [ 5  0  
     -4  1  
      0  6 ];
C = [-1  0 -4
      2  3  6 ];
D = [ 3 -2 
     -4  1];
%
Gss = ss(A,B,C,D)
Gtf = tf(Gss)
p = pole(Gss)
z = zero(Gss)
p = pole(Gtf)
z = zero(Gtf)
G = ss(Gtf)
G = ss(Gtf,'min')