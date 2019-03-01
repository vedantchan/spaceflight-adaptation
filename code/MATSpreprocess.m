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
    if contains(file{i},'HR')
        measure = 'HR-';
    elseif contains(file{i},'TEMP')
        measure = 'TEMP-';
    elseif contains(file{i},'EDA')
        measure = 'EDA-';
    end
    concat = [concat; signal];
    
%     random method
%     surrogate = signal(randperm(length(signal)));
%     hold on;
%     plot(surrogate)
    cd('MATSfiles');
    if contains(file{i},'UP1')
        save(strcat(measure,'UP1'),'signal')
    elseif contains(file{i},'UP2')
        save(strcat(measure,'UP2'),'signal')
    elseif contains(file{i},'P1')
        save(strcat(measure,'P1'),'signal')
    elseif contains(file{i},'P2')
        save(strcat(measure,'P2'),'signal')
    elseif contains(file{i},'Rec')
        save(strcat(measure,'REC'),'signal')
    end
    cd ..
end
cd('MATSfiles');
save(strcat(measure,'trial'),'concat');

cd(origin);