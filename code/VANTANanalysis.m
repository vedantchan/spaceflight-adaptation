%% VanTan analysis for multi, 2/28/19
% done per subject (so one run per subject)
% Fix (done): do for entire subject folder, and change to abs values. Also made compatible with mission control computer

%7/16/19: normalize to baseline data
%7/17/19: run on apollo and gemini 
% 9/10/19: added baseline consideration, run on salyut
clear; close all;

% Instructions: multi-select subject files
subjects = uipickfiles('filterspec','C:/Users/Spaceexplorers/Documents/GitHub/spaceflight-adaptation/data');

uiwait(msgbox('Select destination folder (should be vantan_[trial])'));
van = uigetdir;
%answer = inputdlg('Enter folder name, e.g. subj1','Folder Name'); 

%writepath = [van '/' answer];          % subtle thing here, answer is a variable of
%type "cell" (you can look at your workspace to see what that is);
%basically it's a different kind of object than a simple string. More
%importantly it CONTAINS the string that you're looking for (the actual
%thing that the person types). See the fix below:

%writepath = [van '/' answer{1}]; 


%mkdir ../data/van_gemini subj11 
% you can make a directory this way, but an easier/more robust way is just to use the variables you have already; writepath IS the path you need to write in, so just make writepath 

%mkdir(writepath)

for subj = 1:length(subjects)
    currentsubjdata = ls([subjects{subj} '/VAN/*.txt']);
    averagevan = [];
    averagetan = [];
    namevan = {};
    nametan = {};
    for d = 1:min(size(currentsubjdata))
        data = importdata([subjects{subj} '/VAN/' currentsubjdata(d,1:end)]);
        headers = string(data.textdata(4,:));
        %take data from anything past the first three data points
        %thestuffwecareabout = data.data(3:end,3);
        
        % ********for the future, including baseline reference file
            if contains(currentsubjdata(d,1:end),'baseline')
                baseline = mean(abs(data.data(3:end,3)));
            end
            if contains(currentsubjdata(d,1:end),'week3')
              averagevan = [averagevan; mean(abs(data.data(3:end,3)))-baseline];
               namevan = [namevan; currentsubjdata(d,1:end)];
            
%         if contains(currentsubjdata(d,1:end),'VAN')       
%             averagevan = [averagevan; mean(abs(data.data(3:end,3)))];
%             namevan = [namevan; currentsubjdata(d,1:end)];
% 
%         else if contains(currentsubjdata(d,1:end),'TAN')
%             % if contains(currentsubjdata(d,1:end),'baseline')
%             % averagevan = [mean(abs(data.data(3:end,3)))];
%             % end
%             averagetan = [averagetan; mean(abs(data.data(3:end,4)))];
%             nametan = [nametan; currentsubjdata(d,1:end)];
            end
    end
    
    %"normalize" by subtracting an average baseline; eventually use code
    %above and cancel this out
    baseline = mean(averagevan(1:2));
    averagevan = averagevan-baseline;
    
    Tvan = table(namevan,averagevan);
    %Ttan = table(nametan,averagetan);
    mkdir(strcat(van, '/', currentsubjdata(d,1:6)))
    %mkdir(strcat(tan, '/', currentsubjdata(d,1:6)))
    %writetable(Ttan,strcat(writepath,'/Average Torsional Alignments.csv'));
    writetable(Tvan,strcat(van, '/', currentsubjdata(d,1:6),'/Average Vertical Alignments.csv'));
    end
