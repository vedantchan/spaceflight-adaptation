
% General function to plot any 5 plots across the 5 phases of the experiment.
% Relies on the E4 naming scheme - check the dialog box for the file order 
% to ensure plots are in the correct order. 

clear; close all;

[file,path] = uigetfile('*.fig','MultiSelect','on');

file = sort(file);

origin = pwd;
cd(path)

msgbox(strcat('File order is ',file{4},'\n',file{5},'\n',file{1},'\n',file{2},'\n',file{3}))

h1 = openfig(file{4},'invisible');
ax1 = gca;

h2 = openfig(file{5},'invisible');
ax2 = gca;

h3 = openfig(file{1},'invisible');
ax3 = gca;

h4 = openfig(file{2},'invisible');
ax4 = gca;

h5 = openfig(file{3},'invisible');
ax5 = gca;

figstitle = inputdlg('What is the title of this file?')
plottitle = inputdlg('What is the title of this plot?')

h = figure('Units','normalized','Position',[0 0 0.75 0.25]);
pbaspect auto

s1 = subplot(1,6,1);
title('UP1');
pbaspect([1 1 1])


s2 = subplot(1,6,2);
title('UP2')
pbaspect([1 1 1])

s3 = subplot(1,6,3);
title('P1')
pbaspect([1 1 1])

s4 = subplot(1,6,4);
title('P2')
pbaspect([1 1 1])

s5 = subplot(1,6,5);
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

sgtitle(plottitle{1})
savefig(figstitle{1})
saveas(gcf,strcat(figstitle{1},'.png'))

cd(origin);