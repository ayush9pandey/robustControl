% Fits a logarithmic frequency response with a stable,
% minimum phase 1st order transfer function
%
[freq,resp_db] = ginput(20);       % pick 20 points
for i = 1:20                       % Converts the logarithmic response
    resp(i) = 10^(resp_db(i)/20);  % to a magnitude response
end                                %
sys = frd(resp,freq);              % creates frd object
W = fitmagfrd(sys,ord);            % fits the frequency response
Wtf = tf(W);                       % converting into transfer function form