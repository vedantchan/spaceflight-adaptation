%KeyStroke analysis
% DONE

clear; close all;

try
%load in the data
[file, path] = uigetfile('*.txt','multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    

d = 'KeyAnalysis_results/';
mkdir(d);
for i = 1:length(file)
    KEYS = importdata(strcat(path,file{i}));
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.S'); 

    TIMES_sec = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second; %seconds past midnight
    MINS = floor(TIMES_sec/60); %rounds down to the minute
    start = min(MINS);
    finish = max(MINS);

    [numkeystrokespermin, bin] = histcounts(MINS, start:finish);
    average = mean(numkeystrokespermin); %200 something makes sense

%% mistakes

    key = extractBetween(KEYS(2:end), 27, 32);

    mistakes = 0;
    er = ismember(key, 'Back ');
    for j = 1:length(er)
        if er(j) == 1
            mistakes = mistakes+1;
        end
    end
    
    %new analysis (10/10); calculuates mistakes over total time
    averagemistakes = (mistakes/(finish-start));
    
    
    % write into a file; this is one file per person
    
    f = file{i}(1:end-4);
    T = table(average,mistakes,averagemistakes);
    writetable(T,strcat(d,file{i}(1:end-4), '_avg+mistakes+avgcor.csv')); % NEED TO SPECIFY DIRECTORY: this will be determined after the shim data is done (there is one directory per person)
    % file{i} will contain: name of subject, type of data (perterbed1 or 2,
    % unperterbed 1 or 2, recovery)
    
end
