% 3/21/19
% resample/smooth shimmer 

clear; close all;

uiwait(msgbox('Select your shimmer vector folder'))
trialsPath = uigetdir;

%store files
files = dir(fullfile(trialsPath, '*.csv')); 
cd(trialsPath(1:end-6)) % now working in subject folder

mkdir('Resampled for XCorr')

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

