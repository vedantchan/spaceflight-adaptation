%% Trial Splitting Keystroke

%DONE

clear ; close all;

try
%load in the data
[file, path] = uigetfile('*.txt', 'Multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end
file = {file}
%% Keys splitting
d = 'Keys_split/';
mkdir('Keys_split');
if contains(path,'s')
    for i = 1:length(file)
        data = importdata(strcat(path,file{i}));
        lendata = length(data); 
        split_ind = uint64(round(lendata/14))*3;
           
        unpert1 = data(1:split_ind,:);
        unpert2= data(split_ind:split_ind*2,:);
        pert1 = data(split_ind*2:split_ind*3,:);
        pert2 = data(split_ind*3:split_ind*4,:);
        recover = data(split_ind*4:end,:);
        
        UP1 = table(unpert1);
        UP2 = table(unpert2);
        P1 = table(pert1);
        P2 = table(pert2);
        Rec = table(recover);
        
        writetable(UP1,strcat(d,file{i}(1:end-4),'_keysplit_UP1.txt')); %end-4 gets rid of the .txt
        writetable(UP2,strcat(d,file{i}(1:end-4),'_keysplit_UP2.txt'));
        writetable(P1,strcat(d,file{i}(1:end-4),'_keysplit_P1.txt'));
        writetable(P2,strcat(d,file{i}(1:end-4),'_keysplit_P2.txt'));
        writetable(Rec,strcat(d,file{i}(1:end-4),'_keysplit_REC.txt'));
        
       
    end
end
