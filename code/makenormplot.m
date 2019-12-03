function [] = makenormplot(inputtable,name)

figure()

for i = 1:size(inputtable,2)
    
    subjectmeasure = table2array(inputtable(:,i));
    maxmeasure = max(subjectmeasure);
    minmeasure = min(subjectmeasure);
    
    normvas = (subjectmeasure - minmeasure).*(1/(maxmeasure-minmeasure));
    
    
    plot(normvas,'DisplayName',strcat('Subject-',num2str(i)));
    hold on
    
end
legend
labels={'UP1','UP2','P1','P2','REC'};
sgtitle(strcat(name,' - Normalized'))
xticks([1 2 3 4 5]);
xticklabels(labels);
ylim([-0.25 1.25])


end