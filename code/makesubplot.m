function [] = makesubplot(inputtable,name)
figure('Units','normalized','Position',[0 0 .25 1])
labels={'UP1','UP2','P1','P2','REC'};
%subplots

for i = 1:size(inputtable,2)
    subplot(size(inputtable,2),1,i);
    plot(table2array(inputtable(:,i)));
    xticks([1 2 3 4 5]);
    xticklabels(labels);
    title(strcat('Subject - ',num2str(i)));

sgtitle(strcat(name));
    
end