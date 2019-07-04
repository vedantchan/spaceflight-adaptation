clear; close all;
origin = pwd;
[file,path] = uigetfile('*.csv','MultiSelect','on');

if class(file) == 'char'
    file = {file};
end

file = epochsort(file);
file
%% Analysis
addpath('.')
cd(path);

concat = [];

for i = 1:length(file)
    signal = load(file{i});
    concat = [concat signal.'];
end

plot(concat)