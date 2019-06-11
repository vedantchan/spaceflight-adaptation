 % WPM testing
 
 
 subjfolders = uipickfiles('filterspec','C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data\keystroke');
%switchtimesheet = importdata('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/switchtimes.csv');
uiwait(msgbox('Which swtich time sheet are you using?'))
st = uipickfiles('filterspec','C:\Users\Spaceexplorers\Documents\GitHub\spaceflight-adaptation\data\keystroke');
switchtimesheet = importdata(st{1});

filelist=ls(fullfile(subjfolders{1},'*.txt'));

subjdatafile1 = fullfile(subjfolders{1},filelist(1,1:end)); %P
subjdatafile2 = fullfile(subjfolders{1},filelist(4,1:end)); %UP

    KEYS2 = importdata(subjdatafile2);
    EXkeys = extractBetween(KEYS2(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.SSS'); 
    TIMES_sec2 = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second;

    switchtimes = rmmissing(switchtimesheet.data); %gets rid of NANs
    subjcol = switchtimes(:,find(contains(switchtimesheet.textdata,['Subj' num2str(23)])));
    
    intervals2 = diff(TIMES_sec2);
    ind2 = find(intervals2 > min(subjcol)); %weird number for UP
    cleanedintervals2 = intervals2;
    cleanedintervals2(ind2) = [];

    totalmins2 = sum(cleanedintervals2)/60; %missing some... probably from accidentally deleting when stopped typing >> should check for "done" somehow..

    %% wpm, no corrections
    
    % no backspace, no shift, no enter
    notwpmkeys2 = find(contains(KEYS2,'RShiftKeyÂ') | contains(KEYS2,'BackÂ') | contains(KEYS2,'LShiftKeyÂ'));
    arrowkeys2 = find(contains(KEYS2,'RightÂ') | contains(KEYS2,'DownÂ') | contains(KEYS2,'UpÂ')| contains(KEYS2,'LeftÂ'));
    newkeys2 = KEYS2;
    newkeys2(notwpmkeys2) = [];
    newkeys2(arrowkeys2) = [];
    totalkeys2 = length(newkeys2); % this has the notwpmkeys removed and arrow keys removed ONLY
    
    wpm2 = (totalkeys2/5)/totalmins2;
    
    % total words, uncorrected ?
    totalwords2 = totalkeys2/5;

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
            % comes up (b/c consecutive arrow keys isn't technically a mistake)

   	backkey2 = find(contains(KEYS2,'BackÂ'));
    wrongkey = find(contains(KEYS2,'OemtildeÂ') | contains(KEYS2,'OemplusÂ') | contains(KEYS2,'EscapeÂ') | contains(KEYS2,'VolumeMuteÂ') | contains(KEYS2,'VolumeDownÂ') | contains(KEYS2,'VolumeUpÂ') | contains(KEYS2,'F5Â') | contains(KEYS2,'LWinÂ') | contains(KEYS2,'PrintScreenÂ') | contains(KEYS2,'InsertÂ') | contains(KEYS2,'DeleteÂ') | contains(KEYS2,'MediaPlayPauseÂ') | contains(KEYS2,'MediaPreviousTrackÂ') | contains(KEYS2,'MediaNextTrackÂ') | contains(KEYS2,'NumLockÂ') | contains(KEYS2,'Oem5Â') | contains(KEYS2,'LMenuÂ') | contains(KEYS2,'LControlKeyÂ') | contains(KEYS2,'RControlKeyÂ') | contains(KEYS2,'RMenuÂ') | contains(KEYS2,'DivideÂ') | contains(KEYS2,'MultiplyÂ') | contains(KEYS2,'SubtractÂ') | contains(KEYS2,'HomeÂ') | contains(KEYS2,'AddÂ') | contains(KEYS2,'ClearÂ') | contains(KEYS2,'EndÂ') | contains(KEYS2,'NextÂ'));
    wrongarrow = [];
    for numarrow = 1:length(arrowkeys2)-1
        if arrowkeys2(numarrow+1) ~= arrowkeys2(numarrow)+1 && (contains(KEYS2(arrowkeys2(numarrow)+1),'BackÂ') == 0)
            wrongarrow = [wrongarrow arrowkeys2(numarrow)];
        end
    end
    
    wpm_corrected2 = ((length(KEYS2)/5) - (length(notwpmkeys2)+length(wrongarrow)+length(wrongkey)))/totalmins2; % everything wrong but all arrow keys
    
    % accuracy
    accuracy2 = ((length(KEYS2) - (length(backkey2)+length(wrongarrow)+length(wrongkey)))/length(KEYS2))*100; % no penalty for shifts
    
    