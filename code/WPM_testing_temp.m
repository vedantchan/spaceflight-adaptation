 % 6/11/19 WPM testing
 
 
 subjfolders = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke');
%switchtimesheet = importdata('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/switchtimes.csv');
uiwait(msgbox('Which swtich time sheet are you using?'))
st = uipickfiles('filterspec','/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke');
switchtimesheet = importdata(st{1});

filelist=ls(fullfile(subjfolders{1},'*.txt'));
filelist = strsplit(filelist);

%subjdatafile1 = fullfile(subjfolders{1},filelist(1,1:end)); %P
%subjdatafile2 = fullfile(subjfolders{1},filelist(4,1:end)); %UP

subjdatafile1 = filelist{1}; %P
subjdatafile2 = filelist{4}; %UP

KEYS = importdata(subjdatafile1);
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.SSS'); 
    TIMES_sec2 = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second;

    switchtimes = rmmissing(switchtimesheet.data); %gets rid of NANs
    subjcol = switchtimes(:,find(contains(switchtimesheet.textdata,['Subj' 24])));
    
    intervals2 = diff(TIMES_sec2);
    ind2 = find(intervals2 > min(subjcol)); %weird number for UP
    cleanedintervals2 = intervals2;
    cleanedintervals2(ind2) = [];

    totalmins2 = sum(cleanedintervals2)/60; %missing some... probably from accidentally deleting when stopped typing >> should check for "done" somehow..

    %% wpm, no corrections
    
    % no backspace, no shift, no enter,  things that don't make a mark?
    shiftkeys = find(contains(KEYS,'RShiftKey�') | contains(KEYS,'LShiftKey�'));
   	backkeys = find(contains(KEYS,'Back�'));
    arrowkeys = find(contains(KEYS,'Right�') | contains(KEYS,'Down�') | contains(KEYS,'Up�')| contains(KEYS,'Left�'));
    wrongkey1 = find(contains(KEYS,'Escape�') | contains(KEYS,'VolumeMute�') | contains(KEYS,'VolumeDown�') | contains(KEYS,'VolumeUp�') | contains(KEYS,'F5�') | contains(KEYS,'LWin�') | contains(KEYS,'PrintScreen�') | contains(KEYS,'Insert�') | contains(KEYS,'Delete�') | contains(KEYS,'MediaPlayPause�') | contains(KEYS,'MediaPreviousTrack�') | contains(KEYS,'MediaNextTrack�') | contains(KEYS,'NumLock�') | contains(KEYS,'LMenu�') | contains(KEYS,'LControlKey�') | contains(KEYS,'RControlKey�') | contains(KEYS,'RMenu�')  | contains(KEYS,'Home�') | contains(KEYS,'Clear�') | contains(KEYS,'End�') | contains(KEYS,'Next�')  | contains(KEYS,'None�'));
% need to check^ 

    wpmnewkeys = KEYS;
    wpmnewkeys(shiftkeys) = [];
    wpmnewkeys(backkeys) = [];
    wpmnewkeys(arrowkeys) = [];
    wpmnewkeys(wrongkey1) = [];
    
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

    wrongkey2 = find(contains(KEYS,'Oemtilde�') | contains(KEYS,'Oemplus�') | contains(KEYS,'Escape�') | contains(KEYS,'VolumeMute�') | contains(KEYS,'VolumeDown�') | contains(KEYS,'VolumeUp�') | contains(KEYS,'F5�') | contains(KEYS,'LWin�') | contains(KEYS,'PrintScreen�') | contains(KEYS,'Insert�') | contains(KEYS,'Delete�') | contains(KEYS,'MediaPlayPause�') | contains(KEYS,'MediaPreviousTrack�') | contains(KEYS,'MediaNextTrack�') | contains(KEYS,'NumLock�') | contains(KEYS,'Oem5�') | contains(KEYS,'LMenu�') | contains(KEYS,'LControlKey�') | contains(KEYS,'RControlKey�') | contains(KEYS,'RMenu�') | contains(KEYS,'Divide�') | contains(KEYS,'Multiply�') | contains(KEYS,'Subtract�') | contains(KEYS,'Home�') | contains(KEYS,'Add�') | contains(KEYS,'Clear�') | contains(KEYS,'End�') | contains(KEYS,'Next�')  | contains(KEYS,'None�'));
    wrongarrow = [];
    if length(arrowkeys) > 3
        for numarrow = 1:length(arrowkeys)-1
            if arrowkeys(numarrow+1) ~= arrowkeys(numarrow)+1 && (contains(KEYS(arrowkeys(numarrow)+1),'Back�') == 0)
                wrongarrow = [wrongarrow arrowkeys(numarrow)];
            end
        end
    else
        wrongarrow = arrowkeys;
    end
    %cleaning out all bad keys
    % ORDER MATTERS??
    wpmckeys = KEYS;
    wpmckeys(shiftkeys) = [];
    wpmckeys(backkeys) = [];
    wpmckeys(arrowkeys) = [];
    wpmckeys(wrongkey2) = []; % penalizes for uncorrected mistakes
    totalkeyscorr = length(wpmckeys);
    
    %penalized for backspace or arrow (penalization is like a weight)
    wpm_corrected = ((totalkeyscorr/5) - length(backkeys) - length(wrongarrow))/(2*totalmins2); % everything wrong but all arrow keys
    
    % accuracy > not accurate for some reason, har har
    accuracy = ((totalkeyscorr)/(length(KEYS)))*100; % no penalty for shifts
    
    % total words, corrected
    %wpmckeys(shiftkeys) = [];
    totalwords = totalkeyscorr/5;
    