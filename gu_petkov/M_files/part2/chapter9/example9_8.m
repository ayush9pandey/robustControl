% Example 9.8
%
omega = logspace(-1,3,200);
figure(1)
hold off
for tau = 0:0.01:0.1;
    for i = 1:200
        om = omega(i);
        pert(i) = sqrt((cos(om*tau)-1)^2 + sin(om*tau)^2);
    end
    magg = frd(pert,omega);
    bodemag(magg,'c--')
    hold on
end
grid
temp1 = 'Approximation of uncertain time delay';
temp2 = ' by multiplicative uncertainty';
title([temp1 temp2])
legend('|Wm(j\omega)|', ...
     '|(G(j\omega)-G_{nom}(j\omega))/G_{nom}(j\omega)|',2)
%
% second-order fit
ord = 2;      
wfit 
Wm = Wtf