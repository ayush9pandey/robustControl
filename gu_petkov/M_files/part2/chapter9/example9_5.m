% Example 9.5
%
s = tf('s');
%
% Plant transfer matrix
g11 = 6/((0.9*s + 1)*(0.1*s + 1));
g12 = -0.05/(0.1*s + 1);
g21 = 0.07/(0.3*s + 1);
g22 = 5/((1.8*s - 1)*(0.06*s+1));
G = [g11 g12; g21 g22];
%
% Controller transfer matrix
k11 = 7*(s + 1)/(0.3*s + 1);
k12 = 0;
k21 = 0;
k22 = 18*(s + 2)/(s + 1);
K = [k11 k12; k21 k22];
%
% Determine sensitivity functions
looptransfer = loopsens(G,K);
Si = looptransfer.Si;
Ti = looptransfer.Ti;
So = looptransfer.So;
To = looptransfer.To;
Li = looptransfer.Li;
Lo = looptransfer.Lo;
%
% Transient responses
tfin = 1;
%
% reference response 
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 1.0; ref2(1:nstep) = 0.0;
ref = [ref1' ref2'];
figure(1)
subplot(2,2,1)
[y,t] = lsim(To(1:2,1:2),ref,time);
plot(t,y(:,1),'r-')
grid
title('From ref 1 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
figure(1)
subplot(2,2,3)
plot(t,y(:,2),'b-')
grid
title('From ref 1 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
%
time = 0:tfin/500:tfin;
nstep = size(time,2);
ref1(1:nstep) = 0.0; ref2(1:nstep) = 1.0;
ref = [ref1' ref2'];
figure(1)
subplot(2,2,2)
[y,t] = lsim(To(1:2,1:2),ref,time);
plot(t,y(:,1),'r-')
grid
title('From ref 2 to outp 1')
xlabel('Time (secs)')
ylabel('y_1')
%
figure(1)
subplot(2,2,4)
plot(t,y(:,2),'b-')
grid
title('From ref 2 to outp 2')
xlabel('Time (secs)')
ylabel('y_2')
%
% input disturbance response
time = 0:tfin/500:tfin;
nstep = size(time,2);
dist1(1:nstep) = 1.0; dist2(1:nstep) = 0.0;
dist = [dist1' dist2'];
figure(2)
subplot(2,2,1)
sys = G*Si;
[y,t] = lsim(sys(1:2,1:2),dist,time);
plot(t,y(:,1),'r-')
grid
title('From dist 1 to output 1')
xlabel('Time (secs)')
ylabel('y_1')
figure(2)
subplot(2,2,3)
plot(t,y(:,2),'b-')
grid
title('From dist 1 to output 2')
xlabel('Time (secs)')
ylabel('y_2')
%
time = 0:tfin/500:tfin;
nstep = size(time,2);
dist1(1:nstep) = 0.0; dist2(1:nstep) = 1.0;
dist = [dist1' dist2'];
figure(2)
subplot(2,2,2)
[y,t] = lsim(sys(1:2,1:2),dist,time);
plot(t,y(:,1),'r-')
grid
title('From dist 2 to output 1')
xlabel('Time (secs)')
ylabel('y_1')
%
figure(2)
subplot(2,2,4)
plot(t,y(:,2),'b-')
grid
title('From dist 2 to output 2')
xlabel('Time (secs)')
ylabel('y_2')
%
% output disturbance response
time = 0:tfin/500:tfin;
nstep = size(time,2);
dist1(1:nstep) = 1.0; dist2(1:nstep) = 0.0;
dist = [dist1' dist2'];
figure(3)
subplot(2,2,1)
[y,t] = lsim(So(1:2,1:2),dist,time);
plot(t,y(:,1),'r-')
grid
title('From dist 1 to output 1')
xlabel('Time (secs)')
ylabel('y_1')
figure(3)
subplot(2,2,3)
plot(t,y(:,2),'b-')
grid
title('From dist 1 to output 2')
xlabel('Time (secs)')
ylabel('y_2')
%
time = 0:tfin/500:tfin;
nstep = size(time,2);
dist1(1:nstep) = 0.0; dist2(1:nstep) = 1.0;
dist = [dist1' dist2'];
figure(3)
subplot(2,2,2)
[y,t] = lsim(So(1:2,1:2),dist,time);
plot(t,y(:,1),'r-')
grid
title('From dist 2 to output 1')
xlabel('Time (secs)')
ylabel('y_1')
%
figure(3)
subplot(2,2,4)
plot(t,y(:,2),'b-')
grid
title('From dist 2 to output 2')
xlabel('Time (secs)')
ylabel('y_2')

clear time
clear ref1;  clear ref2;
clear dist1; clear dist2;