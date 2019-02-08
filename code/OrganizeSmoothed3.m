% moves all the final smoothed data to one place for further analysis

origin = pwd;

trialsPath = uigetdir; %SELECT 'data' HERE
trialsPath = strcat(trialsPath,'/');

cd(strcat(trialsPath,'raw/'))
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));

for i = 1:length(subjects)
    name = subjects{i};
    srcPath = strcat(trialsPath,'raw/',name,'/',name,'EmpaticaData/',name,'/smoothed/')
    targetPath = strcat(trialsPath,'smoothed/',name,'/')

    movefile(srcPath,targetPath)
end

cd(origin);