%% Trial Splitting Keystroke
%DONE

clear ; close all;
origin = pwd;
uiwait(msgbox("Select your raw data"));
try
%load in the data
[file, path] = uigetfile('*.txt','multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    

if class(file) == 'char'
    file = {file};
end

uiwait(msgbox("Select the destination directory for split keystroke data. Should be keystroke/Splitdata"))
mainfolder = uigetdir;
cd(mainfolder);
answer = inputdlg('Enter subject folder name, e.g. subj1','Folder Name'); 

datafolder = strcat(mainfolder,'/',answer{1});
mkdir(datafolder);


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
        
        writetable(UP1,strcat(datafolder, '/',file{i}(1:end-4),'_keysplit_UP1.txt')); %end-4 gets rid of the .txt
        writetable(UP2,strcat(datafolder, '/',file{i}(1:end-4),'_keysplit_UP2.txt'));
        writetable(P1,strcat(datafolder, '/', file{i}(1:end-4),'_keysplit_P1.txt'));
        writetable(P2,strcat(datafolder,'/', file{i}(1:end-4),'_keysplit_P2.txt'));
        writetable(Rec,strcat(datafolder, '/', file{i}(1:end-4),'_keysplit_REC.txt'));
        
       
end

cd(origin);