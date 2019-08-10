% 8/1/19: homemade IBI analysis

%8/10/19: temp mod for skylab data
clear all;
close;

%choose multiple subject folders in raw
subjects = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data');
% store into a separate folder called...homemadeibi-[inserttrialname]
mkdir('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/homemadeibi')
for subjcount = 1:length(subjects)
   bvpepoch = dir(fullfile(subjects{subjcount},'EmpaticaSplit','*BVP*.csv'));
   %bvpepoch = dir(fullfile(subjects{subjcount},'*BVP*.csv'));
    %sort
    prefile = {};
    for f = 1:5
        prefile{f} = bvpepoch(f).name;
    end
    srtd = epochsort(prefile);
    up1 = [];
    up2 = [];
    p1 = [];
    p2 = [];
    rec = [];
    tot = {up1, up2, p1, p2, rec};
    for file = 1:5
        data = importdata(fullfile(subjects{subjcount},'EmpaticaSplit',srtd{file}));
        %data = importdata(fullfile(subjects{subjcount},srtd{file}));
        [ibi,pks,lc] = homemadeibi(data);
        x = 1:length(data);
        plot(x, data,lc,pks,'*')
        title(['Peak Locations on BVP for IBI calculations:' 'subj' num2str(subjcount+30)])
        subjfold = ['/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/homemadeibi/subj' num2str(subjcount+30)];
        mkdir(subjfold)
        saveas(gca, fullfile(subjfold,['peakloc' '_E' num2str(file) '.fig']))
        tot{file} = ibi;
        hold off
        %plot(ibi);
    end
    dlmwrite(fullfile(subjfold,['homemadeibi_UP1.csv']),tot{1})
    dlmwrite(fullfile(subjfold,['homemadeibi_UP2.csv']),tot{2})
    dlmwrite(fullfile(subjfold,['homemadeibi' '_P1.csv']),tot{3})
    dlmwrite(fullfile(subjfold,['homemadeibi_P2.csv']),tot{4})
    dlmwrite(fullfile(subjfold,['homemadeibi_REC.csv']),tot{5})


end

function [ibi,pks,lc] = homemadeibi(bvp)
%find peaks past a certain threshold > 'minpeakdistance' = .4 sec (for 64Hz
%>> https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5028198/ .4 sec
%corresponds to fastest HR, 150 bpm
%signal, .4sec = 25.6 data points ~ 26
%store peaks into a vector which can be plotted to check what peaks are
%being used
%use diff on peaks vector to find ibi
%store ibi

[pks,lc] = findpeaks(bvp,'minpeakdistance',26,'minpeakheight',1);
ibi = diff(lc); %this would be in... 1/64 sec? need to convert?

end

