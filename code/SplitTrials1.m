%% Trial Split: 5 outputs
% DONE
%MAKE SURE YOU CHANGE THE SUBJECT NUMBER

current = pwd;
trialsPath = uigetdir; % SELECT THE FOLDER 'raw' OVER HERE
x=trialsPath;
cd(trialsPath);
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));


%shimmer has one col of data, so no dot indexing

for subjectCount = 1:length(subjects)
    %load in the data
    %[file, path] = uigetfile('*.csv');
    %[file, path] = uigetfile('*.csv', 'Multiselect','on');
    
    
    subjectPath = [trialsPath subjects{subjectCount} '/'];
    outPath = [trialsPath, '/', subjects{subjectCount} '/' subjects{subjectCount} 'EmpaticaData/'];
    zipPath = [trialsPath, '/', subjects{subjectCount} '/' subjects{subjectCount} 'EmpaticaData.zip'];
    
    unzip(zipPath,outPath);
    
    string = ls(outPath);
    list = strsplit(string);
    prefile = list;
    file={};
    for i = 1:length(prefile)
        if isequal(prefile{i},'ACC.csv')
            file{1}=prefile{i};
        elseif isequal(prefile{i},'BVP.csv')
            file{2}=prefile{i};
        elseif isequal(prefile{i},'EDA.csv')
            file{3}=prefile{i};
        elseif isequal(prefile{i},'HR.csv')
            file{4}=prefile{i};
        elseif isequal(prefile{i},'TEMP.csv')
            file{5}=prefile{i};
        end
    end
    
    path = outPath
    cd(path)
    mkdir(subjects{subjectCount})
    %file =
    
    %     if contains(path,'Empatica')
    %        for i = 1:length(file)
    %         header = 1;
    %         delim = ',';
    %         data = importdata(strcat(path,file{i}),delim,header);
    %         lendata = length(data.data);
    %
    %         split_ind = uint64(round(lendata/14))*3;
    %
    %         %split
    %         unpert1 = data.data(1:split_ind,:);
    %         plot(unpert1)
    %         saveas(gcf,strcat(subjects{subjectCount}, '/',file{i},'_','E4_UP1','.fig'));
    %         unpert2= data.data(split_ind:split_ind*2,:);
    %         plot(unpert2)
    %         saveas(gcf,strcat(subjects{subjectCount}, '/',file{i},'_','E4_UP2','.fig'));
    %         pert1 = data.data(split_ind*2:split_ind*3,:);
    %         plot(pert1)
    %         saveas(gcf,strcat(subjects{subjectCount}, '/',file{i},'_','E4_P1','.fig'));
    %         pert2 = data.data(split_ind*3:split_ind*4,:);
    %         plot(pert2)
    %         saveas(gcf,strcat(subjects{subjectCount}, '/',file{i},'_','E4_P2','.fig'));
    %         recover = data.data(split_ind*4:end,:);
    %         plot(recover)
    %         saveas(gcf,strcat(subjects{subjectCount}, '/',file{i},'_','E4_Rec','.fig'));
    %
    %
    %
    %         dlmwrite(strcat(subjects{subjectCount}, '/',file{i},'_','E4_UP1','.csv'), unpert1,',');  % manually change where you write to
    %         dlmwrite(strcat(subjects{subjectCount}, '/',file{i},'_','E4_UP2','.csv'), unpert2,',');
    %         dlmwrite(strcat(subjects{subjectCount},'/',file{i},'_','E4_P1','.csv'), pert1,',');
    %         dlmwrite(strcat(subjects{subjectCount},'/',file{i},'_','E4_P2','.csv'), pert2,',');
    %         dlmwrite(strcat(subjects{subjectCount},'/',file{i},'_','E4_Rec','.csv'), recover,',');
    %
    %         end
    %     end
    
    cd ..
    cd Shim
    
    string = ls;
    list = strsplit(string);
    prefile = list;
    file=prefile(~cellfun('isempty',prefile));
    path = pwd;
    if contains(path,'Shim')
        for i = 1:length(file)
            if contains(file{i},'HEAD')
                %if contains(file,'HEAD')
                
                data = importdata(strcat(path,'/',file{i}));
                % data = importdata(strcat(path,file));
                
                lendata = length(data);
                
                split_ind = uint64(round(lendata/14))*3;
                
                %split into perturbed and unperturbed
                unpert1 = data(1:split_ind,:);
                plot(unpert1)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimHEAD_UP1','.fig'));
                unpert2= data(split_ind:split_ind*2,:);
                plot(unpert2)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimHEAD_UP2','.fig'));
                pert1 = data(split_ind*2:split_ind*3,:);
                plot(pert1)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimHEAD_P1','.fig'));
                pert2 = data(split_ind*3:split_ind*4,:);
                plot(pert2)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimHEAD_P2','.fig'));
                recover = data(split_ind*4:end,:);
                plot(recover)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimHEAD_Rec','.fig'));
                
                dlmwrite(strcat(subjects{subjectCount}, '/','ShimHEAD_UP1','.csv'), unpert1,',');  % manually change where you write to
                dlmwrite(strcat(subjects{subjectCount}, '/','ShimHEAD_UP2','.csv'), unpert2,',');
                dlmwrite(strcat(subjects{subjectCount},'/','ShimHEAD_P1','.csv'), pert1,',');
                dlmwrite(strcat(subjects{subjectCount},'/','ShimHEAD_P2','.csv'), pert2,',');
                dlmwrite(strcat(subjects{subjectCount},'/','ShimHEAD_Rec','.csv'), recover,',');
            elseif contains(file{i},'Body')
                %elseif contains(file,'BODY')
                
                data = importdata(strcat(path,'/',file{i}));
                %data = importdata(strcat(path,file));
                data=data.data;
                lendata = length(data);
                
                split_ind = uint64(round(lendata/14))*3;
                
                %split into perturbed and unperturbed
                unpert1 = data(1:split_ind,:);
                plot(unpert1)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimBODY_UP1','.fig'));
                unpert2= data(split_ind:split_ind*2,:);
                plot(unpert2)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimBODY_UP2','.fig'));
                pert1 = data(split_ind*2:split_ind*3,:);
                plot(pert1)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimBODY_P1','.fig'));
                pert2 = data(split_ind*3:split_ind*4,:);
                plot(pert2)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimBODY_P2','.fig'));
                recover = data(split_ind*4:end,:);
                plot(recover)
                saveas(gcf,strcat(subjects{subjectCount}, '/','ShimBODY_Rec','.fig'));
                
                
                dlmwrite(strcat(subjects{subjectCount}, '/','ShimBODY_UP1','.csv'), unpert1,',');  % manually change where you write to
                dlmwrite(strcat(subjects{subjectCount}, '/','ShimBODY_UP2','.csv'), unpert2,',');
                dlmwrite(strcat(subjects{subjectCount},'/','ShimBODY_P1','.csv'), pert1,',');
                dlmwrite(strcat(subjects{subjectCount},'/','ShimBODY_P2','.csv'), pert2,',');
                dlmwrite(strcat(subjects{subjectCount},'/','ShimBODY_Rec','.csv'), recover,',');
            end
        end
    end
end
% Keys split
if contains(path,'Key')
    d = 'Keys_split/';
    mkdir('Keys_split');
    for i = 1:length(file)
        data = importdata(strcat(path,file{i},'.txt'));
        lendata = length(data);
        split_ind = uint64(round(lendata/14))*3;
        
        conv = string(data);
        
        unpert1 = data.data(1:split_ind,:);
        unpert2= data.data(split_ind:split_ind*2,:);
        pert1 = data.data(split_ind*2:split_ind*3,:);
        pert2 = data.data(split_ind*3:split_ind*4,:);
        recover = data.data(split_ind*4:end,:);
        
        dlmwrite(strcat(d,file{i},'_keysplit_UP1.txt'),unpert1);
        dlmwrite(strcat(d, file{i},'_keysplit_UP2.txt'),unpert2);
        dlmwrite(strcat(d, file{i},'_keysplit_P2.txt'),pert1);
        dlmwrite(strcat(d, file{i},'_keysplit_P2.txt'),pert2);
        dlmwrite(strcat(d, file{i},'_keysplit_Rec.txt'),recover);
        
    end
end

cd(current);