%Distillation process TF%
s=tf('s');
L=[87.8 -86.4;108.2 -109.6];
G=L/(75*s+1);
K=(0.7*(75*s+1)*inv(L)/s);
Wp=(s+0.1)/(2*s);
Wo=(s+0.2)/(0.5*s+1);

TF3=inv(eye(2)+G*K);
flag=isstable(TF3);
if flag == 1
    display('TF3 is stable');
    
else display('Nominal Stability violated');
end
TF4=G*K*TF3;
flag=isstable(TF4);
if flag == 1
    display('TF4 is stable');
    
else display('Nominal Stability violated');
end

TF5=K*TF3;
flag=isstable(TF5);
if flag == 1
    display('TF5 is stable');
    
else display('Nominal Stability violated');
end

TF6=G*TF3;
flag=isstable(TF6);
if flag == 1
    display('TF6 is stable');
    
else display('Nominal Stability violated');
end
