% moves all the final smoothed data to one place for further analysis

clear all; close;
origin = pwd;

uiwait(msgbox('Select your raw folder'))
trialsPath = uigetdir; %SELECT 'raw' HERE
trialsPath = strcat(trialsPath,'/');

cd(trialsPath)
string = ls; 
list = strsplit(string);
subjects = list(~cellfun('isempty',list));

for i = 1:length(subjects)
    name = subjects{i};
    srcPath = strcat(trialsPath,name,'/','EmpaticaSplit/','smoothed/')
    filestxt = dir(fullfile(srcPath,'*.csv'));
    filesimg = dir(fullfile(srcPath,'*.fig'));
    targetPath = strcat(trialsPath(1:end-4),'smoothed/',name,'/')
    for j = 1:length(filestxt)
        movefile([filestxt(j).folder '/' filestxt(j).name],targetPath)
        movefile([filesimg(j).folder '/' filesimg(j).name],targetPath)
    end
end

cd(origin);