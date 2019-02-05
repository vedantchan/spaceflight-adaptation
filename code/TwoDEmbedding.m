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
    
    fs = 4; %CHANGE AS NEEDED
    
    plot(signal);
    
    %Time delay
    
    [acorr,lagtime] = xcorr(signal-mean(signal),'coeff');
    %plot(lagtime,acorr)
    
    k = find(acorr > max(acorr)/exp(1),1);
    T = length(signal)/4; %Total time in seconds
    [dummy,idx] = max(acorr);
    L = (idx-k);
    
    delayedsignal = delayseq(signal,L);
    
    %plot(delayedsignal(L+1:end))
    plot(signal(L+1:end),delayedsignal(L+1:end),'k')
    title(strcat('2-D Time-Delay Embedding: ',subjname{1},'-',strrep(strrep(file{i}(1:15), '_', '-'),'.csv','')))
    xlabel('signal (t)')
    ylabel('signal (t+L)')
    savefig(strcat('plots/2d-embeddings/2dEmbed',subjname{1},file{i}(1:15),'.fig'));
end


