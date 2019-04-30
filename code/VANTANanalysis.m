%% VanTan analysis, 2/28/19
% done per subject (so one run per subject)

clear; close all;

try
%load in the data
[file, path] = uigetfile('*.txt','multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    

uiwait(msgbox('Select destination folder (should be vantan_[trial])'));
vantan = uigetdir;
answer = inputdlg('Enter folder name, e.g. subj1','Folder Name'); 
writepath = [vantan '/' answer];
mkdir(writepath)



averagevan = [];
averagetan = [];
namevan = {};
nametan = {};
for i = 1:length(file)
    data = importdata(strcat(path,file{i}));
    headers = string(data.textdata(4,:));
    %take data from anything past the two data points
    %thestuffwecareabout = data.data(3:end,3);
    if contains(file{i},'VAN')
        averagevan = [averagevan; mean(data.data(3:end,3))];
        namevan = [namevan; file{i}];
        
    else if contains(file{i},'TAN')
        averagetan = [averagetan; mean(data.data(3:end,4))];
        nametan = [nametan; file{i}];
        end
    end
end

Tvan = table(namevan,averagevan);
%Ttan = table(nametan,averagetan);


%writetable(Ttan,strcat(writepath,'/Average Torsional Alignments.csv'));
writetable(Tvan,strcat(writepath,'/Average Vertical Alignments.csv'));
