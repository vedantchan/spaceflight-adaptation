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

subj23folder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/Splitdata/subj23';
%subj23folder =     'C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data\keystroke\Splitdata\subj23';
st = importdata('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/switchtimes.csv');
switchtimes = rmmissing(st.data);

cd(subj23folder)
list=ls('*.txt');
list= strsplit(list);
%list = ls('*.txt');

% temporary fix
subj23col = switchtimes(:,13);


for i = 1:1
    
    KEYS = importdata(list{i});
    %KEYS = importdata(list(i,:));
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.SSS'); 

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
    
    intervals = diff(TIMES_sec);
    figure
    plot(TIMES_sec(2:end), intervals)
    title('Time intervals between keystrokes')
    %xlim([5.07E4 5.27E4])
    
    %% parsing out activity
    
    ind = find(intervals > min(subj23col));
    cleanedintervals = intervals;
    cleanedintervals(ind) = [];
    
    figure
    plot(cleanedintervals)
    title('Key Intervals Cleaned');
    

    %% hold times? DO LATER
    
    % do per second
    keys = extractBetween(KEYS(2:end), 27, end);
    for holdcount = 1:length(keys)
    end
        
        % - subtract time between DOWN/UP for the SAME character
        % - if two characters in a row down, find the earliest time it comes
        % back UP (
        % - if more than two characters are the same and are both hold (i.e.
        % hold DOWN for a long time), then find when the next time it is that that
        % character comes UP
  
end

cd(current)