function [] = makeoverlayplot(inputtable,name)
figure()

for i = 1:size(inputtable,2)
    
    subjectmeasure = table2array(inputtable(:,i));
    
    
    plot(subjectmeasure,'DisplayName',strcat('Subject-',num2str(i)));
    ylabel("Measure")
    xlabel("Epoch")
    
    hold on
    
end
legend
labels={'UP1','UP2','P1','P2','REC'};
xticks([1 2 3 4 5]);
xticklabels(labels);
title(strcat(name," - Overlay Plot"))

end