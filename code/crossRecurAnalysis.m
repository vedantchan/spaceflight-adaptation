clear; close all;
origin = pwd;
addpath('.')

paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/smoothed_gemini/*.csv','output','cell');
masterdensity = [];
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
    param1 = 'EDA';
    param2 = 'HR';

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

    Ss = {};
    ts = {};
    N2s = {};
    densities = [];
    for i = 1:5

       signal1 = load(file1{i});
       signal2 = load(file2{i});
       
       signal1 = signal1(25:end-25);
       signal2 = signal2(25:end-25);

       [S,t, N2] = cross_recur(signal1,signal2,4,50,1);
       
       density = sum(sum(S))/length(S)^2;
       densities = [densities density];
       Ss = [Ss; S];
       ts = [ts; t];
       N2s = [N2s; N2];
    end
    masterdensity = [masterdensity; densities];
    epochs = {'UP1','UP2','P1','P2','REC'}
    hFig = figure;
    set(hFig, 'Position', [0 0 2300 400])
    for plotID = 1:5
        subplot(1,5,plotID);
        title(epochs{plotID});
        imagesc(ts{plotID}(1:(N2s{plotID})), flip(ts{plotID}(1:(N2s{plotID}))), -(Ss{plotID}));
        colormap jet;
        axis square;
        caxis([-4,0])
        xlabel('Samples'), ylabel('Samples'); 
    end
    sgtitle(strcat('Cross-Recurrence-',subjname,'-',param1,'-',param2))
    cd(origin)
    savefig(strcat('./plots/crossrecur/',param1,'-',param2,'-CrossRecurrence-',subjname))
    %c = colorbar('Direction','reverse');
    %title(c,'Negative Distance');
%     figure()
%     plot(fisherzs,'bo','MarkerSize',12)
%     xlim([0,6])
%     xlabel('Epoch')
%     ylabel('Fisher Z Score')
%     xticks([0:6])
%     xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''})
%     title(strcat('Fisher Z Correlation Across Epoch-',subjname,'-',param1,'-',param2))
%     cd(origin)
%     savefig(strcat('./plots/fisherZ/',param1,'-',param2,'Fisher_Z_Correlation_Across_Epoch-',subjname))
%     csvwrite(strcat('./meta/',param1,'-',param2,'-fisherz',subjname,'.csv'),fisherzs)
end