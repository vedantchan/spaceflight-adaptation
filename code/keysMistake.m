% 6/10/19: Keystroke mistake analysis

function [totalmistakes, avgmistakes, percentmistake] = keysMistake(subjdatafold)

    KEYS = importdata(subjdatafold);
    EXkeys = extractBetween(KEYS(2:end), 11, 22);
    EXkeys = datetime(EXkeys, 'inputformat', 'HH:mm:ss.S'); 
    TIMES_sec = EXkeys.Hour*3600+EXkeys.Minute*60+EXkeys.Second; %seconds past midnight
    MINS = floor(TIMES_sec/60); %rounds down to the minute >> makes this into minutes past midnight
    start = min(MINS);
    finish = max(MINS);
   
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
    avgmistakes = (totalmistakes/(finish-start));
    
    %mistake percent
    totalkeystrokes = length(KEYS(2:en));
    percentmistake = totalmistakes/totalkeystrokes;
    
    