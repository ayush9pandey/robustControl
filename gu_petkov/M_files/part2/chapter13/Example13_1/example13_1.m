% Examlpe13.1
%
% Parameter-dependent mass-damper-spring system
%
% affine model of the mass-damper-spring system
A_0 = [0 1;0 0]; B_0 = [0 1]'; C_0 = [1 0]; D_0 = 0; E_0 = [1 0;0 0];
S_0 = ltisys(A_0,B_0,C_0,D_0,E_0);
%
A_m = [0 0;0 0]; B_m = [0 0]'; C_m = [0 0]; D_m = 0; E_m = [0 0;0 1];
S_m = ltisys(A_m,B_m,C_m,D_m,E_m);
%
A_k = [0 0;-1 0]; B_k = [0 0]'; C_k = [0 0]; D_k = 0; E_k = [0 0;0 0];
S_k = ltisys(A_k,B_k,C_k,D_k,0);
%
A_c = [0 0;0 -1]; B_c = [0 0]'; C_c = [0 0]; D_c = 0; E_c = [0 0;0 0];
S_c = ltisys(A_c,B_c,C_c,D_c,0);
%
range = [1.8 4.2;1.4 2.6;0.8 1.2];
pv_mds = pvec('box',range);
pds_mds = psys(pv_mds,[S_0 S_m S_k S_c]);
psinfo(pds_mds)
pvinfo(pv_mds)
%
% polytopic model of the mass-damper-spring system
pols_mds = aff2pol(pds_mds);
psinfo(pols_mds)
nom_sys = psinfo(pds_mds,'eval',[3.0 2.0 1.0])