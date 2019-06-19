% 6/5/19 Variance analysis, try 1

clear all;
close;
current = pwd;

% 6/5/19: one subject
% 6/6: DONE, make into percentage

%****NOTE ABOUT WINDOW SIZE: changed to percentage: 10 is ideal, eq. to
%0.51% or .0051

%% to do:
% - how to window size >> maybe doesnt matter, only the last value would be
% affected
% - do for all subjects
% - finalize folder structure
% - put variance calculation into function (?)
% - compute cross corr with anything else >>> check that xcorr works with
% this data
%rename this code to windowedVariance
%%

% pulling from hr data, subj23

subj_pwd = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/smoothed_apollo/subj23';

hrfiles = dir(fullfile(subj_pwd,'HR.csv*.csv'));
hrsortedfiles = {{strcat(hrfiles(1).folder,'/HR.csv_E4_UP1.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_UP2.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_P1.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_P2.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_REC.csv')}};

windowsize = 10;
windowpercent = 0.0051;

cellofnew = windowvar(hrsortedfiles,windowpercent);

% % resample data to max length data so window size can be applied to all
% hrrawdata1 = importdata(hrsortedfiles{1}{1});
% hrrawdata2 = importdata(hrsortedfiles{2}{1});
% hrrawdata3 = importdata(hrsortedfiles{3}{1});
% hrrawdata4 = importdata(hrsortedfiles{4}{1});
% hrrawdata5 = importdata(hrsortedfiles{5}{1});
% 
% % hrrawdata1 = hrrawdata1(20:end);
% % hrrawdata5 = hrrawdata5(20:end-20);
% 
% [maxlength, atdata] = max([length(hrrawdata1); length(hrrawdata2);length(hrrawdata3);length(hrrawdata4);length(hrrawdata5)]);
% 
% hrdata1 = resample(hrrawdata1,maxlength,length(hrrawdata1));
% hrdata2 = resample(hrrawdata2,maxlength,length(hrrawdata2));
% hrdata3 = resample(hrrawdata3,maxlength,length(hrrawdata3));
% hrdata4 = resample(hrrawdata4,maxlength,length(hrrawdata4));
% hrdata5 = resample(hrrawdata5,maxlength,length(hrrawdata5));
% 
% hralldata = [hrdata1 hrdata2 hrdata3 hrdata4 hrdata5];
% 
% % make variance data folder
% % varfolder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/variance';
% % mkdir(varfolder)
% % cd(varfolder)
% % mkdir('subj23')
% % cd('subj23')
% 
% % find variance, place into new arr
% 
% %windowsize = inputdlg('What is the window size you wish to use?'); OR
% %find the greatest prime factor ...
% windowsize = 10;
% 
% newdata1 = [];
% newdata2 = [];
% newdata3 = [];
% newdata4 = [];
% newdata5 = [];
% 
% cellofnew = {newdata1 newdata2 newdata3 newdata4 newdata5};
% 
% 
% % SOMETHING STRANGE FOR FIRST DATA SET
% for datacount = 1:5     % loop through all epochs
%     currentdata = hralldata(:,datacount);
%     tempnewarr = [];
% 
%     for indcount = 1:windowsize:maxlength-3
%         % - loop thru the data and calculate the variance at each index
%         % - then repeat the variance value the same number of time as the
%         % window size
%         % - then put into new array
%         temparr = currentdata(indcount:indcount+windowsize-1);
%         varofwindow = var(temparr);
%         tempnewarr = [tempnewarr repelem(varofwindow,windowsize)];
%     end
%     cellofnew{datacount} = tempnewarr;
% end
% 
% % spit out variance vector
% newdata1 = cellofnew{1}';
% newdata2 = cellofnew{2}';
% newdata3 = cellofnew{3}';
% newdata4 = cellofnew{4}';
% newdata5 = cellofnew{5}';

figure
subplot(5,1,1)
plot(cellofnew{1}(120:end));
title(['window size ' num2str(windowsize)])
ylim([0 2.5])
subplot(5,1,2)
plot(cellofnew{2});
ylim([0 2.5])
subplot(5,1,3)
plot(cellofnew{3});
ylim([0 2.5])
subplot(5,1,4)
plot(cellofnew{4});
ylim([0 2.5])
subplot(5,1,5)
plot(cellofnew{5}(10:end-10));
ylim([0 2.5])
% 
% saveas(gcf,strcat(current,'/','tempvarianceplots','/','fixed_var_with_window_',num2str(windowsize),'.fig'));

% dlmwrite....etc x5

%% try: crosscorr (w temp)
% % will use other code, maybe..
% 
% cd(current);
% 
% tempfiles = dir(fullfile(subj_pwd,'TEMP.csv*.csv'));
% tempsortedfiles = {{strcat(tempfiles(1).folder,'/TEMP.csv_E4_UP1.csv')} {strcat(tempfiles(1).folder,'/HR.csv_E4_UP2.csv')} {strcat(hrfiles(1).folder,'/TEMP.csv_E4_P1.csv')} {strcat(tempfiles(1).folder,'/TEMP.csv_E4_P2.csv')} {strcat(tempfiles(1).folder,'/TEMP.csv_E4_REC.csv')}};
% 
% temprawdata1 = importdata(tempsortedfiles{1}{1});
% temprawdata2 = importdata(tempsortedfiles{2}{1});
% temprawdata3 = importdata(tempsortedfiles{3}{1});
% temprawdata4 = importdata(tempsortedfiles{4}{1});
% temprawdata5 = importdata(tempsortedfiles{5}{1});
% 
% %resample
% 
% tpdata1 = resample(temprawdata1,maxlength,length(temprawdata1));
% tpdata2 = resample(temprawdata2,maxlength,length(temprawdata2));
% tpdata3 = resample(temprawdata3,maxlength,length(temprawdata3));
% tpdata4 = resample(temprawdata4,maxlength,length(temprawdata4));
% tpdata5 = resample(temprawdata5,maxlength,length(temprawdata5));
% 
% tpalldata = [tpdata1 tpdata2 tpdata3 tpdata4 tpdata5];
% % xcorr!
% 
% tempfolder = 'tempfolder';
% mkdir(tempfolder)
% 
% for xcorcount = 1:5
%     tempconversionhr = cellofnew{xcorcount}';
%     tempconversiontp = tpalldata(:,xcorcount);
%     [xcor,lag] = xcorr(tempconversionhr(1:end)-mean(cellofnew{xcorcount}), tempconversiontp(1:end)-mean(cellofnew{xcorcount}),'coeff');
%     plot(lag,xcor);
%     saveas(gcf,strcat(current,'/',tempfolder,'/','E', num2str(xcorcount),'.fig'));
%     dlmwrite(strcat(current,'/',tempfolder,'/','E',num2str(xcorcount),'.csv'),xcor)
% end
