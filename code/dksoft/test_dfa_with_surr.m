clear; close all;
origin = pwd;
addpath('.')

paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/smoothed_gemini/*.csv','output','cell');
allscores = [];
params = {'HR','TEMP','EDA'};
for counter = 1:length(params)
    for j = 1:length(paths)
        path = paths{j};
        cd(path);
        prefiles = dir('*.csv');
        files = {prefiles.name};
        str = pwd;
        idx = strfind(str,'/');
        subjname = str(idx(end)+1:end);


        file1 = cell(5);
        c1 = 1;

        param1 = params{counter};


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
        surrdfas = [];
        aaftsurrdfas = [];
        pvals = [];

        for i = 1:5 

           signal1 = load(file1{i});
           [H,pval,p] = dfa(signal1);
           dfas = [dfas H];
           pvals = [pvals; pval];

           if mod(length(signal1),2) ~= 0
              signal1 = [signal1; signal1(end)];
           end
           surrdfa = [];
           aaftsurrdfa = [];
           for i = 1:10
               rpsurr = signal1(randperm(size(signal1,1)),:);
               [surrH,~,~] = dfa(rpsurr);
               surrdfa = [surrdfa surrH];

               aaftsurr = ampsurr(signal1);
               [aaftsurrH,~,~] = dfa(aaftsurr);
               aaftsurrdfa = [aaftsurrdfa aaftsurrH];

           end
           surrdfas = [surrdfas; surrdfa];
           aaftsurrdfas = [aaftsurrdfas; aaftsurrdfa];
        end
        surrdfas = surrdfas.';
        means = mean(surrdfas);
        stds = 2*std(surrdfas);

        cd(origin)
        figure;
        errorbar(means,stds,'k+');
        hold on 
        plot(dfas,'ro','MarkerSize',10);
        xlim([0,6]);
        xticks([0:6]);
        xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''});
        xlabel('Epoch');
        ylabel('DFA');
        title(strcat('DFA Exponent RP Surrogates-',subjname,'-',param1));
        savefig(strcat('./plots/dfa/',param1,'DFA_rp_surr-',subjname));

        aaftsurrdfas = aaftsurrdfas.';
        means = mean(aaftsurrdfas);
        stds = 2*std(aaftsurrdfas);
        figure;
        errorbar(means,stds,'k+');
        hold on 
        plot(dfas,'ro','MarkerSize',10);
        xlim([0,6]);
        xticks([0:6])
        xticklabels({'','UP1', 'UP2' ,'P1','P2' ,'REC',''});
        xlabel('Epoch');
        ylabel('DFA');
        title(strcat('DFA Exponent AAFT Surrogates-',subjname,'-',param1));
        savefig(strcat('./plots/dfa/',param1,'DFA_aaft_surr-',subjname));
    end
end
