clear; close all;

origin = pwd;
uiwait(msgbox('Select 5 csv files'));
[filename,path] = uigetfile('*.csv','multiselect','on');

cd(path)
avgs = [0 0 0 0 0];

for i = 1:length(filename)
   x = load(filename{i});
   av = mean(x);
   
   if contains(filename{i},'UP1')
       avgs(1) = av;
   elseif contains(filename{i},'UP2')
       avgs(2) = av;
   elseif contains(filename{i},'P1')
       avgs(3) = av;
   elseif contains(filename{i},'P2')
       avgs(4) = av;
   elseif contains(filename{i},'Rec')
       avgs(5) = av;
   end

end

plot(avgs)