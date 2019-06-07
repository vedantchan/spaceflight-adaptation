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



