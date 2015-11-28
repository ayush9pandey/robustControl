% Example 9.6
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
        diff = G_frd - Gnom_frd;
        bodemag(diff,'c--',omega)
        hold on
    end
end
grid
temp1 = 'Approximation of uncertain transfer function';
temp2 = ' by additive uncertainty';
title([temp1 temp2])
legend('|Wa(j\omega)|','|G(j\omega)-G_{nom}(j\omega)|',3)
%
% second-order fit
ord = 2;      
wfit 
Wa = Wtf
Delta_a = ultidyn('Delta_a',[1 1]);
G = Gnom + Wa*Delta_a