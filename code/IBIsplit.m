% 9/18/19: splitting IBI
%eventually should integrate this into splittrials_Empa
% right now doing it assuming the empatica folder has already been unzipped

clear all;
close;

uiwait(msgbox('Select your raw folder'))
trialsPath = uigetdir; % SELECT THE FOLDER 'raw' OVER HERE
cd(trialsPath);
string = ls;
lst = strsplit(string);
subjects = lst(~cellfun('isempty',lst));
subjects = sort(subjects);

%newfolder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/IBIsplit'; %or something
for subjcount = 1:length(subjects)
    if ~contains(subjects{subjcount}, 'subj25_missinge4')
        %skylab:
        %data = importdata(fullfile(subjfold{1},subjnum,'IBI.csv'),',',1);
        %other:
        IBIfile = [trialsPath '/' subjects{subjcount} '/' subjects{subjcount} 'EmpaticaData' '/' 'IBI.csv'];
        data = importdata(IBIfile,',',1);
        
        if isempty(find(data.data(1:end,1) >7680)) == 1
            split_indp = uint64(round(length(data.data)*.209));
            unpert1 = data.data(1:(split_indp),:);
            unpert2= data.data((split_indp):(split_indp)*2,:);
            pert1 = data.data((split_indp)*2:(split_indp)*3,:);
            pert2 = data.data((split_indp)*3:(split_indp)*4,:);
            recover = data.data((split_indp)*4:end,:);
            store = [trialsPath '/' subjects{subjcount} '/' 'EmpaticaSplit'];
            dlmwrite(fullfile(store, 'IBI_UP1.csv'),unpert1);
            dlmwrite(fullfile(store, 'IBI_UP2.csv'),unpert2);
            dlmwrite(fullfile(store, 'IBI_P1.csv'),pert1);
            dlmwrite(fullfile(store, 'IBI_P2.csv'),pert2);
            dlmwrite(fullfile(store, 'IBI_Rec.csv'),recover);
        else
            %split: for regular runs
            split1 = find(data.data(1:end,1) > 1920);
            split2 = find(data.data(1:end,1) > 3840);
            split3 = find(data.data(1:end,1) > 5760);
            split4 = find(data.data(1:end,1) > 7680);

            unpert1 = data.data(1:(split1(1)),:);
            unpert2= data.data(split1(1):split2(1),:);
            pert1 = data.data(split2(1):split3(1),:);
            pert2 = data.data(split3(1):split4(1),:);
            recover = data.data(split4(1):end,:);

            store = [trialsPath '/' subjects{subjcount} '/' 'EmpaticaSplit'];
            dlmwrite(fullfile(store, 'IBI_UP1.csv'),unpert1);
            dlmwrite(fullfile(store, 'IBI_UP2.csv'),unpert2);
            dlmwrite(fullfile(store, 'IBI_P1.csv'),pert1);
            dlmwrite(fullfile(store, 'IBI_P2.csv'),pert2);
            dlmwrite(fullfile(store, 'IBI_Rec.csv'),recover);
        end
    end
end
