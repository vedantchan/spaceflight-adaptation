%% Load file

clear; close all;
origin = pwd;
[file,path] = uigetfile('*.csv','MultiSelect','on');

if class(file) == 'char'
    file = {file};
end

file = sort(file);

outArray = ones(length(file),3);
outArray{:,1} = file;


for i = 1:length(file)
    
    signal = load(file{i});
    
    outArray{i,2} = mean(signal);
    outArray{i,3} = var(signal);
    
    
    
    
    
    
end