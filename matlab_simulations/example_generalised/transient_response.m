G=[1/(s+1) (0.5*s+0.2)/((s+0.3)*(s+1));(-0.7)/(0.2*s+1) (1)/(s+0.3)];
K=[7*(s+1)/(0.3*s+1) 0;0 18*(s+2)/(s+1)];
looptransfer=loopsens(G,K);
To=looptransfer.To;
tfin = 1;
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 0.0;
ref2(1:nstep) = 1.0;
ref = [ref1' ref2'];
[y,t] = lsim(To(1:2,1:2),ref,time);
plot(t,y(:,1),'r-') 
grid
title('From ref 2 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')