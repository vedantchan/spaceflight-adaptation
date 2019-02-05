%% Description

% This script will autocorrelate any data specified. Time lag will be the
% entire time interval of the data set. 

% Ljung Box Test will be used to determine autocorrelatedness based on standard p-value significance measures.  Regression will also be used to determine 
% to determine if the data has a "normal" rate of decay (regression will
% return some value pertaining to "normalness" (yet to be determined).
% Regression will probably be exponential decay.

%^^nevermind about any of that

%naming suggestion: use strfind, get index, use index to index 'path' so
%you can get the name from the path

% THIS TAKES SMOOTHED AND Z-VECTOR DATA, NOT ORIGINAL DATA
% Performed on the split trials

%% Script
clear all;
close;

origin = pwd;
%get files
try
%load in the data
[file,path] = uigetfile('*.csv','MultiSelect','on'); % 'files' is a cell arrays, each cell containg the name of the file
%for singular files
%[file,path] = uigetfile('*.csv');
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    

msgbox("Select the destination directory for autocorr data")
mainfolder = uigetdir;
answer = inputdlg('Enter folder name, e.g. subj1_e4','Folder Name'); 

datafolder = strcat(mainfolder,'/',answer{1});
mkdir(datafolder);
cd(mainfolder)

%------------------------------------------------------------
%NOTE: shimmer gives weird stuff 
%------------------------------------------------------------

%% Shimmer Autocorr
if contains(file, 'Shim')
    for subjcount = 1:length(file)

%-------------------HEAD ANALYSIS-------------------------------        
        if contains(file{subjcount},'HEAD') 
      %if contains(file,'HEAD')
           headfolder = strcat(datafolder,'/','Head'); % NEED TO INCLUDE THIS IN NAME
           mkdir(headfolder);

           data = importdata(strcat(path,file{subjcount})); % usually a struct, but if choosing from split data, it is regular bc no header
           %for singular files
           %data = importdata(strcat(path,file));
           %time = data(:,1); %CHECK: IS THIS INCLUDED IN SMOOTHED DATA: 10/6 NO ITS NOT
           lin_z = data(:,1);
           
           
            [acorr, lagtime] = xcorr(lin_z-mean(lin_z),'coeff');
              plot(acorr); 
%               [curve, goodness, output] = fit(lagtime, acorr(round(length(acorr)/2):end,1), 'exp1'); 
%               plot(lagtime,curve); hold off;
               area = trapz(acorr);
               areaabs = trapz(abs(acorr));
              saveas(gcf,strcat(headfolder,'/',file{subjcount},'_plot.fig')); %save autocorr plot 
                             %saveas(gcf,strcat(headfolder,'/',file,'_plot.fig')); %save autocorr plot 

              T = table(area,areaabs);
              writetable(T, strcat(headfolder,'/',file{subjcount},'_areas.csv'));
              
                            %writetable(T, strcat(headfolder,'/',file,'_areas.csv'));

               %-------------------------perform LB test --------------------
%                     [h,pvalue,Qstat,crit] = lbqtest(reldata(:,datacount),'Lags',[20,100,1000,10000,100000,length(reldata(:,datacount))-1]); % not sure whats wrong with this
%                
%                     T = table(names, h, pvalue, Qstat);
%                      writetable(T,strcat(headfolder,'/',names(datacount),'_LBtest_results')); % save lbq test results as text file
%                
%                     noautocorrdetected = []; %make a vector of the names of the graphs that accept null hypothesis (that there is no autocorr)
%                     if h == 0
%                         noautocorrdetected = [noautocorrdetected names(datacount)];
%                     end
%                     dlmwrite(strcat(headfolder,'/',names(datacount),'_No_autocorr_detected'),noautocorrdetected);
                 %------------------------------------------------------------------
           %end
 %-------------------BODY ANALYSIS-------------------------------        
        elseif strfind(file{subjcount},'BODY') > 0
           % (for singular files)
        %elseif strfind(file,'BODY') > 0
           bodyfolder = strcat(datafolder,'/','Body');
           mkdir(bodyfolder);
           
           data = importdata(strcat(path,file{subjcount})); % usually a struct, but if choosing from split data, it is regular bc no header
           %for singular files
           %data = importdata(strcat(path,file));
           lin_z = data(:,1);              
           [acorr, lagtime] = xcorr(lin_z-mean(lin_z),'coeff');
              
              plot(lagtime,acorr); 
%               [curve, goodness, output] = fit(lagtime, acorr(round(length(acorr)/2):end,1), 'exp1'); 
%               plot(lagtime,curve); hold off;
               area = trapz(acorr);
               areaabs = trapz(abs(acorr));
              saveas(gcf,strcat(bodyfolder,'/',file{subjcount},'_plot.fig')); %save autocorr plot 
               %for singular files
               %saveas(gcf,strcat(bodyfolder,'/',file,'_plot.fig')); %save autocorr plot 

              T = table(area,areaabs);
              writetable(T, strcat(bodyfolder,'/',file{subjcount},'_areas.csv'));
              %for singular files
              %writetable(T, strcat(bodyfolder,'/',file,'_areas.csv'));
        end
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