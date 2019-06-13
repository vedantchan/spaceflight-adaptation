% 6\12\19: Split for skylab (most code copied from splittrials_empa

clear all; close;

current = pwd;
rawfold = uipickfiles('filterspec','C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data');
subj = 'subj1969';
subjfold = fullfile(rawfold{1},subj);
% files = ls(fullfile(rawfold{1},subjfold));
% files = strsplit(files);
files = (ls([subjfold '\' '*.zip']));

% zip out into the same subject folder, and put the split stuff into a separate folder, which is still inside subject folder

 for filecount = 1:3
     
     outPath = [subjfold '\' 'EmpaticaData\' files(filecount,1:end-4) '\'];
     zipPath = [subjfold '\' files(filecount,1:end)];
    
     unzip(zipPath,outPath);
    
    dfile = dir(fullfile(outPath,'*.csv'));            
    %for mac maybe
    %     fstring = ls([outPath '\*.csv']);
    %flist = strsplit(fstring);
    %prefile = flist;
%     dfile={};
%     for i = 1:length(prefile)
%         if isequal(prefile(i),'ACC.csv')
%            %dfile{1}=prefile{i};
%            dfile{1}=fstring(i,1:end);
%          elseif isequal(prefile(i),'BVP.csv')
%             %dfile{2}=prefile{j};
%             dfile{2}=fstring(i,1:end);
%          elseif isequal(prefile(i),'EDA.csv')
%             %dfile{3}=prefile{j};
%             dfile{3}=fstring(i,1:end);
%          elseif isequal(prefile(i),'HR.csv')
%             %dfile{4}=prefile{j};
%             dfile{4}=fstring(i,1:end);
%           elseif isequal(prefile(i),'TEMP.csv')
%             %dfile{5}=prefile{j};
%             dfile{5}=fstring(i,1:end);
%         end
%      end
    
    subjectSplit = [subjfold  '\' 'E4Clean' '\' files(filecount,1:end-4)];
    mkdir(subjectSplit)
    
    %% Empatica split
         for j = 1:length(dfile)
            header = 2; % this means start at line 2
            delim = ',';
            data = importdata(strcat(outPath,dfile(j).name),delim,header);
            lendata = length(data.data);
            
            if contains(dfile(j).name,'HR')
                resmpdata = data.data;
            elseif contains(dfile(j).name,'TEMP')
                resmpdata = resample(data.data,1,4);
            elseif contains(dfile(j).name,'EDA')
                resmpdata = resample(data.data,1,4);
            elseif contains(dfile(j).name,'BVP')
                resmpdata = resample(data.data,1,4);
            elseif contains(dfile(j).name,'ACC')
                resmpdata = resample(data.data,1,32);
            end
                       
             %% split
             % the data is split into 1 hr of running\gym activity, 1 hr
             % showering\other activity (basically 0 activity), then the
             % rest is split into even 3 sections, where the first
             % section roughly contains some kind of travelling activity,
             % and the other two should be regular office activity.
             
             splitind = uint64(round(length(resmpdata(7200:end,:)))/3);
             
             
             unpert1 = resmpdata(1:4100,:);
             plot(unpert1)
             title([files(filecount,1:end-4) '_' dfile(j).name '_UP1'])
             saveas(gcf,strcat(subjectSplit, '\',dfile(j).name,'_','E4_UP1','.fig'));
             unpert2= resmpdata(4100:7200,:);
             plot(unpert2)
             title([files(filecount,1:end-4) '_' dfile(j).name '_UP2'])
             saveas(gcf,strcat(subjectSplit, '\',dfile(j).name,'_','E4_UP2','.fig'));
             pert1 = resmpdata(7200:7500+splitind,:);
             plot(pert1)
             title([files(filecount,1:end-4) '_' dfile(j).name '_P1'])
             saveas(gcf,strcat(subjectSplit, '\',dfile(j).name,'_','E4_P1','.fig'));
             pert2 = resmpdata(7200+splitind:7200+splitind*2,:);
             plot(pert2)
             title([files(filecount,1:end-4) '_' dfile(j).name '_P2'])
             saveas(gcf,strcat(subjectSplit, '\',dfile(j).name,'_','E4_P2','.fig'));
             recover = resmpdata(7200+splitind*2:end,:);
             plot(recover)
             title([files(filecount,1:end-4) '_' dfile(j).name '_Rec'])
             saveas(gcf,strcat(subjectSplit, '\',dfile(j).name,'_','E4_Rec','.fig'));
             
            dlmwrite(strcat(subjectSplit, '\',dfile(j).name,'_','E4_UP1','.csv'), unpert1,',');
            dlmwrite(strcat(subjectSplit, '\',dfile(j).name,'_','E4_UP2','.csv'), unpert2,',');
            dlmwrite(strcat(subjectSplit,'\',dfile(j).name,'_','E4_P1','.csv'), pert1,',');
            dlmwrite(strcat(subjectSplit,'\',dfile(j).name,'_','E4_P2','.csv'), pert2,',');
            dlmwrite(strcat(subjectSplit,'\',dfile(j).name,'_','E4_Rec','.csv'), recover,',');
            
         end
end

cd(current);

