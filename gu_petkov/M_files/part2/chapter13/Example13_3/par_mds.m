% Parameter trajectory for the mass-damper-spring system
%
time = 0:0.001:30;
%
for i = 1:30000
    t = time(i);
    x(i) = 3.0 + 1.2*exp(-0.3*t)*cos(10*t);
    y(i) = 2.0 + 0.6*exp(-0.3*t)*sin(10*t);
    z(i) = 0.8 + 0.01*t;
end 
figure(1)
plot3(x,y,z,'r-','LineWidth',1.5), grid
axis([1.8 4.2 1.4 2.6 0.8 1.1])
xlabel('m')
ylabel('k')
zlabel('c')
title('Parameter trajectory')
clear x, clear y, clear z