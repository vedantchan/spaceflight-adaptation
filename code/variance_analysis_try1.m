% 6/5/19 Variance analysis, try 1

clear all;
close;

% 6/5/19: one subject

hr_pwd = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/raw_apollo/subj23/EmpaticaSplit';

hrfiles = dir(fullfile(hr_pwd,'HR.csv*.csv'));
sortedfiles = {{strcat(hrfiles(1).folder,'/HR.csv_E4_UP1.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_UP2.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_P1.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_P2.csv')} {strcat(hrfiles(1).folder,'/HR.csv_E4_REC.csv')}};

data1 = importdata(sortedfiles{1}{1});
data2 = importdata(sortedfiles{2}{1});
data3 = importdata(sortedfiles{3}{1});
data4 = importdata(sortedfiles{4}{1});
data5 = importdata(sortedfiles{5}{1});

minlength = min([length(data1); length(data2);length(data3);length(data4);length(data5)]);



%windowsize = 4; % need to come up with a way to set the window size so any length of data will be divisible by that number

%ind = length1/









%data = importdata(strcat(hr_pwd,'/','HR.csv*'));


