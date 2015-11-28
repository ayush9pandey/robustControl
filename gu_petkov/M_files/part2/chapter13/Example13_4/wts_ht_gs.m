% Performance weighting functions for the hydro turbine
% system
%
tol = 0.01; % 
nuWp = [4.0   1];      
dnWp = [60  tol];
gainWp = 1.6*10^(0);
Wp = ltisys('tf',gainWp*nuWp,dnWp);
%
% control action weights
nuWu = [1.2    1];    % 
dnWu = [0.0024  1];   % 
gainWu = 4.0*10^(-1); %
Wu = ltisys('tf',gainWu*nuWu,dnWu);