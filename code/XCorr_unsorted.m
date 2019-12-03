%% Cross Corr for ANY Data; 3/1/19
% only for E4 at the moment (10/5)
% need to write for shimmer (10/6)
%10/6: DONE :)

%run for ONE subject; runs on the "split" file (which is done right before
%this is done. 

clear; close all;

%3/1/19: make better by running on entire folder (maybe?)

%% Get files, make folders

current = pwd;

uiwait(msgbox("Select your data from the smoothed folder (select by subject)"))
[file, path] = uigetfile('*.csv','MultiSelect','on');   

uiwait(msgbox("Select the destination directory for xcorr data"))
mainfolder = uigetdir;
answer = inputdlg('Enter folder name, e.g. subj1_e4','Folder Name'); 

datafolder = strcat(mainfolder,'/',answer{1});
mkdir(datafolder);
cd(mainfolder)

%% Organize by trial type

P1trials = [];
P2trials = [];
UP1trials = [];
UP2trials = [];
Rectrials = [];
% these will become cells after the file names have been put inside of them

fname = string(file);

for org = 1:length(file)
    if contains(fname(org),'_P1')
        P1trials = [P1trials fname(org)];
    elseif contains(fname(org),'_P2')
        P2trials = [P2trials fname(org)];
    elseif contains(fname(org),'UP1')
        UP1trials = [UP1trials fname(org)];
    elseif contains(fname(org), 'UP2')
        UP2trials = [UP2trials fname(org)];
    elseif contains(fname(org), 'Rec')
        Rectrials = [Rectrials fname(org)];
    end
end
        
%% Cross Correlate 

%this doesnt do anything, and i dont think we need it, but i'm just gonna
%leave it in lol
P1folder = strcat(datafolder,'/','P1runs');
mkdir(P1folder);
P2folder = strcat(datafolder,'/','P2runs');
mkdir(P2folder);
UP1folder = strcat(datafolder,'/','UP1runs');
mkdir(UP1folder);
UP2folder = strcat(datafolder,'/','UP2runs');
mkdir(UP2folder);
Recfolder = strcat(datafolder,'/','Recruns');
mkdir(Recfolder);


%analyze!
for run = 1:length(P1trials)-1
    count = 1;
    data1 = importdata(strcat(path,P1trials{run}));
    lengthdata1 = length(data1);

    while count < length(P1trials) % needs to be less than because we are using this index to add to the previous index to compare (so total in index will be max length)
        if count+run <= length(P1trials)
            data2 = importdata(strcat(path,P1trials{run+count}));
            lengthdata2 = length(data2);  
            if lengthdata1 > lengthdata2
                range = lengthdata2;
            else
                range = lengthdata1;
            end
            % perform xcorr
            [xcor,lag] = xcorr(data1(1:range)-mean(data1(1:range)),data2(1:range)-mean(data2(1:range)),'coeff');
            plot(lag,xcor);
            title([P1trials{run}(1:5),'\_v\_',P1trials{run+count}(1:5) '\_P1']);
            saveas(gcf, strcat(datafolder,'/',P1trials{run}(1:5),'_v_',P1trials{run+count}(1:5),'_P1.fig'));
        
            %find area
            area = trapz(xcor);
            areaabs = trapz(abs(xcor));
            [peak, firstpeak] = max(xcor);
            [trough, firsttrough] = min(xcor);
            otherpeaks = (find(xcor == peak))'; 
            othertroughs = (find(xcor == trough))';
            
            % make all vectors the same size
            maxLength = max([length(area), length(areaabs), length(peak), length(firstpeak), length(otherpeaks), length(othertroughs)]);
            area(length(area)+1:maxLength) = 0;
            areaabs(length(areaabs)+1:maxLength) = 0;
            peak(length(peak)+1:maxLength) = 0;
            firstpeak(length(firstpeak)+1:maxLength) = 0;
            trough(length(trough)+1:maxLength) = 0;
            firsttrough(length(firsttrough)+1:maxLength) = 0;
            otherpeaks(length(otherpeaks)+1:maxLength) = 0;
            othertroughs(length(othertroughs)+1:maxLength) = 0;
            

            T = table(area,areaabs,firstpeak,peak, firsttrough, trough,otherpeaks, othertroughs);
            writetable(T, strcat(datafolder,'/',P1trials{run}(1:5),'_v_',P1trials{run+count}(1:5),'_P1xcor-analysis.csv'));
            dlmwrite(strcat(datafolder,'/',P1trials{run}(1:5),'_v_',P1trials{run+count}(1:5),'_P1xcor.csv'), xcor);
        end
        count=count+1;
    end
end

for run = 1:length(P2trials)-1
    count = 1;
    
    data1 = importdata(strcat(path,P2trials{run}));
    lengthdata1 = length(data1);

    while count < length(P2trials) % needs to be less than because we are using this index to add to the previous index to compare (so total in index will be max length)
        if count+run <= length(P1trials)
            data2 = importdata(strcat(path,P2trials{run+count}));
        
            lengthdata2 = length(data2);
        
            if lengthdata1 > lengthdata2
                range = lengthdata2;
            else
                range = lengthdata1;
            end
        
            % perform xcorr
                [xcor,lag] = xcorr(data1(1:range)-mean(data1(1:range)),data2(1:range)-mean(data2(1:range)),'coeff');
            plot(lag,xcor);
            title([P2trials{run}(1:5),'\_v\_',P2trials{run+count}(1:5) '\_P2']);
            saveas(gcf, strcat(datafolder,'/',P2trials{run}(1:5),'_v_',P2trials{run+count}(1:5),'_P2.fig'));
        
            %find area
            area = trapz(xcor);
            areaabs = trapz(abs(xcor));
            [peak, firstpeak] = max(xcor);
            [trough, firsttrough] = min(xcor);
            otherpeaks = (find(xcor == peak))'; 
            othertroughs = (find(xcor == trough))';
            
            % make all vectors the same size
            maxLength = max([length(area), length(areaabs), length(peak), length(firstpeak), length(otherpeaks), length(othertroughs)]);
            area(length(area)+1:maxLength) = 0;
            areaabs(length(areaabs)+1:maxLength) = 0;
            peak(length(peak)+1:maxLength) = 0;
            firstpeak(length(firstpeak)+1:maxLength) = 0;
            trough(length(trough)+1:maxLength) = 0;
            firsttrough(length(firsttrough)+1:maxLength) = 0;
            otherpeaks(length(otherpeaks)+1:maxLength) = 0;
            othertroughs(length(othertroughs)+1:maxLength) = 0;
            

            T = table(area,areaabs,firstpeak,peak, firsttrough, trough,otherpeaks, othertroughs);
            writetable(T, strcat(datafolder,'/',P2trials{run}(1:5),'_v_',P2trials{run+count}(1:5),'_P2xcor-analysis.csv'));
           dlmwrite(strcat(datafolder,'/',P2trials{run}(1:5),'_v_',P2trials{run+count}(1:5),'_P2xcor.csv'), xcor);

        end
        count=count+1;
    end
end

for run = 1:length(UP1trials)-1
    count = 1;
    
    data1 = importdata(strcat(path,UP1trials{run}));
    lengthdata1 = length(data1);

    while count < length(UP1trials) % needs to be less than because we are using this index to add to the previous index to compare (so total in index will be max length)
        if count+run <= length(UP1trials)
            data2 = importdata(strcat(path,UP1trials{run+count}));
        
            lengthdata2 = length(data2);
        
            if lengthdata1 > lengthdata2
                range = lengthdata2;
            else
                range = lengthdata1;
            end
        
            % perform xcorr
            [xcor,lag] = xcorr(data1(1:range)-mean(data1(1:range)),data2(1:range)-mean(data2(1:range)),'coeff');
            plot(lag,xcor);
            title([UP1trials{run}(1:5),'\_v\_',UP1trials{run+count}(1:5) '\_UP1']);
            saveas(gcf, strcat(datafolder,'/',UP1trials{run}(1:5),'_v_',UP1trials{run+count}(1:5),'_UP1.fig'));
        
            %find area
            area = trapz(xcor);
            areaabs = trapz(abs(xcor));
            [peak, firstpeak] = max(xcor);
            [trough, firsttrough] = min(xcor);
            otherpeaks = (find(xcor == peak))'; 
            othertroughs = (find(xcor == trough))';
            
            % make all vectors the same size
            maxLength = max([length(area), length(areaabs), length(peak), length(firstpeak), length(otherpeaks), length(othertroughs)]);
            area(length(area)+1:maxLength) = 0;
            areaabs(length(areaabs)+1:maxLength) = 0;
            peak(length(peak)+1:maxLength) = 0;
            firstpeak(length(firstpeak)+1:maxLength) = 0;
            trough(length(trough)+1:maxLength) = 0;
            firsttrough(length(firsttrough)+1:maxLength) = 0;
            otherpeaks(length(otherpeaks)+1:maxLength) = 0;
            othertroughs(length(othertroughs)+1:maxLength) = 0;
            

            T = table(area,areaabs,firstpeak,peak, firsttrough, trough,otherpeaks, othertroughs);
            dlmwrite(strcat(datafolder,'/',UP1trials{run}(1:5),'_v_',UP1trials{run+count}(1:5),'_UP1xcor.csv'), xcor);
            writetable(T, strcat(datafolder,'/',UP1trials{run}(1:5),'_v_',UP1trials{run+count}(1:5),'_UP1xcor-analysis.csv'));
        end
        count=count+1;
    end
end
for run = 1:length(UP2trials)-1
    count = 1;
    
    data1 = importdata(strcat(path,UP2trials{run}));
    lengthdata1 = length(data1);

    while count < length(UP2trials) % needs to be less than because we are using this index to add to the previous index to compare (so total in index will be max length)
        if count+run <= length(UP2trials)
            data2 = importdata(strcat(path,UP2trials{run+count}));
        
            lengthdata2 = length(data2);
        
            if lengthdata1 > lengthdata2
                range = lengthdata2;
            else
                range = lengthdata1;
            end
        
            % perform xcorr
            [xcor,lag] = xcorr(data1(1:range)-mean(data1(1:range)),data2(1:range)-mean(data2(1:range)),'coeff');
            plot(lag,xcor);
            title([UP2trials{run}(1:5),'\_v\_',UP2trials{run+count}(1:5) '\_UP2']);
            saveas(gcf, strcat(datafolder,'/',UP2trials{run}(1:5),'_v_',UP2trials{run+count}(1:5),'_UP2.fig'));
           
            %find area
            area = trapz(xcor);
            areaabs = trapz(abs(xcor));
            [peak, firstpeak] = max(xcor);
            [trough, firsttrough] = min(xcor);
            otherpeaks = (find(xcor == peak))'; 
            othertroughs = (find(xcor == trough))';
            
            % make all vectors the same size
            maxLength = max([length(area), length(areaabs), length(peak), length(firstpeak), length(otherpeaks), length(othertroughs)]);
            area(length(area)+1:maxLength) = 0;
            areaabs(length(areaabs)+1:maxLength) = 0;
            peak(length(peak)+1:maxLength) = 0;
            firstpeak(length(firstpeak)+1:maxLength) = 0;
            trough(length(trough)+1:maxLength) = 0;
            firsttrough(length(firsttrough)+1:maxLength) = 0;
            otherpeaks(length(otherpeaks)+1:maxLength) = 0;
            othertroughs(length(othertroughs)+1:maxLength) = 0;
            
            dlmwrite(strcat(datafolder,'/',UP2trials{run}(1:5),'_v_',UP2trials{run+count}(1:5),'_UP2xcor.csv'), xcor);
            T = table(area,areaabs,firstpeak,peak, firsttrough, trough,otherpeaks, othertroughs);
            writetable(T, strcat(datafolder,'/',UP2trials{run}(1:5),'_v_',UP2trials{run+count}(1:5),'_UP2xcor-analysis.csv'));
        end
        count=count+1;
    end
end

for run = 1:length(Rectrials)-1
    count = 1;
    
    data1 = importdata(strcat(path,Rectrials{run}));
    lengthdata1 = length(data1);

    while count < length(Rectrials) % needs to be less than because we are using this index to add to the previous index to compare (so total in index will be max length)
        if count+run <= length(Rectrials)
            data2 = importdata(strcat(path,Rectrials{run+count}));
        
            lengthdata2 = length(data2);
        
            if lengthdata1 > lengthdata2
                range = lengthdata2;
            else
                range = lengthdata1;
            end
        
            % perform xcorr
            [xcor,lag] = xcorr(data1(1:range)-mean(data1(1:range)),data2(1:range)-mean(data2(1:range)),'coeff');
            plot(lag,xcor);
            title([Rectrials{run}(1:5),'\_v\_',Rectrials{run+count}(1:5) '\_Rec']);
            saveas(gcf, strcat(datafolder,'/',Rectrials{run}(1:5),'_v_',Rectrials{run+count}(1:5),'_Rec.fig'));
        
            %find area
            area = trapz(xcor);
            areaabs = trapz(abs(xcor));
            [peak, firstpeak] = max(xcor);
            [trough, firsttrough] = min(xcor);
            otherpeaks = (find(xcor == peak))'; 
            othertroughs = (find(xcor == trough))';
            
            % make all vectors the same size
            maxLength = max([length(area), length(areaabs), length(peak), length(firstpeak), length(otherpeaks), length(othertroughs)]);
            area(length(area)+1:maxLength) = 0;
            areaabs(length(areaabs)+1:maxLength) = 0;
            peak(length(peak)+1:maxLength) = 0;
            firstpeak(length(firstpeak)+1:maxLength) = 0;
            trough(length(trough)+1:maxLength) = 0;
            firsttrough(length(firsttrough)+1:maxLength) = 0;
            otherpeaks(length(otherpeaks)+1:maxLength) = 0;
            othertroughs(length(othertroughs)+1:maxLength) = 0;
            
            dlmwrite(strcat(datafolder,'/',Rectrials{run}(1:5),'_v_',Rectrials{run+count}(1:5),'_Recxcor.csv'), xcor);
            T = table(area,areaabs,firstpeak,peak, firsttrough, trough,otherpeaks, othertroughs);
            writetable(T, strcat(datafolder,'/',Rectrials{run}(1:5),'_v_',Rectrials{run+count}(1:5),'_Recxcor-analysis.csv'));
        end
        count=count+1;
    end
end

cd(current)