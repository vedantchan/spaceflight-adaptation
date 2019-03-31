clear; close all;
origin = pwd;
addpath('.')


cd('/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/smoothed/')



[file1,path1] = uigetfile('*.csv','MultiSelect','on');

[file2,path2] = uigetfile('*.csv','MultiSelect','on');

file1 = epochsort(file1);
file2 = epochsort(file2);

diffs = [];
cd(path1);
for i = 1:5
    
   signal1 = load(file1{i});
   signal2 = load(file2{i});
   
   diff = hphasediff(signal1,signal2,0);
   
   diffs = [diffs diff];
    
end

figure()
plot(diffs)
xticks([1:5])
xticklabels({'UP1', 'UP2' ,'P1','P2' ,'REC'})
title('Hilbert Phase Difference Across Epoch')

cd(origin)