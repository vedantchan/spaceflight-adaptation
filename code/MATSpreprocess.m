%% Load file

clear; close all;
origin = pwd;
[file,path] = uigetfile('*.csv','MultiSelect','on');

if class(file) == 'char'
    file = {file};
end

concat = [];

%% Analysis
cd(path);
mkdir('MATSfiles');
for i = 1:length(file)
    signal = load(file{i});
    plot(signal)
    
    concat = [concat; signal];
    
%     random method
%     surrogate = signal(randperm(length(signal)));
%     hold on;
%     plot(surrogate)
    cd('MATSfiles');
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
    cd ..
end
cd('MATSfiles');
save('trial','concat')

cd(origin);