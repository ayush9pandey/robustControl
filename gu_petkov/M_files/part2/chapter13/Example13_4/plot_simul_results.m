% Plot simulation results from gain scheduling design
%
figure(1)
plot(t,ref.signals.values,'r--',t,P_hinf.signals.values,'b-','LineWidth',1)
grid
xlabel('Time (secs)')
ylabel('P')
title('System Output')
legend('Reference','System Output',4)
figure(2)
plot(t,U_hinf.signals.values,'r-','LineWidth',1)
grid
xlabel('Time (secs)')
ylabel('U')
title('Control Action')