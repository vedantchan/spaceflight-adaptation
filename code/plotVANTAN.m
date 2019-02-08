origin = pwd;
[filename,path] = uigetfile('*.csv');
cd(path)

delimiter = ',';
startRow = 2;

formatSpec = '%*s%f%[^\n\r]';

fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);

averagevan = dataArray{:, 1};

plot(averagevan);
title('VANTAN')

cd(origin)