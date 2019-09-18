clear; close all;
origin = pwd;
addpath('.')
master = [];
paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/*.csv','output','cell');
allscores = [];
for j = 1:length(paths)
    path = strcat(paths{j},'/EmpaticaSplit/');
    try
        cd(path);
    catch
        disp('No file');
        continue;
    end
    
    prefiles = dir('*.csv');
    files = {prefiles.name};
    str = pwd;
    idx = strfind(str,'/');
    subjname = str(idx(end)+1:end);


    file1 = cell(5);
    c1 = 1;

    param1 = 'EDA';


    for i = 1:length(files)
        if startsWith(files{i},'.')
            continue;
        elseif contains(files{i},param1)
            file1{c1} = files{i};
            c1 = c1+1;
        end
    end

    file1 = epochsort(file1);

    dfas = [];
    pvals = [];
    for i = 1:5

       signal1 = load(file1{i});
       
       if strcmp(param1,'IBI')
           signal1 = signal1(:,2).';
           signal1 = interp1(1:length(signal1),signal1,1:0.1:length(signal1));
       end
       
       [H,pval,p] = dfa(signal1);

       dfas = [dfas H];
       pvals = [pvals; pval];
    end
 
    allscores = [allscores; dfas];
    hold on
    plot(dfas,'MarkerSize',12)
    drawnow;
    xlim([0,6])
    xlabel('Epoch')
    ylabel('DFA')
    xticks([0:6])
    xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''})
    title(strcat('DFA Exponent-',subjname,'-',param1))
    cd(origin)
%     savefig(strcat('./plots/dfa/',param1,'DFA-',subjname))
%     csvwrite(strcat('./meta/',param1,'-dfa',subjname,'.csv'),dfas)
    master = [master; dfas];
end