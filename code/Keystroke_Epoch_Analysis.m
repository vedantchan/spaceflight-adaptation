%% 4/24/19; KeyStroke analysis

% 3/1/19: DONE
% 3/6/19: not done; added mistake percent
% 4/30/19 NEW

clear; close all;

current = pwd;
uiwait(msgbox("Select your SPLIT data (one subject)"))

try
%load in the data
[file, path] = uigetfile('*.txt', 'multiselect', 'on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    
cd(path)
uiwait(msgbox("Select the destination directory for keystroke data (should be 'keystroke')"))
mainfolder = uigetdir;
answer = inputdlg('Enter subject folder name, e.g. subj1','Folder Name'); 

datafolder = strcat(mainfolder,'/',answer{1});
mkdir(datafolder);

for i = 1:length(file)
    KEYS = importdata(strcat(path,file{i}));
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.S'); 

    TIMES_sec = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second; %seconds past midnight
    MINS = floor(TIMES_sec/60); %rounds down to the minute >> makes this into minutes past midnight
    start = min(MINS);
    finish = max(MINS);

    [numkeystrokespermin, binedge, binindex] = histcounts(MINS, start:finish);
    plot(numkeystrokespermin)
    
    average = mean(numkeystrokespermin); % 200 something makes sense
    
    
    
%% mistakes

    key = extractBetween(KEYS(2:end), 27, 32);
    totalmistakes = 0;
    er = ismember(key, 'Back ');
    
    % counts up total mistakes
    for j = 1:length(er)
        if er(j) == 1
            totalmistakes = totalmistakes+1;
        end
    end
    
    %new analysis (10/10); calculuates mistakes over total time
    averagemistakes = (totalmistakes/(finish-start));
    
    %mistake percent
    
    totalkeystrokes = length(KEYS(2:end));
    percentmistakes = totalmistakes/totalkeystrokes;
    
    % write into a file; this is one file per person    
    Tsingle = table(average,totalmistakes,averagemistakes,percentmistakes);
    writetable(Tsingle,strcat(datafolder, '/',file{i}(1:end-4), '_avg+mistakes+avgcor.csv')); % NEED TO SPECIFY DIRECTORY: this will be determined after the shim data is done (there is one directory per person)
    
    %dlmwrite(strcat(datafolder,'/',file{i}(1:end-4),'speed.csv'),numkeystrokespermin);
end

cd(current)