clear; close all;
origin = pwd;
addpath('.')



path = uigetdir('../data/smoothed/')
cd(path)
prefiles = dir('*.csv');
files = {prefiles.name};
str = pwd;
idx = strfind(str,'/')
subjname = str(idx(end)+1:end);


file1 = cell(5);
file2 = cell(5);
c1 = 1;
c2 = 1;
param1 = 'EDA'
param2 = 'HR'

for i = 1:length(files)
    if startsWith(files{i},'.')
        continue;
    elseif contains(files{i},param1)
        file1{c1} = files{i};
        c1 = c1+1;
    elseif contains(files{i},param2)
        file2{c2} = files{i};
        c2 = c2+1;
    end
end

file1 = epochsort(file1);
file2 = epochsort(file2);

fisherzs = [];
errs = [];
for i = 1:5
    
   signal1 = load(file1{i});
   signal2 = load(file2{i});
   
   [z,surrzs] = fisherz(signal1,signal2,0);
   
   fisherzs = [fisherzs z];
   errs = [errs; surrzs]
end

figure()
plot(fisherzs,'bo','MarkerSize',12)
xlim([0,6])
xlabel('Epoch')
ylabel('Fisher Z Score')
xticks([0:6])
xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''})
title(strcat('Fisher Z Correlation Across Epoch-',subjname,'-',param1,'-',param2))
cd(origin)
savefig(strcat('plots/fisherZ/Fisher_Z_Correlation_Across_Epoch-',subjname,'-',param1,'-',param2))