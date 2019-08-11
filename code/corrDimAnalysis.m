clear; close all;
origin = pwd;
paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/*.csv','output','cell');
master = [];
addpath('MATS')

%% Analysis
addpath('.')


for j = 1:length(paths)
    
    path = paths{j};
    cd(path)
    prefiles = dir('*.csv');
    files = {prefiles.name};
    str = pwd;
    idx = strfind(str,'/');
    subjname = str(idx(end)+1:end);
    


    file = cell(5);
    c1 = 1;
    param1 = 'ibi';

    for i = 1:length(files)
        if startsWith(files{i},'.')
            continue;
        elseif contains(files{i},param1)
            file{c1} = files{i};
            c1 = c1+1;
        end
    end

    file = epochsort(file);
    
    corrdims = [];
    stdcorrdims = [];
    
    for i = 1:length(file)
        signal = load(file{i});
        signal = signal(2:end-2);
        [L,embDim,corrDim,std_corrDim] = vcorrdim(signal);
        corrdims = [corrdims corrDim];
        stdcorrdims = [stdcorrdims std_corrDim];
        
    end
    
    hold on
    errorbar(corrdims,stdcorrdims,'k','Marker','*')
    xlim([0,6])
    xticks([0:6])
    xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''})
    title('Correlation Dimension')
    drawnow;
    master = [master; corrdims];
    
end




cd(origin)