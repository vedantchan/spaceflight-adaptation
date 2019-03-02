% General function to plot any 10 plots vertically.


clear; close all;

[prefile,path] = uigetfile('*.fig','MultiSelect','on');
file = sort(prefile);

origin = pwd;
cd(path)

figstitle = 'test';%inputdlg('What is the title of this file?');
plottitle = 'test';%inputdlg('What is the title of this plot?');

h1 = openfig(file{1},'invisible');
ax1 = gca;

h2 = openfig(file{2},'invisible');
ax2 = gca;

h3 = openfig(file{3},'invisible');
ax3 = gca;

h4 = openfig(file{4},'invisible');
ax4 = gca;

h5 = openfig(file{5},'invisible');
ax5 = gca;

h6 = openfig(file{6},'invisible');
ax6 = gca;

h7 = openfig(file{7},'invisible');
ax7 = gca;

h8 = openfig(file{8},'invisible');
ax8 = gca;

h9 = openfig(file{9},'invisible');
ax9 = gca;

h10 = openfig(file{10},'invisible');
ax10 = gca;


h = figure('Units','normalized','Position',[0 0 0.3 1]);
pbaspect([1 10 1])

s1 = subplot(10,1,1);
title('Subject 1');
pbaspect([5 1 1])


s2 = subplot(10,1,2);
title('Subject 2')
pbaspect([5 1 1])

s3 = subplot(10,1,3);
title('Subject 3')
pbaspect([5 1 1])

s4 = subplot(10,1,4);
title('Subject 4')
pbaspect([5 1 1])

s5 = subplot(10,1,5);
title('Subject 5')
pbaspect([5 1 1])

s6 = subplot(10,1,6);
title('Subject 6');
pbaspect([5 1 1])


s7 = subplot(10,1,7);
title('Subject 7')
pbaspect([5 1 1])

s8 = subplot(10,1,8);
title('Subject 8')
pbaspect([5 1 1])

s9 = subplot(10,1,9);
title('Subject 9')
pbaspect([5 1 1])

s10 = subplot(10,1,10);
title('Subject 10')
pbaspect([5 1 1])

fig1 = get(ax1,'children');
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children');
fig5 = get(ax5,'children');
fig6 = get(ax6,'children');
fig7 = get(ax7,'children');
fig8 = get(ax8,'children');
fig9 = get(ax9,'children');
fig10 = get(ax10,'children');

copyobj(fig1,s1);
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4);
copyobj(fig5,s5);
copyobj(fig6,s6);
copyobj(fig7,s7);
copyobj(fig8,s8);
copyobj(fig9,s9);
copyobj(fig10,s10);

sgtitle(plottitle)

cd(origin);

clear;