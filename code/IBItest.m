% 7/7/19: playing with IBI data
% THERE IS ONLY ONE FILE  U ARE WORKING WITH
%doing it per subj atm; still works too slowly

clear all;
close;

%pick the folder that contains all the subject folders
subjfold = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data');
d = struct2cell(dir(subjfold{1}));
subjarr = d(1,4:end); %cell

newfolder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/IBIall'; %or something

for subjcount = 1:length(subjarr)

    subjnum = subjarr{subjcount};
    if ~contains(subjnum, 'subj25_missinge4')
        %skylab:
        %data = importdata(fullfile(subjfold{1},subjnum,'IBI.csv'),',',1);
        %other:
        data = importdata(fullfile(subjfold{1},subjnum,[subjnum 'EmpaticaData'],'IBI.csv'),',',1);

        %test for max difference in data collection time
        [maxlag, ind] = max(diff(data.data(1:end,1)));

        %split: for skylab (approximately split into 5)
%         splitind = uint64(round(length(data.data)/5)); 
%         unpert1 = data.data(1:splitind,:);
%         unpert2= data.data(splitind:splitind*2,:);
%         pert1 = data.data(splitind*2:splitind*3,:);
%         pert2 = data.data(splitind*3:splitind*4,:);
%         recover = data.data(splitind*4:end,:);

        %split: for regular runs
        split_indp = uint64(round(length(data.data)*.209));
        
        unpert1 = data.data(1:(split_indp),:);
        unpert2= data.data((split_indp):(split_indp)*2,:);
        pert1 = data.data((split_indp)*2:(split_indp)*3,:);
        pert2 = data.data((split_indp)*3:(split_indp)*4,:);
        recover = data.data((split_indp)*4:end,:);

        trials = {unpert1(1:end,2) unpert2(1:end,2) pert1(1:end,2) pert2(1:end,2) recover(1:end,2)};
        % We want the raw data too bc can do many things with it
        trialnames = {'UP1' 'UP2' 'P1' 'P2' 'Rec'}';
        mkdir(fullfile(newfolder,subjnum))
      %% analysis

        %variance in difference, moving window ~ .5%
        cellofvar = windowvar(trials,.0051);
        cellofstd = windowstddev(trials,.0051);
        dlmwrite(fullfile(newfolder,subjnum,'IBI_std.csv'),cellofstd)
        dlmwrite(fullfile(newfolder,subjnum,'IBI_var.csv'),cellofvar)
        figure('name','Moving variance IBI')
        subplot(5,1,1)
        plot(cellofvar{1})
        title("UP1")
        subplot(5,1,2)
        plot(cellofvar{2})
        title("UP2")
        subplot(5,1,3)
        plot(cellofvar{3})
        title("P1")
        subplot(5,1,4)
        plot(cellofvar{4})
        title("P2")
        subplot(5,1,5)
        plot(cellofvar{5})
        title("REC")
        saveas(gcf,fullfile(newfolder,[subjnum '/IBI_var.fig']));
        close;
        figure('name','Moving standard dev IBI')
        subplot(5,1,1)
        plot(cellofstd{1})
        title("UP1")
        subplot(5,1,2)
        plot(cellofstd{2})
        title("UP2")
        subplot(5,1,3)
        plot(cellofstd{3})
        title("P1")
        subplot(5,1,4)
        plot(cellofstd{4})
        title("P2")
        subplot(5,1,5)
        plot(cellofstd{5})
        title("REC")
        saveas(gcf,fullfile(newfolder,[subjnum '/IBI_std.fig']));
        close;
         figure('name','HRV from IBI')
        for t = 1:5
            % differences abs >> this is probably the main measure
            ds = diff(trials{t});
            dfs = abs(ds);
            subplot(5,1,t)
            plot(dfs)
            title(trialnames{t});
        end
            saveas(gcf, fullfile(newfolder,[subjnum '/IBI_diff.fig']));

        dlmwrite(fullfile(newfolder,[subjnum '/IBI_UP1.csv']),unpert1);
        dlmwrite(fullfile(newfolder,[subjnum '/IBI_UP2.csv']),unpert2);
        dlmwrite(fullfile(newfolder,[subjnum '/IBI_P1.csv']),pert1);
        dlmwrite(fullfile(newfolder,[subjnum '/IBI_P2.csv']),pert2);
        dlmwrite(fullfile(newfolder,[subjnum '/IBI_REC.csv']),recover);
    end
end
