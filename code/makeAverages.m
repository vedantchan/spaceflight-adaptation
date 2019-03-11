%% Load file

clear; close all;
origin = pwd;
[file,path] = uigetfile('*.csv','MultiSelect','on');

if class(file) == 'char'
    file = {file};
end

file = sort(file);
file = file.';

%% Sort by epoch

prefile = file;
len = length(prefile);
file={};
for i = 1:(len/5)
    
    next = epochsort(prefile);
    file = [file next];
    prefile = prefile(1:end-5,:);
    
end

%% Take statistics
file = file.';

outArray = cell(length(file),3);
[outArray{:,1}] = file{:};

cd(path)
for i = 1:length(file)
    
    signal = load(file{i});
    
    outArray{i,2} = mean(signal);
    outArray{i,3} = var(signal);
 
end

table = cell2table(outArray,'VariableNames',{'epoch','mean','variance'});
writetable(table,'statistics.csv')
cd(origin)