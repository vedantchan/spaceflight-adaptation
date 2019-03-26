% 3/24/19
% Simple shimmer epoch analysis

% calculates from R vectors the RMS, peak to peak, etc. for each epoch,
% for each vector, for each subject
% compiles all data into one file ...?

% run on entire shimmer folder

clear; close all;

uiwait(msgbox('Select your shimmer folder'))
shimPath = uigetdir;
cd(shimPath);
mainfolder = 'ShimEpochAnalysis';
headfolder = 'Head';
bodyfolder = 'Body';
rarmfolder = 'Right Arm';
larmfolder = 'Left Arm';
mkdir(mainfolder)
mkdir(bodyfolder)
mkdir(rarmfolder)
mkdir(larmfolder)

% create empty arrays to store vector info
subjlist = sort(strsplit(ls));
RMSrT = zeros(1,10)';
RMSx = zeros(1,10)';
RMSy = zeros(1,10)';
RMSz = zeros(1,10)';
RMSwT = zeros(1,10)';
RMSwx = zeros(1,10)';
RMSwy = zeros(1,10)';
RMSwz = zeros(1,10)';
P2Pr = zeros(1,10)';
P2Px = zeros(1,10)';
P2Py = zeros(1,10)';
P2Pz = zeros(1,10)';
P2Pwx = zeros(1,10)';
P2Pwy = zeros(1,10)';
P2Pwz = zeros(1,10)';
P2Pw = zeros(1,10)';
MAXr = zeros(1,10)';
MINr = zeros(1,10)';


for subjCount = 1:length(subjlist)
    splitpath = [shimPath '/' subjlist{subjCount} '/' 'ShimmerSplit'];
    vectorpath = [shimPath '/' subjlist{subjCount} '/' 'Vector'];
    splitfiles = dir(fullfile(splitpath, '*.csv')); 
    
    for i = 1:length(splitfiles)
        if contains(splitfiles(i).name,'head','IgnoreCase',true) %TEST FOR EMPTY
            if contains(splitfiles(i).name,'UP1','IgnoreCase',true)
                
        elseif contains(splitfiles(i).name,'body','IgnoreCase',true)
        elseif contains(splitfiles(i).name,'right_arm','IgnoreCase',true)
        elseif contains(splitfiles(i).name,'left_arm','IgnoreCase',true)
        end
        data = importdata(strcat(splitfiles(i).folder,'/',splitfiles(i).name));

        % RMS r
        RMSx( = rms(data(:,2));
        RMSy = rms(data(:,3));
        RMSz = rms(data(:,4));
        RMSrT = sqrt((x.^2) + (y.^2) + (z.^2));    

        % RMS w
        if data(1,8) > 100
            RMSwx = rms(data(:,9));
            RMSwy = rms(data(:,10));
            RMSwz = rms(data(:,11));
        else
            RMSwx = rms(data(:,8));
            RMSwy = rms(data(:,9));
            RMSwz = rms(data(:,10));
        end
        RMSwT = sqrt((wx.^2) + (wy.^2) + (wz.^2));    
        dlmwrite(['Vector' '/' splitfiles(i).name(1:end-4) '_wvec.csv'],[data(:,1) wvec]);   
    end
    
end
% RMS calculation


