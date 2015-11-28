% Plot time-varying parameter
%
time = 0:0.1:100;
%
for i = 1:1001
    t = time(i);
    p(i) = 2.0/4.68 + 3.5*abs(sin(0.1*t));
end
%
figure(1)
plot(time,p)
grid
xlabel('Time (s)')
ylabel('p')
title('Time-varying parameter')