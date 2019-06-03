function [] = comparesubplot(table1,table2)
figure('Units','normalized','Position',[0 0 .25 1])
labels={'UP1','UP2','P1','P2','REC'};
corrs = [];
for i = 1:size(table1,2)
    subplot(size(table1,2),1,i);
    subjectmeasure1 = table2array(table1(:,i));
    subjectmeasure2 = table2array(table2(:,i));
    norm1 = (subjectmeasure1 - min(subjectmeasure1)).*(1/(max(subjectmeasure1)-min(subjectmeasure1)));
    norm2 = (subjectmeasure2 - min(subjectmeasure2)).*(1/(max(subjectmeasure2)-min(subjectmeasure2)));
    plot(norm1,'b');
    hold on 
    plot(norm2,'r');
    hold off
    title(strcat('Subject-',num2str(i)));
    xticks([1 2 3 4 5]);
    xticklabels(labels);
    correlate = corrcoef(subjectmeasure1,subjectmeasure2);
    text(0.7,0.7,strcat('\rho=',num2str(correlate(1,2))),'Units','Normalized')
    corrs = [corrs correlate(1,2)];
end
sgtitle(strcat(table1.Properties.Description,'(b) vs. ',table2.Properties.Description,'(r)'))
savefig(strcat('plots/compareEpochs/',table1.Properties.Description,'_vs_',table2.Properties.Description))
csvwrite(strcat('meta/compareEpochs/corr_',table1.Properties.Description,'_vs_',table2.Properties.Description),corrs)
end