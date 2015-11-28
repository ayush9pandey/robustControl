function alpha = alpha_eval(u)
%
% Evaluation of alpha1, alpha2
%
L = 900;
Hr = 150;
Ap = 8.5;
Qr = 65.0;
H0 = 1.0;
ag = 9.81;
kp = 0.9;
%
Ur = Qr/Ap;
Pr = Hr*Ur*kp;
P0 = Pr*u;
Tw = L*P0/(ag*kp*Hr^2);
%
pv =[1.0    0.427615384615385    4.276153846153846      0      0;
     1.0             0                    0             0      0];
%
alpha = polydec(pv,2.0/Tw);
