clear; close all;
origin = pwd;
addpath('.')

paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/smoothed_gemini/*.csv','output','cell');
master = [];
for j = 1:length(paths)
    path = paths{j};
    cd(path)
    prefiles = dir('*.csv');
    files = {prefiles.name};
    str = pwd;
    idx = strfind(str,'/');
    subjname = str(idx(end)+1:end);


    file1 = cell(5);
    file2 = cell(5);
    c1 = 1;
    c2 = 1;
    param1 = 'HR';
    param2 = 'TEMP';

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
    
    if strcmp(param1,param2)
        file2 = file1;
    end

    file1 = epochsort(file1);
    file2 = epochsort(file2);

    cdims = [];

   signal1 = load(file1{3});
   signal2 = load(file2{3});
   if strcmp(param1,'IBI')
           signal1 = signal1(:,2);
           signal2 = signal2(:,2);
   end
   if j == 1
        [m, tau] = cross_fnn(signal1,signal2,0);

        if mod(m,2) == 1
            m = m+1;
        end
        'EmbDim found';
   end
    
    for i = 1:5

       signal1 = load(file1{i});
       signal2 = load(file2{i});
       
       if strcmp(param1,'IBI')
           signal1 = signal1(:,2);
           signal2 = signal2(:,2);
       end
       cdim = shcorrdim(signal1,signal2,m,tau);
       cdims = [cdims cdim];
    end
    figure
    plot(cdims,'k','LineWidth',2)
    xlim([0,6])
    xlabel('Epoch')
    ylabel('Correlation Dimension')
    xticks([0:6])
    xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''})
    title(strcat('Joint Correlation Dimension-',subjname,'-',param1,'-',param2))
    drawnow;
    master = [master; cdims];
    %savefig(strcat('./plots/jointcorr/',param1,'-',param2,'-corrdim-',subjname))
end
cd(origin)