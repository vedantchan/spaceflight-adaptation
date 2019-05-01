%% 3/21/19, Filter shimmer
% resample/smooth/filter shimmer 

% takes the split shimmer data and applies Kalman filter

clear; close all;

uiwait(msgbox('Select your subjectSplit folder'))
trialsPath = uigetdir;
cd(trialsPath);
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));

answer = (inputdlg('Select your destination folder'));
cleanedfolder = answer{1};


for subjCount = 1:length(subjects)
    
    subjdest = [cleanedfolder '/' subjects(subjCount)];
    mkdir(subjdest);
    files = dir(fullfile(trialsPath, subjects(subjCount),'*.csv'));
    
    for f = 1:length(files)
        data = importdata(strcat(files(f).folder,'/',files(f).name));
    
        fs = 51.2;
        fpass = 5; %1/5 = 0.2 = fastest time a person moves apparently
        filtered = lowpass(data.data(:,2:end),5,51.2);
        
%         Fs = 100;
%         [P,Q] = rat(1/Fs); % sample down to ~1 hz .... (is this a bad idea)
%         xnew = resample(data(:,2),P,Q);
%         new = xnew(:,:);
%         plot(new);
%         title('Resampled Vector')
%         xlabel('Absolute Time in ticks (1 Hz/sec)') 
%         ylabel('acceleration (m/(s^2))') 
%         saveas(gcf,strcat('Resampled for XCorr/',files(i).name(1:end-4),'_smoothedandresampled.fig'));
        
        dlmwrite(strcat(subjdest, '/' ,files(f).name(1:end-4),'_cleaned.csv'),filtered)
        
    end
end

