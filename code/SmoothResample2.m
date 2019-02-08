%% Smoothing
% DONE 
clear all,
close all;

%% Get data
origin = pwd;
trialsPath = uigetdir; %SELECT 'raw' HERE
trialsPath = strcat(trialsPath,'/');
cd(trialsPath)
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));



% try
% %load in the data
% [file, path] = uigetfile('*.csv', 'Multiselect','on');   
% catch 
%     disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
%     disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
% end   

%% Shimmer 

for subjectCount = 1:length(subjects)
     splitDir = strcat(trialsPath,subjects(subjectCount),'/',subjects(subjectCount),'EmpaticaData/',subjects(subjectCount))
     path = splitDir{1};
     cd(strcat(trialsPath,subjects{subjectCount}));
     string = ls(splitDir{1});
     list = strsplit(string);
     file = list(~cellfun('isempty',list));
     file(contains(file,'fig'))=[];
     file(contains(file,'smoothed'))=[];
        
     if contains(path,'Shim')  
            smoothfolder = 'Shim_smoothed_data/';
            mkdir([path smoothfolder(1:end-1)]);
            for i = 1:length(file) % loop through the files % i has the current subject name

                data = importdata(strcat(path,file{i})); % this is one file

                time = data(:,1);
                lin_z = data(:,2);
                smooth =  smoothdata(lin_z, 'gaussian', 20);
                %plot(time,smooth);
                    Fs = 100;
                    [P,Q] = rat(30/Fs); % sample down to ~30 hz
                    xnew = resample(smooth,P,Q);
                    new = xnew(:,:);
                    plot(new);
                    saveas(gcf,strcat(path,smoothfolder,file{i}(1:end-4),'_smoothedandresampled.fig'));
                    dlmwrite(strcat(path,smoothfolder,file{i}(1:end-4),'_smoothedandresampled.csv'),new)
            end
     end

    %% Empatica
    if contains(path,'Empatica')
        folder = strcat(path,'/smoothed/');
       %upfolder = [path '/UP_smoothed/'];
        mkdir(folder);
        %mkdir(pfolder);

        %if contains(path,'/P')
            for w = 1:length(file) % loop through the files % i has the current subject name       
                headers = 1;
                delim = ',';
                data = importdata(strcat(path,'/',file{w}),delim,headers); % this is one file HAS HEADERS

                if contains(file{w},'BVP')
                    smooth = smoothdata(data.data,'gaussian', 2);
                    %plot(smooth)
                    Fs = 64;
                    [P,Q] = rat(4/Fs); % sample down to 4 hz
                    xnew = resample(smooth,P,Q);
                    new = xnew(:,:);
                    plot(new);
                    saveas(gcf,strcat(folder,file{w}(1:end-4),'_smoothedandresampled.fig'));
                    dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),new)
                end
                if contains(file{w},'EDA') || contains(file{w},'TEMP')
                    smooth = smoothdata(data.data,'gaussian', 2);
    %                 Fs = 64;
    %                 [P,Q] = rat(4/Fs); % sample down to 4 hz
    %                 xnew = resample(x,P,Q);
    %                 new = xnew(:,:);
                    plot(smooth)
                    saveas(gcf,strcat(folder,file{w}(1:end-4),'_smoothedandresampled.fig'));
                    dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),smooth)
                end
                if contains(file{w},'HR')
                    smooth = smoothdata(data.data,'gaussian', 2);
    %                 Fs = 1;
    %                 [P,Q] = rat(4/Fs); % sample up to 4 hz
    %                 xnew = resample(x,P,Q);
    %                 new = xnew(:,:);
                    plot(smooth)
                    saveas(gcf,strcat(folder,file{w}(1:end-4),'_smoothedandresampled.fig'));
                    dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),smooth)
                end
            end
    end
end

cd(origin);