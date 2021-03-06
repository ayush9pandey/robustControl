%Distillation process TF%
s=tf('s');
L=[87.8 -86.4;108.2 -109.6];
G=L/(75*s+1);
Linv=[0.3994   -0.3149;
    0.3943   -0.3200];
K=(0.7*(75*s+1)*Linv)/s;
Wp=(s+0.1)/(2*s);
Wo=(s+0.2)/(0.5*s+1);
Lo=minreal(G*K,0.1);
Lo=Lo(1,1);
T=minreal(feedback(Lo,eye(1)),0.1);
S=minreal((eye(1)-T),0.1);


TF1=minreal(-Wo*T,0.1);
TF2=minreal(Wo*S*G,0.1);
TF3=minreal(Wp*S,0.2);
TF4=minreal(Wp*S*G,0.2);

flag=isstable(TF1);
if flag == 1
    display('TF1 is stable');
    
else display('Nominal Stability violated');
end

flag=isstable(TF2);
if flag == 1
    display('TF2 is stable');
    
else display('Nominal Stability violated');
end

flag=isstable(TF3);
if flag == 1
    display('TF3 is stable');
    
else display('Nominal Stability violated');
end

flag=isstable(TF4);
if flag == 1
    display('TF4 is stable');
    
else display('Nominal Stability violated');
end

hinfnorm(Wo*T)
hinfnorm(Wp*S)
hinfnorm(Wp*S*G)