% 8/1/19: homemade IBI analysis

%8/10/19: temp mod for skylab data
%8/10/19: changed to low pass, high pass, threshold function (homemadeibi2)
% >> param = 26,1

clear all;
close;

%choose multiple subject folders in raw
subjects = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data');
% store into a separate folder called...homemadeibi-[inserttrialname]
mkdir('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/homemadeibi2')
for subjcount = 1:length(subjects)
   %bvpepoch = dir(fullfile(subjects{subjcount},'EmpaticaSplit','*BVP*.csv'));
   bvpepoch = dir(fullfile(subjects{subjcount},'*BVP*.csv'));
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
        %data = importdata(fullfile(subjects{subjcount},'EmpaticaSplit',srtd{file}));
        data = importdata(fullfile(subjects{subjcount},srtd{file}));
        [ibi,pks,lc] = homemadeibi2(data);
        x = 1:length(data);
        lp = lowpass(data,5,64); %for ~170bpm (looser lp)
        hp = highpass(lp,.05); %for 40bpm ???? <<just randomly chose a number, not sure the logic
        ind = find(hp > 100);
        hp(ind) = 0;
        plot(x, hp,lc,pks,'*')
        title(['Peak Locations on BVP for IBI calculations:' 'subj1969-' num2str(subjcount) '-E' num2str(file)])
        subjfold = ['/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/homemadeibi/subj1969-' num2str(subjcount)];
        mkdir(subjfold)
        saveas(gca, fullfile(subjfold,['peakloc' '_E' num2str(file) '.fig']))
        tot{file} = ibi;
        hold off
        %plot(ibi);
    end
    dlmwrite(fullfile(subjfold,['homemadeibi2_UP1.csv']),tot{1})
    dlmwrite(fullfile(subjfold,['homemadeibi2_UP2.csv']),tot{2})
    dlmwrite(fullfile(subjfold,['homemadeibi2' '_P1.csv']),tot{3})
    dlmwrite(fullfile(subjfold,['homemadeibi2_P2.csv']),tot{4})
    dlmwrite(fullfile(subjfold,['homemadeibi2_REC.csv']),tot{5})


end

%ibi function 1, only with findpeaks function
function [ibi,pks,lc] = homemadeibi(bvp)
%find peaks past a certain threshold > 'minpeakdistance' = .4 sec (for 64Hz
%>> https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5028198/ .4 sec
%corresponds to fastest HR, 150 bpm
%signal, .4sec = 25.6 data points ~ 26
%store peaks into a vector which can be plotted to check what peaks are
%being used
%use diff on peaks vector to find ibi
%store ibi

%changed to reduce peak distance and height for skylab
[pks,lc] = findpeaks(bvp,'minpeakdistance',10,'minpeakheight',1);
ibi = diff(lc); %this would be in... 1/64 sec? need to convert?

end

%with low pass, high pass, threshold, 
function [ibi2,pks2,lc2] = homemadeibi2(bvp)
lp = lowpass(bvp,5,64); %for ~170bpm (looser lp)
hp = highpass(lp,.05); %for 40bpm ???? <<just randomly chose a number, not sure the logic
ind = find(hp > 100);
hp(ind) = 0;

%[pks,lc] = findpeaks(hp,'minpeakdistance',1,'minpeakheight',1);
[pks2,lc2] = findpeaks(hp,'minpeakdistance',26,'minpeakheight',1);

ibi2 = diff(lc2); %this would be in... 1/64 sec? need to convert?

end
