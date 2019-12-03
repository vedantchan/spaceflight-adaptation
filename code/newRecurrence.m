addpath('RecurrencePlot_ToolBox/')

clear; close all;

[file,path] = uigetfile('*.csv','MultiSelect','on'); % 'files' is a cell arrays, each cell containg the name of the file

if class(file) == 'char'
    file = {file};
end

subjname = inputdlg("Subject ID?");
subjname = subjname{1};
mkdir(strcat('plots/recurrence/',subjname));

det = ones(1,5);
lmax = ones(1,5);
ent = ones(1,5);
tnd = ones(1,5);
lam = ones(1,5);
tt = ones(1,5);

for i = 1:length(file)
    ct = i;
    filepath = strcat(path,file{i});
    if contains(file{i},'UP1')
        epoch = 'UP1';
    elseif contains(file{i},'UP2')
        epoch = 'UP2';
    elseif contains(file{i},'P1')
        epoch = 'P1';
    elseif contains(file{i},'P2')
        epoch = 'P2';
    elseif contains(file{i},'Rec')
        epoch = 'REC';
    end
    
    signal = load(filepath);
    [acorr,lagtime] = xcorr(signal-mean(signal),'coeff');
    %plot(lagtime,acorr)
    [dummmy,mid] = max(acorr);
    acorr = acorr(mid:end);
    lagtime = lagtime(mid:end);
    L = find(acorr < max(acorr)/exp(1),1);
    
    % ADD DIMENSION ESTIMATION
    
    y = phasespace(signal,3,L);
    
    recurdata = cerecurr_y(y);
    
    figure('Position',[100 100 550 400]);
    imagesc(recurdata);
    colormap Jet;
    colorbar;
    axis image;    
    xlabel('Time Index','FontSize',10,'FontWeight','bold');
    ylabel('Time Index','FontSize',10,'FontWeight','bold');
    title(strcat('Recurrence Plot-',subjname,'-',epoch),'FontSize',10,'FontWeight','bold');
    get(gcf,'CurrentAxes');
    set(gca,'YDir','normal')
    set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
    savefig(strcat('plots/recurrence/',subjname,'/Recurrence-Plot-',epoch));
    close
    
    % SET MARKER THRESHOLD
    
    threshold = 5;
    
    [m,n] = size(recurdata);
    [i,j] = find(recurdata<=threshold);
    x=[i j];
    figure('Position',[100 100 550 400]);
    plot(x(:,1),x(:,2),'k.','MarkerSize',2);
    xlim([0,m]);
    ylim([0,n]);
    xlabel('Time Index','FontSize',10,'FontWeight','bold');
    ylabel('Time Index','FontSize',10,'FontWeight','bold');
    title(strcat('Recurrence Plot-',subjname,'-',epoch),'FontSize',10,'FontWeight','bold');
    pbaspect([1 1 1])
    get(gcf,'CurrentAxes');
    set(gca,'LineWidth',2,'FontSize',10,'FontWeight','bold');
    %grid on;
    savefig(strcat('plots/recurrence/',subjname,'/BWRecurrence-Plot-',epoch))
    close
    
    rqa_stat = recurrqa_y(tdrecurr_y(recurdata,threshold));
    i=ct;
    if contains(file{i},'UP1')
        det(1) = rqa_stat(1);
        lmax(1) = rqa_stat(2);
        ent(1) = rqa_stat(3);
        tnd(1) = rqa_stat(4);
        lam(1) = rqa_stat(5);
        tt(1) = rqa_stat(6);
    elseif contains(file{i},'UP2')
        det(2) = rqa_stat(1);
        lmax(2) = rqa_stat(2);
        ent(2) = rqa_stat(3);
        tnd(2) = rqa_stat(4);
        lam(2) = rqa_stat(5);
    elseif contains(file{i},'P1')
        det(3) = rqa_stat(1);
        lmax(3) = rqa_stat(2);
        ent(3) = rqa_stat(3);
        tnd(3) = rqa_stat(4);
        lam(3) = rqa_stat(5);
    elseif contains(file{i},'P2')
        det(4) = rqa_stat(1);
        lmax(4) = rqa_stat(2);
        ent(4) = rqa_stat(3);
        tnd(4) = rqa_stat(4);
        lam(4) = rqa_stat(5);
    elseif contains(file{i},'Rec')
        det(5) = rqa_stat(1);
        lmax(5) = rqa_stat(2);
        ent(5) = rqa_stat(3);
        tnd(5) = rqa_stat(4);
        lam(5) = rqa_stat(5);
    end
    

end

plot(tnd)
xticks([1 2 3 4 5])
abels={'UP1','UP2','P1','P2','REC'}
xticklabels(labels)
title('Recurrence Trend TND Across Epochs')
xlabel('Epoch')
ylabel('TND')
savefig(strcat('plots/recurrence/',subjname,'/BWRecurrence-Plot-',epoch