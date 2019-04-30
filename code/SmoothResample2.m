%% Smoothing, 3/2/19
% DONE 
clear all,
close all;

%3/1/19: got rid of gaussian filtering, resample TEMP and EDA to 1Hz. Moves all straight to smoothed folder
% Do we care about BVP?

%% Get data
origin = pwd;
uiwait(msgbox('Select your raw folder'))
trialsPath = uigetdir; %SELECT 'raw' HERE
trialsPath = strcat(trialsPath,'/');
cd(trialsPath)
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));
uiwait(msgbox('Select your smoothed folder'))
movehere = uigetdir;
movehere = [movehere '/'];

%% analyze!

for subjectCount = 1:length(subjects)
     splitDir = strcat(trialsPath,subjects(subjectCount),'/','EmpaticaSplit/')
     path = splitDir{1};
     cd(strcat(trialsPath,subjects{subjectCount}));
     string = ls(splitDir{1});
     list = strsplit(string);
     file = list(~cellfun('isempty',list));
     file(contains(file,'fig'))=[];
     file(contains(file,'smoothed'))=[];
        
%% Shimmer 
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
    if contains(path,'EmpaticaSplit')
        folderarr = strcat(movehere, subjects(subjectCount),'/');
        folder = folderarr{1};

       %upfolder = [path '/UP_smoothed/'];
        mkdir(folder);
        %mkdir(pfolder);

        %if contains(path,'/P')
            for w = 1:length(file) % loop through the files % i has the current subject name       
                headers = 1;
                delim = ',';
                data = importdata(strcat(path,'/',file{w}),delim,headers); % this is one file HAS HEADERS

                if contains(file{w},'BVP')
                    %smooth = smoothdata(data.data,'gaussian', 2);
                    %plot(smooth)
                    Fs = 64;
                    [P,Q] = rat(4/Fs); % sample down to 4 hz; SHOULD THIS BE CHANGED
                    %xnew = resample(smooth,P,Q);
                    xnew = resample(data.data,P,Q);
                    new = xnew(:,:);
                    plot(new);
                    saveas(gcf,strcat(folder,file{w}(1:end-4),'_smoothedandresampled.fig'));
                    dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),new)
                end
                if contains(file{w},'EDA') || contains(file{w},'TEMP')
                    %smooth = smoothdata(data.data,'gaussian', 2);
                    Fs = 4;
                    [P,Q] = rat(1/Fs); % sample down to 1 hz
                    %xnew = resample(smooth,P,Q);
                    xnew = resample(data.data,P,Q);
                    new = xnew(:,:);
                    plot(new)
                    saveas(gcf,strcat(folder,file{w}(1:end-4),'_smoothedandresampled.fig'));
                    %dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),smooth)
                    dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),new)
                end
                if contains(file{w},'HR') % we are not smoothing/resampling b/c will lose data
                    %smooth = smoothdata(data.data,'gaussian', 2);
    %                 Fs = 1;
    %                 [P,Q] = rat(4/Fs); % sample up to 4 hz
    %                 xnew = resample(x,P,Q);
    %                 new = xnew(:,:);
                    plot(data.data)
                    saveas(gcf,strcat(folder,file{w}(1:end-4),'_smoothedandresampled.fig'));
                    %dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),smooth)
                    dlmwrite(strcat(folder,file{w}(1:end-4),'_smoothedandresampled.csv'),data.data)
                end
            end
    end
end

cd(origin);