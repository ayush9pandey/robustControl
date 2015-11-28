% Example 11.2
%
% Mixed sensitivity Hinfty design of two channel MIMO system
%
s = tf('s');
%
g11 = 12/(0.2*s + 1);
g12 = -0.05/(0.1*s + 1);
g21 = 0.1/(0.3*s + 1);
g22 = 5/(0.7*s - 1);
Gnom = [g11 g12; g21 g22];
%
w1 = makeweight(0.1,20,10);
w2 = makeweight(0.2,25,10);
W = blkdiag(w1,w2);
Delta_1 = ultidyn('Delta_1',[1 1]);
Delta_2 = ultidyn('Delta_2',[1 1]);
Delta = blkdiag(Delta_1,Delta_2);
G = (eye(2) + Delta*W)*Gnom;
%
% Set up the performance and robustness bounds
W1 = (s + 10)/(2*s + 0.3);
W3 = (s + 10)/(0.05*s + 20);
%
% Compute the H-infinity mixed sensitivity optimal controller
[K_h,cl_h,gam] = mixsyn(Gnom,W1,[],W3);
gam
get(K_h)
cls_poles = pole(cl_h)
looptransfer = loopsens(Gnom,K_h);
L = looptransfer.Lo;
T = looptransfer.To;
I = eye(size(L));
figure(1)
omega = logspace(-1,3,100);
sigma(I+L,'b-',W1/gam,'r--',T,'b-.',gam/W3,'r.',omega)
grid
legend('1/\sigma(S) performance','\sigma(W1) performance bound', ...
       '\sigma(T) robustness','\sigma(1/W3) robustness bound',3) 
figure(2)
omega = logspace(-1,3,100);
sigma(L,'b-',W1/gam,'r--',gam/W3,'r.',omega)
grid
legend('\sigma(L)','\sigma(W1) performance bound', ...
       '\sigma(1/W3) robustness bound',3)
figure(3)
omega = logspace(-1,3,100);
sigma(K_h,omega)
grid
title('Singular values of K')
%
looptransfer = loopsens(G,K_h);
S = looptransfer.So;
T = looptransfer.To;
figure(4)
omega = logspace(-2,2,100);
sigma(S,omega)
grid
title('Sensitivity of the uncertain system')
figure(5)
omega = logspace(-1,2,100);
sigma(T,omega)
grid
title('Complementary sensitivity of the uncertain system')
%
% Transient responses of the uncertain system
tfin = 4;
%
% reference response 
nsample = 30;
[T30,samples] = usample(T,nsample);
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 1.0; ref2(1:nstep) = 0.0;
ref = [ref1' ref2'];
figure(6)
subplot(2,2,1)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,1),'r-')
    hold on
end 
grid
title('From inp 1 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
figure(6)
subplot(2,2,3)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,2),'b-')
    hold on
end 
grid
title('From inp 1 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
%
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 0.0; ref2(1:nstep) = 1.0;
ref = [ref1' ref2'];
figure(6)
subplot(2,2,2)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,1),'r-')
    hold on
end 
grid
title('From inp 2 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
%
figure(6)
subplot(2,2,4)
hold off
for i = 1:nsample
    [y,t] = lsim(T30(1:2,1:2,i),ref,time);
    plot(t,y(:,2),'b-')
    hold on
end 
grid
title('From inp 2 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
clear ref1;  clear ref2;