% r vectorization
% Description: gives you magnitude of resultant angular velocity and linear acceleration
% vector

% run for each subj individually 3/24/19
% **need to change ang vector index
% this gives absolute movement (direction is thrown out)
% velocity vec needed?

clear; close all;

uiwait(msgbox('Select your shimmer split folder'))
trialsPath = uigetdir;

%store files
files = dir(fullfile(trialsPath, '*.csv')); 

cd(trialsPath(1:end-12)) % now working in subject folder

mkdir('Vector')
mkdir('Otherplots')

for i = 1:length(files)
    data = importdata(strcat(files(i).folder,'/',files(i).name));
    
    % linear z vectorization
    x = data(:,2);
    y = data(:,3);
    z = data(:,4);
    rvec = sqrt((x.^2) + (y.^2) + (z.^2));    
    plot(data(:,1), rvec)
    title('Rvector')
    xlabel('Time in ticks (100.21Hz/sec)') 
    ylabel('lin acceleration (m/(s^2))') 
    xlim([min(data(:,1)) max(data(:,1))])
    saveas(gcf,['Vector' '/' files(i).name(1:end-4) '_rvec.fig']);
    dlmwrite(['Vector' '/' files(i).name(1:end-4) '_rvec.csv'],[data(:,1) rvec]);
    
    %angular vectorization
    %some of them have battery vectors >:(
    if data(1,8) > 100
        wx = data(:,9);
        wy = data(:,10);
        wz = data(:,11);
    else
        wx = data(:,8);
        wy = data(:,9);
        wz = data(:,10);
    end
    wvec = sqrt((wx.^2) + (wy.^2) + (wz.^2));    
    plot(data(:,1), wvec)
    title('Wvector')
    xlabel('Time in ticks (100.21Hz/sec)') 
    ylabel('Angular velocity (deg/s)') 
    xlim([min(data(:,1)) max(data(:,1))])
    saveas(gcf,['Vector' '/' files(i).name(1:end-4) '_wvec.fig']);
    dlmwrite(['Vector' '/' files(i).name(1:end-4) '_wvec.csv'],[data(:,1) wvec]);
    
    %other plots
    plot(data(:,1), x,'g'); hold on;
    plot(data(:,1), y, 'r'); hold on;
    plot(data(:,1), z); hold off;
    title('Accelerometer LN vs Time')
    xlabel('Time in ticks (100.21Hz/sec)') 
    ylabel('Acceleration (m/(s^2))') 
    legend('x-plane','y-plane','z-plane')
    xlim([min(data(:,1)) max(data(:,1))])
    saveas(gcf,['Otherplots' '/' files(i).name(1:end-4) '_lin.fig']);
    
    plot(data(:,1), wx,'g'); hold on;
    plot(data(:,1), wy, 'r'); hold on;
    plot(data(:,1), wz); hold off;
    title('Angular velocity vs Time')
    xlabel('Time in ticks (100.21Hz/sec)')
    ylabel('Angular velocity (deg/sec)') 
    legend('x-plane','y-plane','z-plane')
    xlim([min(data(:,1)) max(data(:,1))]);
    saveas(gcf,['Otherplots' '/' files(i).name(1:end-4) '_ang.fig']);
   
end
