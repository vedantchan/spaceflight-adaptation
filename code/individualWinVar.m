%windw variance analysis for one subject

% 6/5/19 Variance analysis, try 1

clear all;
close;
current = pwd;

% 6/5/19: one subject
% 6/6: DONE, make into percentage

%****NOTE ABOUT WINDOW SIZE: changed to percentage: 10 is ideal, eq. to
%0.51% or .0051

%%

subj_pwd = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/smoothed_apollo/subj23';

hrfiles = dir(fullfile(subj_pwd,'HR.csv*.csv'));
hrsortedfiles = {{strcat(hrfiles(1).folder,'/HR.csv_E4_UP1_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_UP2_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_P1_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_P2_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_Rec_smoothedandresampled.csv')}};

windowsize = 10;
windowpercent = 0.0051;

%variance output
cellofnew = windowvar(hrsortedfiles,windowpercent);

%plot
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

saveas(gcf,strcat(current,'/','tempvarianceplots','/','subj23','/','fixed_var_with_window_',num2str(windowsize),'.fig'));

