%Distillation process TF%
s=tf('s');
L=[87.8 -86.4;108.2 -109.6];
G=L/(75*s+1);
K=(0.7*(75*s+1)*inv(L)/s);
Wp=(s+0.1)/(2*s);
Wo=(s+0.2)/(0.5*s+1);
TF1=G;
flag=isstable(TF1);
if flag == 1
    display('TF1 is stable');
end

