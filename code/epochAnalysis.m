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
    
    subjvan = trialdata(9:13,subjname);
    van = [van,subjvan];
    
    subjpuzzle = trialdata(15:19,subjname);
    puzzle = [puzzle,subjpuzzle];
    
    subjmemory = trialdata(21:25,subjname);
    memory = [memory,subjmemory];
    
    subjmeanHR = trialdata(51:55,subjname);
    meanHR=[meanHR,subjmeanHR];
    
    subjmeanTEMP = trialdata(57:61,subjname);
    meanTEMP = [meanTEMP,subjmeanTEMP];
    
    subjmeanEDA = trialdata(63:67,subjname);
    meanEDA = [meanEDA,subjmeanEDA];
    
    subjHREDAz = trialdata(106:109,subjname);
    hredaz = [hredaz,subjHREDAz];
    
    subjHRTEMPz = trialdata(112:116,subjname);
    hrtempz = [hrtempz,subjHRTEMPz];
    
    subjTEMPEDAz = trialdata(118:122,subjname);
    tempedaz = [tempedaz,subjTEMPEDAz];
    
    
end
mkdir('plots/epoch/')
%% Plot avgs

% makeoverlayplot(meanHR,"Mean HR")
% savefig('plots/epoch/meanHR-overlay.fig')
% 
% makeoverlayplot(meanTEMP,"Mean TEMP")
% savefig('plots/epoch/meanTEMP-overlay.fig')
% 
% makenormplot(meanEDA,"Mean EDA")
% savefig('plots/epoch/meanEDA-normalized.fig')
% 
% 
% %% Correlate avgs
% 
% makesubjectcorrplot(meanHR,"Mean HR")
% savefig('plots/epoch/meanHR-subjcorr.fig')
% 
% makesubjectcorrplot(meanTEMP,"Mean TEMP")
% savefig('plots/epoch/meanTEMP-subjcorr.fig')
% 
% makesubjectcorrplot(meanEDA,"Mean EDA")
% savefig('plots/epoch/meanEDA-subjcorr.fig')
% 
% 
% makeepochcorrplot(meanHR,"Mean HR")
% savefig('plots/epoch/meanHR-epochcorr.fig')
% 
% makeepochcorrplot(meanTEMP,"Mean TEMP")
% savefig('plots/epoch/meanTEMP-epochcorr.fig')
% 
% makeepochcorrplot(meanEDA,"Mean EDA")
% savefig('plots/epoch/meanEDA-epochcorr.fig')
% 
% %% Make data plots
% makesubplot(van,"VAN");
% savefig('plots/epoch/VAN-subplot.fig')
% makeoverlayplot(van,"VAN");
% savefig('plots/epoch/VAN-overlay.fig')
% makenormplot(van,"VAN");
% savefig('plots/epoch/VAN-norm.fig')
% 
% makesubplot(vas,"VAS");
% savefig('plots/epoch/VAS-subplot.fig')
% makeoverlayplot(vas,"VAS");
% savefig('plots/epoch/VAS-overlay.fig')
% makenormplot(vas,"VAS");
% savefig('plots/epoch/VAS-norm.fig')
% 
% makesubplot(puzzle,"Puzzle");
% savefig('plots/epoch/Puzzle-subplot.fig')
% makeoverlayplot(puzzle,"Puzzle Solve Time");
% savefig('plots/epoch/Puzzle-overlay.fig')
% makenormplot(puzzle,"Puzzle Solve Time");
% savefig('plots/epoch/Puzzle-norm.fig')
% 
% 
% %% Make Correlation plots
% 
% makesubjectcorrplot(van,'VAN')
% savefig('plots/epoch/VAN-subjectcorr.fig')
% makeepochcorrplot(van,'VAN')
% savefig('plots/epoch/VAN-epochcorr.fig')
% 
% makesubjectcorrplot(vas,'VAS')
% savefig('plots/epoch/VAS-subjectcorr.fig')
% makeepochcorrplot(vas,'VAS')
% savefig('plots/epoch/VAS-epochcorr.fig')
% 
% makesubjectcorrplot(puzzle,'Puzzle')
% makeepochcorrplot(puzzle,'Puzzle')

%% Z Score

makesubplot(tempedaz,'Temp-EDA Z')
makesubplot(hredaz,'HR-EDA Z')
makesubplot(hrtempz,'HR-TEMP Z')

makesubjectcorrplot(tempedaz,'Temp-EDA Z')
makesubjectcorrplot(hredaz,'HR-EDA Z')
makesubjectcorrplot(hrtempz,'HR-TEMP Z')

makeepochcorrplot(tempedaz,'Temp-EDA Z')
makeepochcorrplot(hredaz,'HR-EDA Z')
makeepochcorrplot(hrtempz,'HR-TEMP Z')


%% plotting functions

function [] = makesubplot(inputtable,name)
figure('Units','normalized','Position',[0 0 .25 1])
labels={'UP1','UP2','P1','P2','REC'};
%subplots

for i = 1:10
    subplot(10,1,i);
    plot(table2array(inputtable(:,i)));
    xticks([1 2 3 4 5]);
    xticklabels(labels);
    plottitle = strcat('Subject - ',num2str(i));
    %title(plottitle);
    
end

sgtitle(name)
end

function [] = makenormplot(inputtable,name)

figure()

for i = 1:10
    
    subjectmeasure = table2array(inputtable(:,i));
    maxmeasure = max(subjectmeasure);
    minmeasure = min(subjectmeasure);
    
    normvas = (subjectmeasure - minmeasure).*(1/(maxmeasure-minmeasure));
    
    
    plot(normvas,'DisplayName',strcat('Subject-',num2str(i)));
    hold on
    
end
legend
labels={'UP1','UP2','P1','P2','REC'};
sgtitle(strcat(name,' - Normalized'))
xticks([1 2 3 4 5]);
xticklabels(labels);
ylim([-0.25 1.25])


end

function [] = makeoverlayplot(inputtable,name)
figure()

for i = 1:10
    
    subjectmeasure = table2array(inputtable(:,i));
    
    
    plot(subjectmeasure,'DisplayName',strcat('Subject-',num2str(i)));
    ylabel("Measure")
    xlabel("Epoch")
    title(strcat(name," - Overlay Plot"))
    
    hold on
    
end
legend
labels={'UP1','UP2','P1','P2','REC'};
xticks([1 2 3 4 5]);
xticklabels(labels);


end

function[] = makesubjectcorrplot(inputtable,name) 

figure()
array = table2array(inputtable);
imagesc(corrcoef(array))
cbar = colorbar;
colormap('cool')
title(strcat(name," - Inter-Subject Correlation Across Epochs"))
xlabel("Subjects")
ylabel("Subjects")
ylabel(cbar,"Correlation Coefficient")


end

function[] = makeepochcorrplot(inputtable,name)

labels={'UP1','UP2','P1','P2','REC'};

figure()
array = table2array(inputtable);
imagesc(corrcoef(array.'))
cbar = colorbar;
colormap('cool')
title(strcat(name," - Inter-Epoch Correlation Across Subjects"))
xlabel("Epoch")
ylabel("Epoch")
ylabel(cbar,"Correlation Coefficient")
xticks([1 2 3 4 5]);
xticklabels(labels);
yticks([1 2 3 4 5]);
yticklabels(labels);

end