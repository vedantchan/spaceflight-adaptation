%% init

clear; close all;

[file,path] = uigetfile('*.csv','MultiSelect','on'); % 'files' is a cell arrays, each cell containg the name of the file

subjname = inputdlg("Subject ID?")

%% temp filenames when building code

% fperm = 'TEMP.csv_E4_UP1_smoothedandresampled.csv';
% pperm = '/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/smoothed/subj1/'
% 
% file = {fperm} 
% path = {pperm}

%% main

for i = 1:length(file)
    filepath = strcat(path,file{i});
    signal = load(filepath);
    signal = signal.';
    fs = 4; %CHANGE AS NEEDED
    
    %plot(signal);
    
    %Time delay
    [acorr,lagtime] = xcorr(signal-mean(signal),'coeff');
    %plot(lagtime,acorr)
    [dummmy,mid] = max(acorr);
    acorr = acorr(mid:end);
    lagtime = lagtime(mid:end);
    L = find(acorr < max(acorr)/exp(1),1);
    
    k = 2

    delayedsignal = [zeros(1,k*L) signal];
    delayedsignal(length(signal)+1:end) = [];
    
    %plot(delayedsignal(L+1:end))
    plot(signal(k*L+1:end),delayedsignal(k*L+1:end),'k')
    title(strcat('2-D Time-Delay Embedding: ',subjname{1},'-',strrep(strrep(file{i}(1:15), '_', '-'),'.csv','')))
    xlabel('signal (t)')
    ylabel('signal (t+L)')
    savefig(strcat('plots/2d-embeddings/2dEmbed',subjname{1},file{i}(1:15),'.fig'));
end


