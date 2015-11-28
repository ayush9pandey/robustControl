% Uncertain models of Mass-Damper-Spring system 
%
% Defining the uncertian parameters
m = ureal('m',3,'Percentage',[-40, 40])
c = ureal('c',1,'Range',[0.8, 1.2])
k = ureal('k',2,'PlusMinus',[-0.6 ,0.6])
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Uncertain state-space model
A = [  0     1     
     -k/m  -c/m];
B = [  0    1/m]';
C = [  1     0];
D = 0;
uss1 = ss(A,B,C,D)
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%
simplify(uss1,'full')
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Uncertain transfer function
uss2 = tf(1,[m,c,k])
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Using the function feedback
s = tf('s');
g1 = (1/s)/m;
int2 = 1/s;
uss3 = feedback(int2*feedback(g1,c),k)
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Properties of uncertain model
get(uss1)
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
uss1.Uncertainty
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
uss1.NominalValue
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
usubs(uss1,'m',3,'c',1,'k',2)
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Bode plot of the uncertain plant
w = logspace(-1,1,100);
figure(1)
bode(uss1,w), grid
title('Bode plot of uncertain system')
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%
% Step responses of the uncertain plant
figure(2)
step(uss1), grid
title('Step responses of uncertain system')
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%
% Uncertain frequency response
w = logspace(-1,1,200);
freqs = frd(uss1,w)
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
figure(3)
bode(freqs), grid
title('Uncertain frequency response')
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
figure(4)
frres = frd(uss2,w)
nyquist(frres), grid
title('Nyquist diagram of uncertain system')
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%
% Step response of the mass-damper-spring system
% for a grid of 50 values of uncertain parameters
figure(5)
step(gridureal(uss3,50)), grid
title('Step response for a grid of 50 values of uncertain parameters')
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Decomposing uncertain object
[Gnom1,Delta1,Blkstruct,Normunc] = lftdata(uss2)
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Using the function interconnection
u = icsignal(1)
x = icsignal(1)
xdot = icsignal(1)
iconnect1 = iconnect;
iconnect1.Input = u;
iconnect1.Output = x;
iconnect1.Equation{1} = equate(x, tf(1,[1,0])*xdot);
iconnect1.Equation{2} = equate(xdot,tf(1,[m,0])*(u-k*x-c*xdot));
iconnect1.System
disp(' ')
disp('Press any key to continue ... ')
disp(' ')
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Using the function sysic
m1 = inv(m);
int1 = 1/s;
int2 = tf(1,[1,0]);
systemnames = 'int1 int2 c k m1';
inputvar = '[u]';
outputvar = '[int2]';
input_to_int1 = '[m1]';
input_to_int2 = '[int1]';
input_to_c = '[int1]';
input_to_k = '[int2]';
input_to_m1 = '[u-c-k]';
uss4 = sysic
