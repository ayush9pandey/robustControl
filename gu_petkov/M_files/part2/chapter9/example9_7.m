% Example 9.7
%
omega = logspace(-1,3,100);
%
K0 = 1.0; T0 = 1/15; 
Gnom = tf([K0],[T0 1]);
Gnom_frd = frd(Gnom,omega);
figure(1)
hold off
for K = 0.8*K0:0.08*K0:1.2*K0
    for T = 0.7*T0:0.06*T0:1.3*T0
        G = tf([K],[T 1]);
        G_frd = frd(G,omega);
        reldiff = (G_frd - Gnom_frd)/Gnom_frd;
        bodemag(reldiff,'c--',omega)
        hold on
    end
end
grid
temp1 = 'Approximation of uncertain transfer function';
temp2 = ' by multiplicative uncertainty';
title([temp1 temp2]);
legend('|Wm(j\omega)|',...
       '|(G(j\omega)-G_{nom}(j\omega))/G_{nom}(j\omega)|',3)
%
% first-order fit  
ord = 1;      
wfit  
Wm = Wtf
Delta_m = ultidyn('Delta_m',[1 1]);
G = Gnom*(1 + Wm*Delta_m)
figure(2)
bode(Gnom,'r--',G,'b-',omega)
title('Bode plot of the uncertainty model')
grid