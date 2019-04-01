%% 3/23/19

% This script will autocorrelate any data specified. Time lag will be the
% entire time interval of the data set. 

% This takes smoothed and r/w vector data, NOT ORIGINAL DATA
% Performed on the split trials

%need to write autocorr data into a file!

%% Script
clear all;
close;

origin = pwd;
%get files

uiwait(msgbox("Select your data from the smoothed or shimmer folder (select by subject)"))
[file,path] = uigetfile('*.csv','MultiSelect','on'); % 'files' is a cell arrays, each cell containg the name of the file

uiwait(msgbox("Select the destination directory for autocorr data"))
mainfolder = uigetdir;
answer = inputdlg('Enter folder name, e.g. subj1_e4','Folder Name'); 

datafolder = strcat(mainfolder,'/',answer{1}); % autocorr/subj#_{data}
mkdir(datafolder);
cd(mainfolder)

%------------------------------------------------------------
%NOTE: shimmer gives weird stuff 
%------------------------------------------------------------

%% Shimmer Autocorr

if contains(path, 'shimmer', 'IgnoreCase', true)
    for filecount = 1:length(file) 
         data = importdata(strcat(path,file{filecount})); % usually a struct, but if choosing from split data, it is regular bc no header
           %for singular files
           %data = importdata(strcat(path,file));
           %time = data(:,1); %CHECK: IS THIS INCLUDED IN SMOOTHED DATA: 10/6 NO ITS NOT
           rvec = data(:,2);          
           [acorr, lagtime] = xcorr(rvec-mean(rvec),'coeff');
           plot(lagtime, acorr); 
           title(['Autocorrelation of ' string(file{filecount}(1:end-4))])
           xlabel('lagtime') 
           ylabel('correlation (normalized)') 
           area = trapz(acorr);
           areaabs = trapz(abs(acorr));
           saveas(gcf,strcat(datafolder,'/',file{filecount}(1:end-4),'_plot.fig')); %save autocorr plot 
                      %saveas(gcf,strcat(headfolder,'/',file,'_plot.fig')); %save autocorr plot 

           T = table(area,areaabs);
            writetable(T, strcat(datafolder,'/',file{filecount}(1:end-4),'_areas.csv'));   
            dlmwrite(strcat(datafolder,'/',file{filecount}(1:end-4),'_autocorr.csv'),[lagtime' acorr]);
    end
end
    
%% E4 data
% DONE

if contains(file,'E4')
    for datatypecount = 1:length(file)        
        data = importdata(strcat(path,file{datatypecount}));
        
%        noautocorrdetected = []; %make a vector of the names of the graphs that accept null hypothesis (that there is no autocorr)
%        names = [];
%        h = [];
%        pvalue = [];
%        Qstat = [];    
           %perform autocorr
            [acorr, lagtime] = xcorr(data-mean(data),'coeff');
              
              plot(lagtime,acorr);
              saveas(gcf,strcat(datafolder,'/',file{datatypecount},'_plot.fig')); %save autocorr plot inside subjet folder with name corresponding to data type
              area = trapz(acorr);
              areaabs = trapz(abs(acorr));          
              
              T = table(area,areaabs);
              writetable(T, strcat(datafolder,'/',file{datatypecount},'_areas.csv'));
              dlmwrite(strcat(datafolder,'/',file{datatypecount},'_autocorrvec.csv'), [lagtime' acorr]), 
               %-----------perform LB test----------
%              [h_other,pvalue_other,Qstat_other,crit] = lbqtest(data,'Lags',[5,10,15]);
%                h = [h h_other];
%                pvalue = [pvalue pvalue_other];
%                Qstat = [Qstat Qstat_other];
%                
%                if h_other == 0
%                    noautocorrdetected = [noautocorrdetected file{datatypecount}];
%                end
           %---------------------------------------------------------------------------
        
    end   
end

cd(origin)