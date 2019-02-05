function RPj=jrec(RP1,RP2)
RPj = RP1 & RP2;
cmap=[1 1 1; 0 0 0];
colormap(cmap);
imagesc(RPj);
set(gca,'ydir','normal');
axis square
return
