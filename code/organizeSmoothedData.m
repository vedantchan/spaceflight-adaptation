% moves all the final smoothed data to one place for further analysis

trialsPath = '/Users/vedantchandra/JHM-Research/MATLAB/Summer 18 Data/Trials/'
string = ls(trialsPath);
list = strsplit(string);
subjects = list(~cellfun('isempty',list));

for subjectCount = 1%:length(subjects)
    
    parentDir = strcat(trialsPath,subjects(subjectCount),'/',subjects(subjectCount),'EmpaticaData/',subjects(subjectCount),'/')
    smoothedDir = strcat(parentDir,'smoothed/')
    targetDir = strcat(trialsPath,subjects(subjectCount),'/',subjects(subjectCount),'smoothed/')
    mkdir(targetDir{1})
    movefile(smoothedDir{1},targetDir{1})
    
end