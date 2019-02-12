%% Load file

clear; close all;
origin = pwd;
[file,path] = uigetfile('*.csv','MultiSelect','on');

if class(file) == 'char'
    file = {file}
end


%% Analysis
cd(path);
for i = 1:length(file)
    signal = load(file{i});
    plot(signal)
    
%     random method
%     surrogate = signal(randperm(length(signal)));
%     hold on;
%     plot(surrogate)
    if contains(file{i},'UP1')
        save('UP1','signal')
    elseif contains(file{i},'UP2')
        save('UP2','signal')
    elseif contains(file{i},'P1')
        save('P1','signal')
    elseif contains(file{i},'P2')
        save('P2','signal')
    elseif contains(file{i},'Rec')
        save('REC','signal')
    end
    
end













cd(origin);