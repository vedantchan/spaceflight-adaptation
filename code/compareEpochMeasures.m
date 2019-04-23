clear; close all;

%% Import Data
filename = '/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/trialdata.csv';
delimiter = ',';
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[2,3,4,5,6,7,8,9,10,11]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^[-/+]*\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end
rawNumericColumns = raw(:, [2,3,4,5,6,7,8,9,10,11]);
rawStringColumns = string(raw(:, 1));
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
idx = (rawStringColumns(:, 1) == "<undefined>");
rawStringColumns(idx, 1) = "";
trialdata = table;
trialdata.Phase = categorical(rawStringColumns(:, 1));
trialdata.Subj1 = cell2mat(rawNumericColumns(:, 1));
trialdata.Subj2 = cell2mat(rawNumericColumns(:, 2));
trialdata.Subj3 = cell2mat(rawNumericColumns(:, 3));
trialdata.Subj4 = cell2mat(rawNumericColumns(:, 4));
trialdata.Subj5 = cell2mat(rawNumericColumns(:, 5));
trialdata.Subj6 = cell2mat(rawNumericColumns(:, 6));
trialdata.Subj7 = cell2mat(rawNumericColumns(:, 7));
trialdata.Subj8 = cell2mat(rawNumericColumns(:, 8));
trialdata.Subj9 = cell2mat(rawNumericColumns(:, 9));
trialdata.Subj10 = cell2mat(rawNumericColumns(:, 10));
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstrresult numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R idx;

%% Split data by Parameter

vas = [];
van = [];
puzzle = [];
memory=[];
meanHR=[];
meanTEMP=[];
meanEDA=[];
hredaz = [];
hrtempz = [];
tempedaz = [];

for i = 1:10
   
    subjname = strcat('Subj',num2str(i));
    
    subjectvas = trialdata(3:7,subjname);
    vas = [vas,subjectvas];
    vas.Properties.Description = 'VAS';
    
    subjvan = trialdata(9:13,subjname);
    van = [van,subjvan];
    van.Properties.Description = 'VAN';
    
    subjpuzzle = trialdata(15:19,subjname);
    puzzle = [puzzle,subjpuzzle];
    puzzle.Properties.Description = 'Puzzle Task';
    
    subjmemory = trialdata(21:25,subjname);
    memory = [memory,subjmemory];
    memory.Properties.Description = 'Memory Task';
    
    subjmeanHR = trialdata(51:55,subjname);
    meanHR=[meanHR,subjmeanHR];
    meanHR.Properties.Description = 'Mean HR';
    
    subjmeanTEMP = trialdata(57:61,subjname);
    meanTEMP = [meanTEMP,subjmeanTEMP];
    meanTEMP.Properties.Description = 'Mean TEMP';
    
    subjmeanEDA = trialdata(63:67,subjname);
    meanEDA = [meanEDA,subjmeanEDA];
    meanEDA.Properties.Description = 'Mean EDA';
    
    subjHREDAz = trialdata(106:110,subjname);
    hredaz = [hredaz,subjHREDAz];
    hredaz.Properties.Description = 'HR-EDA Z-Score';
    
    subjHRTEMPz = trialdata(112:116,subjname);
    hrtempz = [hrtempz,subjHRTEMPz];
    hrtempz.Properties.Description = 'HR-TEMP Z-Score';
    
    subjTEMPEDAz = trialdata(118:122,subjname);
    tempedaz = [tempedaz,subjTEMPEDAz];
    tempedaz.Properties.Description = 'TEMP-EDA Z-Score';
    
end

% comparesubplot(hredaz,hrtempz)
% comparesubplot(hredaz,tempedaz)
% comparesubplot(tempedaz,hrtempz)
% 
% comparesubplot(hrtempz,van)
% comparesubplot(hrtempz,vas)
% comparesubplot(hrtempz,memory)
% comparesubplot(hrtempz,meanTEMP)
% comparesubplot(hrtempz,meanHR)
% comparesubplot(hrtempz,meanEDA)
% 
% comparesubplot(hredaz,van)
% comparesubplot(hredaz,vas)
% comparesubplot(hredaz,memory)
% comparesubplot(hredaz,meanTEMP)
% comparesubplot(hredaz,meanHR)
% comparesubplot(hredaz,meanEDA)
% 
% comparesubplot(tempedaz,van)
% comparesubplot(tempedaz,vas)
% comparesubplot(tempedaz,memory)
% comparesubplot(tempedaz,meanTEMP)
% comparesubplot(tempedaz,meanHR)
% comparesubplot(tempedaz,meanEDA)
% 
% comparesubplot(van,meanTEMP)
% comparesubplot(van,meanHR)
% comparesubplot(van,meanEDA)
% 
% comparesubplot(memory,meanTEMP)
% comparesubplot(memory,meanEDA)
% comparesubplot(memory,meanHR)

comparesubplot(puzzle,meanTEMP)
comparesubplot(puzzle,meanHR)
comparesubplot(puzzle,meanEDA)

comparesubplot(puzzle,hredaz)
comparesubplot(puzzle,tempedaz)
comparesubplot(puzzle,hrtempz)

function [] = comparesubplot(table1,table2)
figure('Units','normalized','Position',[0 0 .25 1])
labels={'UP1','UP2','P1','P2','REC'};
corrs = [];
for i = 1:size(table1,2)
    subplot(size(table1,2),1,i);
    subjectmeasure1 = table2array(table1(:,i));
    subjectmeasure2 = table2array(table2(:,i));
    norm1 = (subjectmeasure1 - min(subjectmeasure1)).*(1/(max(subjectmeasure1)-min(subjectmeasure1)));
    norm2 = (subjectmeasure2 - min(subjectmeasure2)).*(1/(max(subjectmeasure2)-min(subjectmeasure2)));
    plot(norm1,'b');
    hold on 
    plot(norm2,'r');
    hold off
    title(strcat('Subject-',num2str(i)));
    xticks([1 2 3 4 5]);
    xticklabels(labels);
    correlate = corrcoef(subjectmeasure1,subjectmeasure2);
    text(0.7,0.7,strcat('\rho=',num2str(correlate(1,2))),'Units','Normalized')
    corrs = [corrs correlate(1,2)];
end
sgtitle(strcat(table1.Properties.Description,'(b) vs. ',table2.Properties.Description,'(r)'))
savefig(strcat('plots/compareEpochs/',table1.Properties.Description,'_vs_',table2.Properties.Description))
csvwrite(strcat('meta/compareEpochs/corr_',table1.Properties.Description,'_vs_',table2.Properties.Description),corrs)
close all;
end

