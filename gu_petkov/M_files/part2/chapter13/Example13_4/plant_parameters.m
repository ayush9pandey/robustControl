% Plant parameters
%
L  = 900; % m
Hr = 150; % m
Ap = 8.5; % m^2
Qr = 65.0;% m^3/s
ag = 9.81;% m/s^2
kp = 0.9;
G0 = 0.02;
H0 = 1.0; 
%
Ur = Qr/Ap;
Pr = kp*Hr*Ur;
k  = L*Pr/(ag*kp*Hr^2);
Ts = 3;