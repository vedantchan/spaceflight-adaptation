% 6\19\19: Discreet data analysis

% Tasks:
% Plot all 
% figure out a multi corr coeff?
% what other analysis can be done?
% add in keystroke stuff

files = uipickfiles('filterspec','C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data'); %output cell
%save figures
uiwait(msgbox("Where do you want to store this?"))
storage = uigetdir;
likert = importdata(files{1},',',1);
swch = importdata(files{2},',',1);
van = importdata(files{3},',',1);

likertclean = rmmissing(likert.data);
swchclean = rmmissing(swch.data);
vanclean = rmmissing(van.data);

% organizing swch.. ??


epochs = {'UP1', 'UP2', 'P1', 'P2', 'REC'};

%just for demonstration, van
for v = 1:length(likertclean)
    figure
    plot(vanclean(1:end,v),'--b*')
    title(['VAN Data, ' likert.textdata{v}])
    set(gca,'xtick', [1:5],'xticklabel',epochs);
    %saveas(gcf,[ storage '\' 'VAN_' likert.textdata{v} '.fig'])
end


% all together, normalized
for subj = 1:length(likertclean)
    norml = normalize(likertclean(1:end,subj),'range');
    norms = normalize(swchclean(1:5,subj),'range');
    normv = normalize(vanclean(1:end,subj),'range');
    figure
    plot(norml,'-.r*');
    hold on;
    plot(norms, '--go');
    plot(normv, ':bs');
    hold off;
    set(gca,'xtick', [1:5],'xticklabel',epochs);
    title(['VAN, switch, stress: ' likert.textdata{subj}])
    saveas(gcf,[ storage '\' 'VANswitchlikert_' likert.textdata{subj} '.fig'])
 
end
   