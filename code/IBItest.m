% 7/7/19: playing with IBI data

clear all;
close;

subjfold = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data');
% just do one day for now, on skylab

data = importdata([subjfold{1} '/' 'IBI.csv'],',',1);

% differences abs
ds = diff(data.data(1:end,2));
dfs = abs(ds);
plot(dfs)

%variance in difference, window = 10


%std dev in raw, window = 10 (same as for hr variance)

for d = 1:length(data)-10
    temp =  data.data(d:d+10,2);
    ibivar = std(temp);
end


% spectral analysis?
