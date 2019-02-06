%% init

clear; close all;

subjname = 'test'

%% temp filenames when building code

% fperm = 'TEMP.csv_E4_UP1_smoothedandresampled.csv';
% pperm = '/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/smoothed/subj1/'
% 
% file = {fperm} 
% path = {pperm}

%% main

x = 1:1000;

signal = exp(-0.007*x).*cos(0.1*x);

fs = 4; %CHANGE AS NEEDED

%plot(signal);

%% Time delay

[acorr,lagtime] = xcorr(signal-mean(signal),'coeff');
%plot(lagtime,acorr)
[dummmy,mid] = max(acorr);
acorr = acorr(mid:end);
lagtime = lagtime(mid:end);
L = find(acorr < max(acorr)/exp(1),1);


% plot(lagtime,acorr)
% hold on 
% plot(L,acorr(L),'ro')
% hold off


%% embedding

k = 7

delayedsignal = [zeros(1,k*L) signal];
delayedsignal(length(signal)+1:end) = [];

%plot(delayedsignal)
plot(signal(k*L+1:end),delayedsignal(k*L+1:end),'k')
title(strcat('2-D Time-Delay Embedding: ',subjname))
xlabel('signal (t)')
ylabel('signal (t+L)')
%savefig(strcat('plots/2d-embeddings/2dEmbed',subjname));

