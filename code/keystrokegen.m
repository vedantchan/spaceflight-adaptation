%% 6/10/19: Keystroke gen analysis, multifunction
 % function takes in a textfile, the subject number, and specified switch time sheet (the
    % file itself)
% 6/11/19: WORKS; need to implement epoch data
    
function [keypermin, cleanedintervals, keyhold] = keystrokegen(subjdatafile, subjnum, switchtimesheet)
   
    
    % subj23folder = '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/Splitdata/subj23';
    % subj23folder =     'C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data\keystroke\Splitdata\subj23';
    
    switchtimes = rmmissing(switchtimesheet.data); %gets rid of NANs

    %cd(subj23folder)
%     filelist=ls(fullfile(subjdatafold,'*.txt'));
%     filelist= strsplit(list);
    %list = ls('*.txt');

    subjcol = switchtimes(:,find(contains(switchtimesheet.textdata,['Subj' num2str(subjnum)])));

        KEYS = importdata(subjdatafile);
        %KEYS = importdata(list(i,:));
        EXkeys = extractBetween(KEYS(2:end), 11, 22);
        EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.SSS'); 

        TIMES_sec = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second; %seconds past midnight: ex 14:06:79 >> just seconds
        MINS = floor(TIMES_sec/60); %rounds down to the minute >> makes this into minutes past midnight
        start = min(MINS);
        finish = max(MINS);

        %% key speed

        [keypermin, binedge, binindex] = histcounts(MINS, start:finish);
    
        %% intervals

        intervals = diff(TIMES_sec);
%         figure
%         plot(TIMES_sec(2:end), intervals)
%         title('Time intervals between keystrokes')

        %% parsing out activity

        % in seconds
        ind = find(intervals > min(subjcol));
        cleanedintervals = intervals;
        cleanedintervals(ind) = [];

%         figure
%         plot(cleanedintervals)
%         title('Key Intervals Cleaned');


        %% hold times? DO LATER

        % do per second
%         keys = extractBetween(KEYS(2:end), 27, end);
%         for holdcount = 1:length(keys)
%         end

            % - subtract time between DOWN/UP for the SAME character
            % - if two characters in a row down, find the earliest time it comes
            % back UP (
            % - if more than two characters are the same and are both hold (i.e.
            % hold DOWN for a long time), then find when the next time it is that that
            % character comes UP
