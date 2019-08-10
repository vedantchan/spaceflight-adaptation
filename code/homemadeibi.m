% 8/1/19: homemade IBI analysis

clear all;
close;

subjects = uipickfiles('filterspec','Users/SYT/Documents/GitHub/spaceflight-adaptation/data');
% store into a separate folder called...homemadeibi-[inserttrialname]
mkdir('Users/SYT/Documents/GitHub/spaceflight-adaptation/data/homemadeibi')
for subjcount = 1:length(subjects)
    bvpepoch = dir(fullfile(subjects{subjcount},'EmpaticaSplit','*BVP*.csv'));
    %sort
    prefile = {};
    for f = 1:5
        prefile{f} = bvpepoch(f).name;
    end
    srtd = epochsort(prefile);
    
    for file = 1:5
        data = importdata(fullfile(subjects{subjcount},'EmpaticaSplit',srted{file}));
        [ibi,pks,lc] = homemadeibi(data);
        x = 1:length(data);
        plot(x, data,lc,pks,'*')
        title(['Peak Locations on BVP for IBI calculations:' 'subj' num2str(subjcount+20)])
        subjfold = ['Users/SYT/Documents/GitHub/spaceflight-adaptation/data/homemadeibi/subj' num2str(subjcount+20)];
        mkdir(subjfold)
        saveas(gca, fullfile(subjfold,'peakloc.fig'))
        dlmwrite(fullfile(subjfold,'homemadeibi.csv'),ibi)
    end
end

function [ibi,pks,lc] = homemadeibi(bvp)
%find peaks past a certain threshold > 'minpeakdistance' = .4 sec (for 64Hz
%signal, .4sec = 25.6 data points ~ 26
%store peaks into a vector which can be plotted to check what peaks are
%being used
%use diff on peaks vector to find ibi
%store ibi

[pks,lc] = findpeaks(bvp,'minpeakdistance',26);
ibi = diff(pks); %this would be in... 1/64 sec? need to convert?

end

