
% General function to plot any 5 plots across the 5 phases of the experiment.
% Relies on the E4 naming scheme - check the dialog box for the file order 
% to ensure plots are in the correct order. 

clear; close all;

[prefile,path] = uigetfile('*.fig','MultiSelect','on');

file = epochsort(prefile);

origin = pwd;
cd(path)

uiwait(msgbox(strcat('File order is ',file{1},'\n',file{2},'\n',file{3},'\n',file{4},'\n',file{5})))
uiwait(msgbox('Where do you want to store this?'))
mainfolder = uigetdir;


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

figstitle = inputdlg('What is the title of this file?');

h = figure('Units','normalized','Position',[0 0 0.75 0.25]);
pbaspect auto

s1 = subplot(1,5,1);
title('UP1');
pbaspect([1 1 1])


s2 = subplot(1,5,2);
title('UP2')
pbaspect([1 1 1])

s3 = subplot(1,5,3);
title('P1')
pbaspect([1 1 1])

s4 = subplot(1,5,4);
title('P2')
pbaspect([1 1 1])

s5 = subplot(1,5,5);
title('REC')
pbaspect([1 1 1])

fig1 = get(ax1,'children');
fig2 = get(ax2,'children');
fig3 = get(ax3,'children');
fig4 = get(ax4,'children');
fig5 = get(ax5,'children');

copyobj(fig1,s1);
copyobj(fig2,s2);
copyobj(fig3,s3);
copyobj(fig4,s4);
copyobj(fig5,s5);

savefig(strcat(mainfolder, '/',figstitle{1}))
saveas(gcf,strcat(mainfolder,'/',figstitle{1},'.png'))

cd(origin);
close;clear;