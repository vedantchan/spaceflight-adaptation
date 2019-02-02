% z vectorization
clear; close all;
try
%load in the data
[file, path] = uigetfile('*.csv', 'Multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end

mkdir([path 'Z_vec'])
for i = 1:length(file)
    data = importdata(strcat(path,file{i}));
    
    x = data.data(:,2);
    y = data.data(:,3);
    z = data.data(:,4);
    
    z = sqrt((x.^2) + (y.^2) + (z.^2));
    
    plot(data.data(:,1), z)
    dlmwrite([path 'Z_vec/' file{i} '_z.csv'],[data.data(:,1) z]);
end
