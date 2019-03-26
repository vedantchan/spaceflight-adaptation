% z vectorization

% run for each subj individually 3/24/19

clear; close all;

uiwait(msgbox('Select your shimmer split folder'))
trialsPath = uigetdir;
%store files
files = dir(fullfile(trialsPath, '*.csv')); %try just putting name together

% uiwait(msgbox("Select the destination directory for shimmer data (should be shimmer folder)"))
% mainfolder = uigetdir;
% answer = inputdlg('Enter subject folder name, e.g. subj1','Folder Name'); 

%datafolder = strcat(mainfolder,'/',answer{1});
%mkdir(datafolder);

cd(trialsPath) % now working in subject folder

mkdir('Zvector')
mkdir('Otherplots')

for i = 1:length(files)
    data = importdata(strcat(files(i).folder,'/',files(i).name));
    
    %linear z vectorization
    x = data.data(:,2);
    y = data.data(:,3);
    z = data.data(:,4);
    zvec = sqrt((x.^2) + (y.^2) + (z.^2));    
    plot(data.data(:,1), zvec)
    saveas(gcf,['Zvector' '/' files(i).name(1:end-4) '_zvec.fig']);
    dlmwrite(['Zvector' '/' files(i).name(1:end-4) '_zvec.csv'],[data.data(:,1) zvec]);
    
    %angular?
    
    %plots
    plot(data.data(:,1), data.data(:,2),'g'); hold on;
    plot(data.data(:,1), data.data(:,3), 'r'); hold on;
    plot(data.data(:,1), data.data(:,4)); hold off;
    title('Accelerometer LN vs Time')
    xlabel('Time in ticks (100.21Hz/sec)') 
    ylabel('Accelerometer WR (m/(s^2))') 
    legend('x-plane','y-plane','z-plane')
    saveas(gcf,['Otherplots' '/' files(i).name(1:end-4) '_lin.fig']);
    
    plot(data.data(:,1), data.data(:,8),'g'); hold on;
    plot(data.data(:,1), data.data(:,9), 'r'); hold on;
    plot(data.data(:,1), data.data(:,10)); hold off;
    title('Angular velocity vs Time')
    xlabel('Time in ticks (100.21Hz/sec)')
    ylabel('Gyrometer (deg/sec)') 
    legend('x-plane','y-plane','z-plane')
    saveas(gcf,['Otherplots' '/' files(i).name(1:end-4) '_ang.fig']);



    
end
