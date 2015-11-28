
a=[1 0;4 -3];
b=[0;1];
c=[1 1];
d =0;
H=ss(a,b,c,d);
title('SISO Singular Values');
figure(1)
grid on
sigma(H)

am=[-1 0 ;0 -3];
bm=[0 1;2 1];
cm=[1 2;1 0];
dm=0;
Hm=ss(am,bm,cm,dm);
title('MIMO Singular Values');
figure(2)
grid on
sigma(Hm)


