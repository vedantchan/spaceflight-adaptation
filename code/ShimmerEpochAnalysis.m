% 3/24/19
% Simple shimmer epoch analysis

% calculates from R vectors the RMS, peak to peak, etc. for each epoch,
% for each vector, for each subject
% compiles all data into one file ...?

% run on entire shimmer folder

%none of this data is resampled!
%****should resample raw data

%3/31/19: stuck on looping through files

clear; close all;

uiwait(msgbox('Select your shimmer folder'))
shimPath = uigetdir;
cd(shimPath);
mainfolder = 'ShimEpochAnalysis';
% headfolder = 'Head';
% bodyfolder = 'Body';
% rarmfolder = 'Right Arm';
% larmfolder = 'Left Arm';
%mkdir(mainfolder)
% mkdir(headfolder)
% mkdir(bodyfolder)
% mkdir(rarmfolder)
% mkdir(larmfolder)

% create empty arrays to store vector info
string = ls;
list = strsplit(string);
subjlist = sort(list(~cellfun('isempty',list)));
datatype = {'RMSx','RMSy', 'RMSz', 'RMSrT', 'RMSwx', 'RMSwy', 'RMSwz', 'RMSwT', 'P2Px', 'P2Py', 'P2Pz', 'P2PrT', 'P2Pwx', 'P2Pwy',  'P2Pwz', 'P2PwT', 'MAXr', 'MINr', 'MAXw', 'MINw' }';
UP1 = zeros(1,20)';
UP2 = zeros(1,20)';
P1  = zeros(1,20)';
P2 = zeros(1,20)';
REC = zeros(1,20)';

%storage path: shimmer/subj#/epochanalysis/[bodypart].csv
%left to do: run through both split folders and vector folder; gather 20
%data points from each for each epoch; 
% store in table with epoch name going across, data type going down; each
% file is named with one body part

%maybe just recalculate vector? >> yes
% might be interesting to plot the findpeaks data
% filtering ....

