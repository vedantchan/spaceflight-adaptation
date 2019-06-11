%% 6/10/19: Keystroke Analysis: uses keysgen, keysmistake, WPM

clear all;
close;

subjfolders = uipickfiles;
switchtimesheet = importdata('/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/switchtimes.csv');

folder = newEpochAnalysis;
% answer = inputdlg('What is your starting subject number?');

for subjcount = answer{1}:length(subjfolders)+answer{1}
    mkdir(['/Users/SYT/Documents/GitHub/spaceflight-adaptation/data/keystroke/' folder '/' 'subj' num2str(subjcount)])

    % keysgen 
    [keypermin, cleanedintervals] = keystrokegen(subjfolder{answer{1} - (answer{1}-1)},subjcount,switchtimesheet);
    
    %keysWPM
    [wpm,wpm_corrected,accuracy] = keystrokeWPM(subjfolder{answer{1} - (answer{1}-1)},switchtimesheet);
    
    %keysMistake
    [totalmistakes, avgmistakes, percentmistake] = keysMistake(subjfolder{answer{1} - (answer{1}-1)});
    
end


