% Windowed variance analysis on all subjs, 6/6/19
% **only for hr atm, but should work for anything (i think?)

clear all;
close;

current = pwd;

uiwait(msgbox('Select your smoothed folder'))
trialsPath = uigetdir;
cd(trialsPath);
string = ls;
list = strsplit(string);
subjects = list(~cellfun('isempty',list));

uiwait(msgbox('Select your variance folder'))
variancefolder = uigetdir;
% answer = inputdlg("What kind of data do you want to use?");
% answer = answer{1};

windowsize = inputdlg("What is your windowsize?");
windowsize = windowsize{1};

cd(current)
for subjcount = 1:length(subjects)
    currentsubj = [trialsPath '/' subjects{subjcount} ];
    % cd(currentsubj);
    
    hrfiles = dir(fullfile(currentsubj,'TEMP.csv*.csv'));
    hrsortedfiles = {{strcat(hrfiles(1).folder,'/TEMP.csv_E4_UP1_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/TEMP.csv_E4_UP2_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/TEMP.csv_E4_P1_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/TEMP.csv_E4_P2_smoothedandresampled.csv')} {strcat(hrfiles(1).folder,'/TEMP.csv_E4_Rec_smoothedandresampled.csv')}};

    windowpercent = 0.0051;

    cellofnew = windowvar(hrsortedfiles,windowpercent);
    
    dlmwrite(strcat(currentsubj, '/', 'TEMPvar_', 'UP1.csv'), cellofnew{1});
    dlmwrite(strcat(currentsubj, '/', 'TEMPvar_', 'UP2.csv'), cellofnew{2});
    dlmwrite(strcat(currentsubj, '/', 'TEMPvar_', 'P1.csv'), cellofnew{3});
    dlmwrite(strcat(currentsubj, '/', 'TEMPvar_', 'P2.csv'), cellofnew{4});
    dlmwrite(strcat(currentsubj, '/', 'TEMPvar_', 'Rec.csv'), cellofnew{5});
    
    % write into a separate variance folder 
   varsubj = [variancefolder '/' subjects{subjcount}];
    mkdir(varsubj);
    
    dlmwrite(strcat(varsubj, '/', 'TEMPvar_', 'UP1.csv'), cellofnew{1});
    dlmwrite(strcat(varsubj, '/', 'TEMPvar_', 'UP2.csv'), cellofnew{2});
    dlmwrite(strcat(varsubj, '/', 'TEMPvar_', 'P1.csv'), cellofnew{3});
    dlmwrite(strcat(varsubj, '/', 'TEMPvar_', 'P2.csv'), cellofnew{4});
    dlmwrite(strcat(varsubj, '/', 'TEMPvar_', 'Rec.csv'), cellofnew{5});
    
    figure
    subplot(5,1,1)
    plot(cellofnew{1}(120:end));
    title(['window size ' num2str(windowsize)])
    ylim([0 2.5])
    subplot(5,1,2)
    plot(cellofnew{2});
    ylim([0 2.5])
    subplot(5,1,3)
    plot(cellofnew{3});
    ylim([0 2.5])
    subplot(5,1,4)
    plot(cellofnew{4});
    ylim([0 2.5])
    subplot(5,1,5)
    plot(cellofnew{5}(10:end-10));
    ylim([0 2.5])
    
    saveas(gcf,strcat(varsubj, '/', 'TEMPvarplot.fig'));
end



