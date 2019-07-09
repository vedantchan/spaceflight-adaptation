% 7/7/19: playing with IBI data
% THERE IS ONLY ONE FILE  U ARE WORKING WITH
%doing it per subj atm; still works too slowly

clear all;
close;

subjfold = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data');
%change eventually
subjnum = inputdlg("what subject number?");
% just do one day for now, on skylab

data = importdata([subjfold{1} '/' 'IBI.csv'],',',1);

%won't need this in the future, changed both splitting code to include IBI
%split: for skylab
splitind = uint64(round(length(data.data(7200:end,:)))/3);
unpert1 = data.data(1:4800,:);
unpert2= data.data(4800:7200,:);
pert1 = data.data(7200:7200+splitind,:);
pert2 = data.data(7200+splitind:7200+splitind*2,:);
recover = data.data(7200+splitind*2:end,:);

trials = [unpert1' unpert2' pert1' pert2' recover'];
%split: for regular run
% split_ind = uint64(round(length(data.data)/153));
% unpert1 = data.data(1:(split_ind)*32,:);
%              unpert2= data.data((split_ind)*32:(split_ind)*32*2,:);
%              pert1 = data.data((split_ind)*32*2:(split_ind)*32*3,:);
%              pert2 = data.data((split_ind)*32*3:(split_ind)*32*4,:);
%              pert2 = data.data((split_ind)*32*3:(split_ind)*32*4,:);

% We want the raw data too bc can do many things with it
newfolder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/apenShim'; %or something
dlmwrite(fullfile(newfolder,[subjnum{1} '_IBI.csv']),trials);

for tr = 1:5
    
    % differences abs >> this is probably the main measure
    ds = diff(trials(1:end,tr));
    dfs = abs(ds);
    plot(dfs)

    %variance in difference, window = 10


    %std dev in raw, window = 10 (same as for hr variance)

    for d = 1:length(trials)-10
        temp =  data.data(d:d+10,2);
        ibivar = std(temp);
    end


    % spectral analysis?
end
