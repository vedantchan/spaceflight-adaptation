%% 6/10/19 Calculates WPM
% takes in one text file (split data)
% https://www.speedtypingonline.com/typing-equations 
% avg person types ~30-40 wpm (look up)

%6/11/19: penalty for shifts, need to fix

function [wpm,wpm_corrected,accuracy,totalwords] = keystrokeWPM(subjdatafile,subjnum,switchtimesheet)
    
    KEYS = importdata(subjdatafile);
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.SSS'); 
    TIMES_sec2 = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second;

    switchtimes = rmmissing(switchtimesheet.data); %gets rid of NANs
    subjcol = switchtimes(:,find(contains(switchtimesheet.textdata,['Subj' subjnum])));
    
    intervals2 = diff(TIMES_sec2);
    ind2 = find(intervals2 > min(subjcol)); %weird number for UP
    cleanedintervals2 = intervals2;
    cleanedintervals2(ind2) = [];

    totalmins2 = sum(cleanedintervals2)/60; %missing some... probably from accidentally deleting when stopped typing >> should check for "done" somehow..

    %% wpm, no corrections
    % order matters!!
    
    % no backspace, no shift, no enter,  things that don't make a mark?
    wpmnewkeys = KEYS;
    shiftkeys = find(contains(wpmnewkeys,'RShiftKey�') | contains(wpmnewkeys,'LShiftKey�'));
    wpmnewkeys(shiftkeys) = [];
    backkeys = find(contains(wpmnewkeys,'Back�'));
    wpmnewkeys(backkeys) = [];   
    arrowkeys = find(contains(wpmnewkeys,'Right�') | contains(wpmnewkeys,'Down�') | contains(wpmnewkeys,'Up�')| contains(wpmnewkeys,'Left�'));
    wpmnewkeys(arrowkeys) = [];
    wrongkey1 = find(contains(wpmnewkeys,'Escape�') | contains(wpmnewkeys,'VolumeMute�') | contains(wpmnewkeys,'VolumeDown�') | contains(wpmnewkeys,'VolumeUp�') | contains(wpmnewkeys,'F5�') | contains(wpmnewkeys,'LWin�') | contains(wpmnewkeys,'PrintScreen�') | contains(wpmnewkeys,'Insert�') | contains(wpmnewkeys,'Delete�') | contains(wpmnewkeys,'MediaPlayPause�') | contains(wpmnewkeys,'MediaPreviousTrack�') | contains(wpmnewkeys,'MediaNextTrack�') | contains(wpmnewkeys,'NumLock�') | contains(wpmnewkeys,'LMenu�') | contains(wpmnewkeys,'LControlKey�') | contains(wpmnewkeys,'RControlKey�') | contains(wpmnewkeys,'RMenu�')  | contains(wpmnewkeys,'Home�') | contains(wpmnewkeys,'Clear�') | contains(wpmnewkeys,'End�') | contains(wpmnewkeys,'Next�')  | contains(wpmnewkeys,'None�'));
    wpmnewkeys(wrongkey1) = [];
    % need to check^ 
    totalkeys = length(wpmnewkeys); % this has the notwpmkeys removed and arrow keys removed ONLY
    
    wpm = (totalkeys/10)/totalmins2; % maybe useful because shows activity on keyboard, irregardless of correct or wrong words
    
    %% wpm, corrections
    
    % things that count as errors:
    % - backspace > backkey
    % - any wrong key > wrong key 
            % (this may penalize them twice if they've
            % already corrected for it by backspacing. just have to keep this in
            % mind; it is ok because more people have wrong characters more than
            % correct i think. can check this with word maybe.)
    % - arrow keys that are not followed by backspaces > wrongarrow
            % we count arrow keys as a mistake, but only the first instance that it
            % comes up (b/c consecutive arrow keys isn't technically a
            % mistake) && if backspace comes after arrow, then that mistake
            % has already been accounted for
            
     % penalization: for wrong characters
     % i could penalize only for uncorrected errors (but no way to tell bc
     % no backspace), so makes sense to penalize for backspace AND wrong
     % chars. but that is a lot of penalization. hm.

     wpmcnewkeys = KEYS;
     shiftkeys = find(contains(wpmcnewkeys,'RShiftKey�') | contains(wpmcnewkeys,'LShiftKey�'));
     wpmcnewkeys(shiftkeys) = [];
     backkeys = find(contains(wpmcnewkeys,'Back�'));
     wpmcnewkeys(backkeys) = [];
     arrowkeys = find(contains(wpmcnewkeys,'Right�') | contains(wpmcnewkeys,'Down�') | contains(wpmcnewkeys,'Up�')| contains(wpmcnewkeys,'Left�'));
     wpmcnewkeys(arrowkeys) = [];
     wrongkey2 = find(contains(wpmcnewkeys,'Oemtilde�') | contains(wpmcnewkeys,'Oemplus�') | contains(wpmcnewkeys,'Escape�') | contains(wpmcnewkeys,'VolumeMute�') | contains(wpmcnewkeys,'VolumeDown�') | contains(wpmcnewkeys,'VolumeUp�') | contains(wpmcnewkeys,'F5�') | contains(wpmcnewkeys,'LWin�') | contains(wpmcnewkeys,'PrintScreen�') | contains(wpmcnewkeys,'Insert�') | contains(wpmcnewkeys,'Delete�') | contains(wpmcnewkeys,'MediaPlayPause�') | contains(wpmcnewkeys,'MediaPreviousTrack�') | contains(wpmcnewkeys,'MediaNextTrack�') | contains(wpmcnewkeys,'NumLock�') | contains(wpmcnewkeys,'Oem5�') | contains(wpmcnewkeys,'LMenu�') | contains(wpmcnewkeys,'LControlKey�') | contains(wpmcnewkeys,'RControlKey�') | contains(wpmcnewkeys,'RMenu�') | contains(wpmcnewkeys,'Divide�') | contains(wpmcnewkeys,'Multiply�') | contains(wpmcnewkeys,'Subtract�') | contains(wpmcnewkeys,'Home�') | contains(wpmcnewkeys,'Add�') | contains(wpmcnewkeys,'Clear�') | contains(wpmcnewkeys,'End�') | contains(wpmcnewkeys,'Next�')  | contains(wpmcnewkeys,'None�'));
     wpmcnewkeys(wrongkey2) = []; % penalizes for uncorrected mistakes
    wrongarrow = [];
    if length(arrowkeys) > 3
        for numarrow = 1:length(arrowkeys)-1
            if arrowkeys(numarrow+1) ~= arrowkeys(numarrow)+1 && (contains(wpmcnewkeys(arrowkeys(numarrow)+1),'Back�') == 0)
                wrongarrow = [wrongarrow arrowkeys(numarrow)];
            end
        end
    else
        wrongarrow = arrowkeys;
    end
    %cleaning out all bad keys
    
    totalkeyscorr = length(wpmcnewkeys);
    
    %penalized for backspace or arrow (penalization is like a weight)
    wpm_corrected = ((totalkeyscorr/5) - length(backkeys) - length(wrongarrow))/(2*totalmins2); % everything wrong but all arrow keys
    
    % accuracy > not accurate for some reason, har har
    
    accuracy = ((totalkeyscorr)/(length(KEYS)))*100; %  *******penalty for shifts, need to fix
    
    % total words, corrected
    %wpmcnewkeys(shiftkeys) = [];
    totalwords = totalkeyscorr/5;
    return 
end
    
    

    