%% 3/21/19, Filter shimmer
% resample/smooth/filter shimmer 

% takes the split shimmer data and applies Kalman filter

clear; close all;

uiwait(msgbox('Select your raw folder'))
trialsPath = uigetdir;

%store files
files = dir(fullfile(trialsPath, 'ShimmerSplit', '*.csv')); 
cd(trialsPath(1:end-6)) % now working in subject folder

filtfold = 'filtered_shim';
mkdir(filtfold);


for i = 1:length(files)
    data = importdata(strcat(files(i).folder,'/',files(i).name));
    
    Fs = 100;
    [P,Q] = rat(1/Fs); % sample down to ~1 hz .... (is this a bad idea)
    xnew = resample(data(:,2),P,Q);
    new = xnew(:,:);
    plot(new);
    title('Resampled Vector')
    xlabel('Absolute Time in ticks (1 Hz/sec)') 
    ylabel('acceleration (m/(s^2))') 
    saveas(gcf,strcat('Resampled for XCorr/',files(i).name(1:end-4),'_smoothedandresampled.fig'));
    dlmwrite(strcat('Resampled for XCorr/',files(i).name(1:end-4),'_smoothedandresampled.csv'),new)
    
end

