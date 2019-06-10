%% 6/10/19 Continuous keystroke measures
% Calculates:
% - key intervals (time between key strokes)
% - %phase comparison (w/ parsed out assignment time)

% Works on split data <<<< need to be a little careful about this

% 6/9/19: working on it again 
% ideas:
% - adding/revising key interval (continuous time b/w key strokes)
% - comparing avg time between key strokes in unperturbed to avg time b/w key strokes in perturbed (or b/w epochs) 
% >> need to parse out assignment times
% hold time for keys or flight time ( specifically Flight time is the time
% duration in between releasing a key and pressing the next key)
% ultimate: words per minute

clear; close all;

%subj23folder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/Splitdata/subj23';
subj23folder =     'C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data\keystroke\Splitdata\subj23';
cd(subj23folder)
% list=ls('*.txt');
% list= strsplit(list);
list = ls('*.txt');


for i = 1:length(list)
    
   
    %KEYS = importdata(list{i});
    KEYS = importdata(list(i,:));
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.S'); 

    TIMES_sec = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second; %seconds past midnight: ex 14:06:79 >> just seconds
    MINS = floor(TIMES_sec/60); %rounds down to the minute >> makes this into minutes past midnight
    start = min(MINS);
    finish = max(MINS);

    %% key speed
    
    [numkeystrokespermin, binedge, binindex] = histcounts(MINS, start:finish);
    figure
    plot(numkeystrokespermin)
    title('Number of keystroke per min')
    
    %interpspeed = 
        
    %% intervals
    
    intervals = diff(TIMES_sec); % problem: idk why it's not exact, something to do with float/double imprecision
    figure
    plot(TIMES_sec(2:end), intervals)
    title('Time intervals between keystrokes')
    %xlim([5.07E4 5.27E4])

    %% hold times? DO LATER
    
    % do per second
    keys = extractBetween(KEYS(2:end), 27, end);
    for hold = 1:length(keys)
        
    end
    
    
    %% parsing out assignment times
    
    % alarm times: 6, 15, 3; 5, 17, 4 
    % break times: 25, 55, 
    % bottom line: if greater than 15 seconds, ignore??
    

    %% OLD STUFF
% mistakes

    backkey = extractBetween(KEYS(2:end), 27, 32);
    totalmistakes = 0;
    er = ismember(backkey, 'Back ');
    
    % counts up total mistakes
    for j = 1:length(er)
        if er(j) == 1
            totalmistakes = totalmistakes+1;
        end
    end
    
    %new analysis (10/10); calculuates mistakes over total time
    averagemistakes = (totalmistakes/(finish-start));
    
    % find the indicies that correspond to the changing minutes
    indicies = zeros(1,length(binedge)-1);
    indexcount = 1;
    for ind = 1:length(MINS)-1
        if MINS(ind) ~= MINS(ind+1)
            indicies(indexcount) = ind;
            indexcount = indexcount+1;
        end
    end
    
    %% calculates avg mistake per min + mistake/key press freq
    datacount = 1;
    mistakepermin = zeros(1,length(binedge)-1);
    mistakepercent = zeros(1,length(binedge)-1); %wat is this
    for n = 1:length(indicies)
            while datacount <= indicies(n)
                if er(datacount) == 1
                    mistakepermin(n) = mistakepermin(n)+1;
                end
                datacount = datacount+1;
            end
            mistakepercent(n) = mistakepermin(n)./numkeystrokespermin(n);
    end
       
    %mistake percent overall
    
    
    % write into a file; this is one file per person    
    Tsingle = table(average,totalmistakes,averagemistakes);
    writetable(Tsingle,strcat(datafolder, '/',file{i}(1:end-4), '_avg+mistakes+avgcor.csv')); % NEED TO SPECIFY DIRECTORY: this will be determined after the shim data is done (there is one directory per person)
    
    Tmulti = table(numkeystrokespermin,mistakepercent,mistakepermin);
    writetable(Tmulti,strcat(datafolder,'/',file{i}(1:end-4),'numkeystroke+mistakefreq+mistakepermin.csv'));
    
    %dlmwrite(strcat(datafolder,'/',file{i}(1:end-4),'speed.csv'),numkeystrokespermin);

%% plots
    % would it be easier to put all plots together?
    % no, we want to compare b/w subjects 
    
    % plot number of keystrokes per min
    plot(histcounts(MINS, start:finish), 'color', 'red', 'linewidth', 1)
    title('Keystrokes per Minute')
    saveas(gcf, strcat(datafolder,'/',file{i}(1:end-4), '_speed.fig')); %already specifies the round type
    
    %plot time between keystroke
    

    %plot mistakes
    plot(TIMES_sec,er)
    title('Number of mistakes per time')
    saveas(gcf, strcat(datafolder,'/',file{i}(1:end-4), '_mistake.fig')); %already specifies the round type

    %plot avg mistakes per min
    plot(1:length(indicies),mistakepermin);
    title('Average mistakes per minute')
    saveas(gcf, strcat(datafolder,'/',file{i}(1:end-4), '_mistakerate.fig')); %already specifies the round type
    
    %plot mistakes over typing frequency
    plot(1:length(indicies),mistakepercent);
    title('Mistake Percentage per minute');
    saveas(gcf, strcat(datafolder,'/',file{i}(1:end-4), '_mistakepercent.fig')); 

end

cd(current)