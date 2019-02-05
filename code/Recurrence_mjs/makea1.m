function A=makea1(x,N,M,J,L)
% Create trajectory matrix.
% A=makea1(x,N,M,J,L)
% x=data vector
% N=number of points on trajectory (rows)
% M=number of putative state variables (columns)
% J=increment in starting values for each attractor point (typically 1)
% L=time delay (lag)
for i=1:M
 A(:,i)=x(1+(i-1)*L:J:1+(N-1)*J+(i-1)*L);
end;
return
