%%%%Builds uncertainity model for the system G=[k/10s+1 1/Ts+1]%%%%
% K = 5 +- 30%
% T = 0.5 +- 10%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K=ureal('K',5,'Percentage',10)
T=ureal('T',0.5,'Percentage',10)

%Uncertain state space model%
s=tf('s');
G1=[K/(10*s+1);1/T*s+1]

%%%%Builds uncertainity model for the system T(s)=(b0*s+b1)/(a0*s^2+2a0*s+s1),%%%%
%with uncertain parameters of nominal values of a0,a1, b0,b1 = 0.9,2,0.2,1 and
%uncertainity of +-30%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


a0=ureal('a0',0.9,'Percentage',30)
a1=ureal('a1',2,'Percentage',30)
b0=ureal('b0',0.2,'Percentage',30)
b1=ureal('b1',1,'Percentage',30)
%Uncertain state space model%
G2=tf([b0,b1],[a0,a0,a1])