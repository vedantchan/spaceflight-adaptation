% General function to plot any 10 plots vertically.


clear; close all;

[prefile,path] = uigetfile('*.fig','MultiSelect','on');
file = sort(prefile);

origin = pwd;
cd(path)

figstitle = inputdlg('What is the title of this file?');
plottitle = inputdlg('What is the title of this plot?');

ax={};
h1 = openfig(file{1},'invisible');
ax{1} = get(h1, 'Children');

h2 = openfig(file{2},'invisible');
ax{2} = get(h2, 'Children');

h3 = openfig(file{3},'invisible');
ax{3} = get(h3, 'Children');

h4 = openfig(file{4},'invisible');
ax{4} = get(h4, 'Children');

h5 = openfig(file{5},'invisible');
ax{5} = get(h5, 'Children');

h6 = openfig(file{6},'invisible');
ax{6} = get(h6, 'Children');

h7 = openfig(file{7},'invisible');
ax{7} = get(h7, 'Children');

h8 = openfig(file{8},'invisible');
ax{8} = get(h8, 'Children');

h9 = openfig(file{9},'invisible');
ax{9} = get(h9, 'Children');

h10 = openfig(file{10},'invisible');
ax{10} = get(h10, 'Children');


h = figure('Units','normalized','Position',[0 0 0.3 1]);
pbaspect([1 10 1])


% fig1 = get(ax1,'children');
% fig2 = get(ax2,'children');
% fig3 = get(ax3,'children');
% fig4 = get(ax4,'children');
% fig5 = get(ax5,'children');
% fig6 = get(ax6,'children');
% fig7 = get(ax7,'children');
% fig8 = get(ax8,'children');
% fig9 = get(ax9,'children');
% fig10 = get(ax10,'children');

for k = 1:50
    
    subplot(10,5,k)
    
end
ct=0;
for i = 1:10
    nax = flipud(ax{i});
    epochs = {'UP1' 'UP2' 'P1' 'P2' 'REC'};
    
    for j = 1:5
        ct = ct+1;
        copyobj(get(nax(j),'children'),subplot(10,5,ct));
        text(-1000,0.5,string(epochs{j}))
        %pbaspect([5 1 1])
    end
    title(strcat('Subject - ',num2str(i)));
end

sgtitle(plottitle)

cd(origin);
