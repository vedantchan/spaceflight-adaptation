close all; clear
timest = importswitches('../data/fullswitches.csv');
times = table2array(timest).';
labels = {'UP1','UP1','UP1','UP2','UP2','UP2','P1','P1','P1','P2','P2','P2','Rec','Rec'};
%violin(times,'facecolor','k');
figure('DefaultAxesFontSize',17)
boxplot(times,'plotstyle','compact','colors','k');
xticks([1:14]);
xticklabels(labels);
title('Switch Task Completion Times')
ylabel('Time (s)')
%%

damage = (mean(times(:,7:11),2) - mean(times(:,4:5),2));
dsig = std(times(:,7:11),0,2) + std(times(:,4:5),0,2);

adaptation = mean(times(:,10:11),2) - mean(times(:,7:8),2);

recovery = mean(times(:,7:11),2)-mean(times(:,13:14),2);
rsig = std(times(:,13:14),0,2) + std(times(:,7:11),0,2);

figure;
plot(damage,recovery,'ko')
p = glmfit(damage,recovery);
hold on 
plot(damage,p(2)*damage + p(1),'r--');
xlabel('Time Increase after Perturbation (s)')
ylabel('Time Decrease after Recovery (s)')
title('Switch Task: Perturbation vs. Recovery')
set(gca,'FontSize',18);

[rho,pval] = corr(damage,recovery)

adaptors = recovery < p(2)*damage + p(1);

hold on 
plot(damage(adaptors),recovery(adaptors),'ro')
hold off
%%
subjs = 1:20
figure;
plot(subjs,adaptation,'ko')
hold on 
plot(subjs(adaptors),adaptation(adaptors),'ro')
yline(0,'k--')
