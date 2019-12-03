x = 0:0.1:50;
y = exp(-0.05*x).*sin(x);
plot(x,y);
[L,embDim,corrDim,std_corrDim] = vcorrdim(y,3,7)
A = makea1(y,embDim,L);
figure
plot(A(:,1),A(:,2))

%%

y2 = y + 0.2*cos(4*x - 0.2);
plot(x,y2)
[L,embDim,corrDim,std_corrDim] = vcorrdim(y2,3,7);
figure
mk3plot(y2,embDim,L);

%%

y3 = y2 + 0.4*sin(5*x + 2).*cos(3*x);
plot(x,y3)
[L,embDim,corrDim,std_corrDim] = vcorrdim(y3,3,25);
figure
mk3plot(y3,embDim,L);

%%

cross_recur(y3,y2,4,7,1)