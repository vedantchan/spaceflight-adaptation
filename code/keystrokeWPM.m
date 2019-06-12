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
    shiftkeys = find(contains(wpmnewkeys,'RShiftKeyÂ') | contains(wpmnewkeys,'LShiftKeyÂ'));
    wpmnewkeys(shiftkeys) = [];
    backkeys = find(contains(wpmnewkeys,'BackÂ'));
    wpmnewkeys(backkeys) = [];   
    arrowkeys = find(contains(wpmnewkeys,'RightÂ') | contains(wpmnewkeys,'DownÂ') | contains(wpmnewkeys,'UpÂ')| contains(wpmnewkeys,'LeftÂ'));
    wpmnewkeys(arrowkeys) = [];
    wrongkey1 = find(contains(wpmnewkeys,'EscapeÂ') | contains(wpmnewkeys,'VolumeMuteÂ') | contains(wpmnewkeys,'VolumeDownÂ') | contains(wpmnewkeys,'VolumeUpÂ') | contains(wpmnewkeys,'F5Â') | contains(wpmnewkeys,'LWinÂ') | contains(wpmnewkeys,'PrintScreenÂ') | contains(wpmnewkeys,'InsertÂ') | contains(wpmnewkeys,'DeleteÂ') | contains(wpmnewkeys,'MediaPlayPauseÂ') | contains(wpmnewkeys,'MediaPreviousTrackÂ') | contains(wpmnewkeys,'MediaNextTrackÂ') | contains(wpmnewkeys,'NumLockÂ') | contains(wpmnewkeys,'LMenuÂ') | contains(wpmnewkeys,'LControlKeyÂ') | contains(wpmnewkeys,'RControlKeyÂ') | contains(wpmnewkeys,'RMenuÂ')  | contains(wpmnewkeys,'HomeÂ') | contains(wpmnewkeys,'ClearÂ') | contains(wpmnewkeys,'EndÂ') | contains(wpmnewkeys,'NextÂ')  | contains(wpmnewkeys,'NoneÂ'));
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
     shiftkeys = find(contains(wpmcnewkeys,'RShiftKeyÂ') | contains(wpmcnewkeys,'LShiftKeyÂ'));
     wpmcnewkeys(shiftkeys) = [];
     backkeys = find(contains(wpmcnewkeys,'BackÂ'));
     wpmcnewkeys(backkeys) = [];
     arrowkeys = find(contains(wpmcnewkeys,'RightÂ') | contains(wpmcnewkeys,'DownÂ') | contains(wpmcnewkeys,'UpÂ')| contains(wpmcnewkeys,'LeftÂ'));
     wpmcnewkeys(arrowkeys) = [];
     wrongkey2 = find(contains(wpmcnewkeys,'OemtildeÂ') | contains(wpmcnewkeys,'OemplusÂ') | contains(wpmcnewkeys,'EscapeÂ') | contains(wpmcnewkeys,'VolumeMuteÂ') | contains(wpmcnewkeys,'VolumeDownÂ') | contains(wpmcnewkeys,'VolumeUpÂ') | contains(wpmcnewkeys,'F5Â') | contains(wpmcnewkeys,'LWinÂ') | contains(wpmcnewkeys,'PrintScreenÂ') | contains(wpmcnewkeys,'InsertÂ') | contains(wpmcnewkeys,'DeleteÂ') | contains(wpmcnewkeys,'MediaPlayPauseÂ') | contains(wpmcnewkeys,'MediaPreviousTrackÂ') | contains(wpmcnewkeys,'MediaNextTrackÂ') | contains(wpmcnewkeys,'NumLockÂ') | contains(wpmcnewkeys,'Oem5Â') | contains(wpmcnewkeys,'LMenuÂ') | contains(wpmcnewkeys,'LControlKeyÂ') | contains(wpmcnewkeys,'RControlKeyÂ') | contains(wpmcnewkeys,'RMenuÂ') | contains(wpmcnewkeys,'DivideÂ') | contains(wpmcnewkeys,'MultiplyÂ') | contains(wpmcnewkeys,'SubtractÂ') | contains(wpmcnewkeys,'HomeÂ') | contains(wpmcnewkeys,'AddÂ') | contains(wpmcnewkeys,'ClearÂ') | contains(wpmcnewkeys,'EndÂ') | contains(wpmcnewkeys,'NextÂ')  | contains(wpmcnewkeys,'NoneÂ'));
     wpmcnewkeys(wrongkey2) = []; % penalizes for uncorrected mistakes
    wrongarrow = [];
    if length(arrowkeys) > 3
        for numarrow = 1:length(arrowkeys)-1
            if arrowkeys(numarrow+1) ~= arrowkeys(numarrow)+1 && (contains(wpmcnewkeys(arrowkeys(numarrow)+1),'BackÂ') == 0)
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
    
    

    