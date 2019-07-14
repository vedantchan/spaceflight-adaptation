clear; close all;
origin = pwd;
[file,path] = uigetfile('*.csv','MultiSelect','on');
addpath('MATS')
if class(file) == 'char'
    file = {file};
end

file = epochsort(file);

%% Analysis
addpath('.')
cd(path);

corrdims = [];
stdcorrdims = [];

for i = 1:length(file)
    signal = load(file{i});
    
    if contains(file{i},'HR')
        measure = 'HR-';
    elseif contains(file{i},'TEMP')
        measure = 'TEMP-';
    elseif contains(file{i},'EDA')
        measure = 'EDA-';
    end
    
    if contains(file{i},'UP1')
        epoch = 'UP1';
    elseif contains(file{i},'UP2')
        epoch = 'UP2';
    elseif contains(file{i},'P1')
        epoch = 'P1';
    elseif contains(file{i},'P2')
        epoch = 'P2';
    elseif contains(file{i},'Rec')
        epoch = 'REC';
    end
    
    

    
    [L,embDim,corrDim,std_corrDim] = vcorrdim(signal);
    corrdims = [corrdims corrDim];
    stdcorrdims = [stdcorrdims std_corrDim];
    hold off
    
    errorbar(corrdims,stdcorrdims,'ko')
    xlim([0,6])
    xticks([0:6])
    xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''})
    title('Correlation Dimension')
    
end


cd(origin)