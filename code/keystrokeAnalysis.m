%% 6/10/19: Keystroke Analysis: uses keysgen, keysmistake, WPM

clear all;
close;

uiwait(msgbox('Pick your subject folders'))
subjfolders = uipickfiles('filterspec', '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke');
%switchtimesheet = importdata('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/switchtimes.csv');
uiwait(msgbox('Which swtich time sheet are you using?'))
st = uipickfiles('filterspec', '/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke');
switchtimesheet = importdata(st{1});
answer = inputdlg('What is your starting subject number?');

for subjcount = str2num(answer{1}):length(subjfolders)+str2num(answer{1})
    currentsubjfolder = ['/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/newEpochAnalysis/subj' num2str(subjcount)];
    mkdir(currentsubjfolder)
    filelist=ls(fullfile(subjfolders{1},'*.txt'));
    filelist= strsplit(filelist);
    subjfile = epochsort(filelist);

    %subjfile = fullfile(subjfolders{subjcount},filelist(filecount));

    avgkeypermin = [];
    stdkeypermin = [];
    avgcleanedintervals = [];
    stdcleanedintervals = [];
    maxcleanedintervals = [];
    wpm = [];
    wpm_corrected = [];
    accuracy = [];
    totalwords = [];
    
%     totalmistakes = [];
%     avgmistakes = [];
%     percentmistake = [];
    
    
    for filecount = 1:5
        % keysgen 
        [keypermin, cleanedintervals] = keystrokegen(subjfile{filecount},subjcount,switchtimesheet);
         avgkeypermin = [avgkeypermin mean(keypermin)];
         stdkeypermin = [stdkeypermin std(keypermin)];
         avgcleanedintervals = [avgcleanedintervals mean(cleanedintervals)];
         stdcleanedintervals = [stdcleanedintervals std(cleanedintervals)];
         maxcleanedintervals = [maxcleanedintervals max(cleanedintervals)];
         
        %keysWPM
        [wpm_nc,wpm_c,acc, totw] = keystrokeWPM(subjfile{filecount},subjcount,switchtimesheet);
        wpm = [wpm wpm_nc];
        wpm_corrected = [wpm_corrected wpm_c];
        accuracy = [accuracy acc];
        totalwords = [totalwords totw];

        %keysMistake
        % [totalmistakes, avgmistakes, percentmistake] = keysMistake(subjfile);   
    end
    
    T = table(avgkeypermin, stdkeypermin, avgcleanedintervals, stdcleanedintervals, maxcleanedintervals, wpm, wpm_corrected, accuracy, totalwords);
    writetable(T,[currentsubjfolder '/' 'keysEpochData.csv']);
    
    subplot(7,1,1)
    errorbar(avgkeypermin,stdkeypermin)
    title('Average Key Press Per Min Across Epoch')
    
    subplot(7,1,2)
    errorbar(avgcleanedintervals,stdcleanedintervals)
    title('Average Key Intervals Across Epoch (Clean)')
    
    subplot(7,1,3)
    plot(maxcleanedintervals)
    title('Maximum Key Intervals')
    
    subplot(7,1,4)
    plot(wpm)
    title('Words Per Minute (Uncorrected)')
    
    subplot(7,1,5)
    plot(wpm_corrected)
    title('Words Per Minute (Corrected)')
    
    subplot(7,1,6)
    plot(accuracy)
    title('Typing Accuracy')
    
    subplot(7,1,7)
    plot(totalwords)
    title('Total Words (Corrected)');
    names = {'UP1'; 'UP2'; 'P1'; 'P2'; 'REC'};

    saveas(gcf,[currentsubjfolder '/' 'allkeysEpochdata.fig']);
    
    
end


