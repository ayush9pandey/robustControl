s=tf('s');
% %%%%%%%%%% system 1  %%%%%%%
% g11=1/(s+1);
% g12=0;
% g21=0;
% g22=1/(s+2);
% G_nom=[g11 g12;g21 g22]
% k11=(s-1)/(s+1);
% k12=1;
% k21=0;
% k22=1;
% K=[k11 k12;k21 k22]
% M=K*((eye(2)+K*G_nom)^-1)
% hinfnorm(M)


%%%%%%%   system 2   %%%%%%%
g11=10*(s+1)/(s^2+0.2*s+100);
g12=1/(s+1);
g21=(s+2)/(s^2+0.1*s+10);
g22=5*(s+1)/((s+2)*(s+3));
G_nom=[g11 g12;g21 g22]
k11=(s-1)/(s+1);
k12=1;
k21=0;
k22=1;
K=[k11 k12;k21 k22]
M=-K*((eye(2)+K*G_nom)^-1)
M_inf_norm=hinfnorm(M)
unc_inf_norm=1/M_inf_norm;
display('The maximum of the inf norm of uncertainity that the system can take is');
unc_inf_norm

