function [A] = makea1(x,M,L)

N = length(x) - M*L;
J = 1;

for i = 1:M
    A(:,i) = x(1+(i-1)*L:J:1+(N-1)*J+(i-1)*L)
end
end