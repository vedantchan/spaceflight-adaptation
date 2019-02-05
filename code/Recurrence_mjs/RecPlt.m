function RP=RecPlt(RM,thr)
% RM=recurrence matrix
% thr=threshold (0-1)
% Distances less than thr are dots, greater than thr are white.
% Distance is scaled from 0 to 1 and thr is based on that scale.
a=RM;
amin = min(min(a));
amax = max(max(a));
a = ((a-amin)/(amax-amin));
idx=zeros(size(a));
idx(find(a>thr))=0;
idx(find(a<=thr))=1;
cmap=[1 1 1; 0 0 0];
colormap(cmap);
imagesc(idx);
set(gca,'ydir','normal');
axis square
RP=idx;
return
