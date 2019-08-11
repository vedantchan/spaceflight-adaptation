clear; close all;
origin = pwd;
paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/code/epochs/*','output','cell');


master1 = open(paths{1});
master2 = open(paths{2});
master1 = master1.master;
master2 = master2.master;

rows = size(master1,1);
cols = 2;

corrs = [];
for i = 1:rows

    corr = corrcoef(master1(i,:),master2(i,:));
    corr = corr(1,2);
    corrs = [corrs corr];
    
end

figure;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
ct = 0;

subplot(1,cols,1);

for i = 1:rows
    hold on
   plot(master1(i,:))
end


subplot(1,cols,2);
for i = 1:rows
    hold on
   plot(master2(i,:))
end