for subjCount = 1:length(subjlist)
    epochfolder = [shimPath '/'  subjlist{subjCount} '/'  mainfolder '/'];
    mkdir(epochfolder)
    splitpath = [shimPath '/' subjlist{subjCount} '/' 'ShimmerSplit'];
    %vectorpath = [shimPath '/' subjlist{subjCount} '/' 'Vector'];
    splitfiles = dir(fullfile(splitpath, '*.csv')); 
    %vectorfiles = dir(fullfile(vectorpath,'*.csv'));
    
    for file = 1:length(splitfiles)
        if contains(splitfiles(file).name,'body','IgnoreCase',true) %TEST FOR EMPTY
            if contains(splitfiles(file).name,'body_UP1','IgnoreCase',true)
                data = importdata(strcat(splitfiles(file).folder,'/',splitfiles(file).name));
               
                % RMS r
                % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3882286/ 
                x = data(:,2);
                y= data(:,3);
                z = data(:,4);
                rT = sqrt((x.^2) + (y.^2) + (z.^2));

                UP1(1) = rms(x);
                UP1(2) = rms(y);
                UP1(3) = rms(z);
                UP1(4) = sqrt((UP(1).^2) + (UP1(2).^2) + (UP1(3).^2));    %CHECK
                UP1(9) = peak2peak(x);
                UP1(10) = peak2peak(y);
                UP1(11) = peak2peak(z);
                UP1(12) = peak2peak(rT);
                UP1(17) = max(rT);
                UP1(18) = min(rT);
                
                % RMS w
                if data(1,8) > 100 % test for battery 
                    wx = data(:,9); 
                    wy = data(:,10);
                    wz = data(:,11);
                else
                   wx = data(:,8);
                   wy = data(:,9);
                    wz = data(:,10);                      
                end
                wT = sqrt((wx.^2) + (wy.^2) + (wz.^2));
                 UP1(5) = rms(wx);
                 UP1(6) = rms(wy);
                 UP1(7) = rms(wz);
                 UP1(8) = sqrt((UP1(5).^2) + (UP1(6).^2) + (UP1(7).^2));    
                 UP1(13) = peak2peak(wx);
                 UP1(14) = peak2peak(wy);
                 UP1(15) = peak2peak(wz);
                 UP1(16) = peak2peak(wT);
                UP1(19) = max(wT);
                UP1(20) = min(wT);
                
            elseif contains(splitfiles(file).name,'body_UP2','IgnoreCase',true)
                                data = importdata(strcat(splitfiles(file).folder,'/',splitfiles(file).name));
               
                % RMS r
                % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3882286/ 
                x = data(:,2);
                y= data(:,3);
                z = data(:,4);
                rT = sqrt((x.^2) + (y.^2) + (z.^2));

                UP2(1) = rms(x);
                UP2(2) = rms(y);
                UP2(3) = rms(z);
                UP2(4) = sqrt((UP2(1).^2) + (UP2(2).^2) + (UP2(3).^2));    %CHECK
                UP2(9) = peak2peak(x);
                UP2(10) = peak2peak(y);
                UP2(11) = peak2peak(z);
                UP2(12) = peak2peak(rT);
                UP2(17) = max(rT);
                UP2(18) = min(rT);
                
                % RMS w
                if data(1,8) > 100 % test for battery 
                    wx = data(:,9); 
                    wy = data(:,10);
                    wz = data(:,11);
                else
                   wx = data(:,8);
                   wy = data(:,9);
                    wz = data(:,10);                      
                end
                wT = sqrt((wx.^2) + (wy.^2) + (wz.^2));
                 UP2(5) = rms(wx);
                 UP2(6) = rms(wy);
                 UP2(7) = rms(wz);
                 UP2(8) = sqrt((UP2(5).^2) + (UP2(6).^2) + (UP2(7).^2));    
                 UP2(13) = peak2peak(wx);
                 UP2(14) = peak2peak(wy);
                 UP2(15) = peak2peak(wz);
                 UP2(16) = peak2peak(wT);
                UP2(19) = max(wT);
                UP2(20) = min(wT);
            elseif contains(splitfiles(file).name,'body_P1','IgnoreCase',true)
                                data = importdata(strcat(splitfiles(file).folder,'/',splitfiles(file).name));
               
                % RMS r
                % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3882286/ 
                x = data(:,2);
                y= data(:,3);
                z = data(:,4);
                rT = sqrt((x.^2) + (y.^2) + (z.^2));

                P1(1) = rms(x);
                P1(2) = rms(y);
                P1(3) = rms(z);
                P1(4) = sqrt(( P1(1).^2) + (P1(2).^2) + (P1(3).^2));    %CHECK
                P1(9) = peak2peak(x);
                P1(10) = peak2peak(y);
                P1(11) = peak2peak(z);
                P1(12) = peak2peak(rT);
                P1(17) = max(rT);
                P1(18) = min(rT);
                
                % RMS w
                if data(1,8) > 100 % test for battery 
                    wx = data(:,9); 
                    wy = data(:,10);
                    wz = data(:,11);
                else
                   wx = data(:,8);
                   wy = data(:,9);
                    wz = data(:,10);                      
                end
                wT = sqrt((wx.^2) + (wy.^2) + (wz.^2));
                 P1(5) = rms(wx);
                 P1(6) = rms(wy);
                 P1(7) = rms(wz);
                 P1(8) = sqrt((P1(5).^2) + (P1(6).^2) + (P1(7).^2));    
                 P1(13) = peak2peak(wx);
                 P1(14) = peak2peak(wy);
                 P1(15) = peak2peak(wz);
                 P1(16) = peak2peak(wT);
                P1(19) = max(wT);
                P1(20) = min(wT);
            elseif contains(splitfiles(file).name,'body_P2','IgnoreCase',true)
                                data = importdata(strcat(splitfiles(file).folder,'/',splitfiles(file).name));
               
                % RMS r
                % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3882286/ 
                x = data(:,2);
                y= data(:,3);
                z = data(:,4);
                rT = sqrt((x.^2) + (y.^2) + (z.^2));

                P2(1) = rms(x);
                P2(2) = rms(y);
                P2(3) = rms(z);
                P2(4) = sqrt((P2(1).^2) + (P2(2).^2) + (P2(3).^2));    %CHECK
                P2(9) = peak2peak(x);
                P2(10) = peak2peak(y);
                P2(11) = peak2peak(z);
                P2(12) = peak2peak(rT);
                P2(17) = max(rT);
                P2(18) = min(rT);
                
                % RMS w
                if data(1,8) > 100 % test for battery 
                    wx = data(:,9); 
                    wy = data(:,10);
                    wz = data(:,11);
                else
                   wx = data(:,8);
                   wy = data(:,9);
                   wz = data(:,10);                      
                end
                wT = sqrt((wx.^2) + (wy.^2) + (wz.^2));
                 P2(5) = rms(wx);
                 P2(6) = rms(wy);
                 P2(7) = rms(wz);
                 P2(8) = sqrt((P2(5).^2) + (P2(6).^2) + (P2(7).^2));    
                 P2(13) = peak2peak(wx);
                 P2(14) = peak2peak(wy);
                 P2(15) = peak2peak(wz);
                 P2(16) = peak2peak(wT);
                P2(19) = max(wT);
                P2(20) = min(wT);
            elseif contains(splitfiles(file).name,'body_Rec','IgnoreCase',true)
                                data = importdata(strcat(splitfiles(file).folder,'/',splitfiles(file).name));
               
                % RMS r
                % https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3882286/ 
                x = data(:,2);
                y= data(:,3);
                z = data(:,4);
                rT = sqrt((x.^2) + (y.^2) + (z.^2));

                REC(1) = rms(x);
                REC(2) = rms(y);
                REC(3) = rms(z);
                REC(4) = sqrt((REC(1).^2) + (REC(2).^2) + (REC(3).^2));    %CHECK
                REC(9) = peak2peak(x);
                REC(10) = peak2peak(y);
                REC(11) = peak2peak(z);
                REC(12) = peak2peak(rT);
                REC(17) = max(rT);
                REC(18) = min(rT);
                
                % RMS w
                if data(1,8) > 100 % test for battery 
                    wx = data(:,9); 
                    wy = data(:,10);
                    wz = data(:,11);
                else
                   wx = data(:,8);
                   wy = data(:,9);
                    wz = data(:,10);                      
                end
                wT = sqrt((wx.^2) + (wy.^2) + (wz.^2));
                 REC(5) = rms(wx);
                 REC(6) = rms(wy);
                 REC(7) = rms(wz);
                 REC(8) = sqrt((REC(5).^2) + (REC(6).^2) + (REC(7).^2));    
                 REC(13) = peak2peak(wx);
                 REC(14) = peak2peak(wy);
                 REC(15) = peak2peak(wz);
                 REC(16) = peak2peak(wT);
                REC(19) = max(wT);
                REC(20) = min(wT);
            end
            
            T = table(datatype, UP1, UP2, P1, P2, REC);
            writetable(T,strcat(epochfolder, 'body_epochdata.csv'));
            
        elseif contains(splitfiles(file).name,'head','IgnoreCase',true)
        elseif contains(splitfiles(file).name,'right_arm','IgnoreCase',true)
        elseif contains(splitfiles(file).name,'left_arm','IgnoreCase',true)
        end
    end 
end


