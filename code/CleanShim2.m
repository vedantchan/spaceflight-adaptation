%% 3/21/19, Filter shimmer
% resample/smooth/filter shimmer 

% takes the split shimmer data and applies low pass filter

clear; close all;

uiwait(msgbox('Select your split shimmer folder'))
trialsPath = uigetdir;
cd(trialsPath);
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));

uiwait(msgbox('Select your destination folder'));
cleanedfolder = uigetdir;


for subjCount = 1:length(subjects)
    
    subjdest = strcat(cleanedfolder, '/', subjects(subjCount));
    mkdir(subjdest{1});
    q = fullfile(trialsPath, subjects(subjCount),'*.csv');
    files = dir(q{1});
    
    for f = 1:length(files)
        data = importdata(strcat(files(f).folder,'/',files(f).name));
         
%         reg low pass
        fs = 51.2;
        fpass = 5; %1/5 = 0.2 = fastest time a person moves apparently: https://academic.oup.com/biomedgerontology/article/56/9/M584/691511
        filtered = lowpass(data.data(:,2:end),5,51.2);    
%       gaussian
%         g = gausswin(10)/sum(gausswin(10));
%         filtered = filter(g,1,data(:,:));      
        dlmwrite(strcat(subjdest{1}, '/' ,files(f).name(1:end-4),'_cleaned.csv'),filtered)
        
    end
end

