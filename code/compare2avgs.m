
%%%
%%%NEED TO BUILD MACHINERY TO LOAD SIGNAL 1 AND SIGNAL 2

%%%

hold off;
plot(signal1)
hold on;
plot(signal2)
legend('VANTAN','TEMP')
hold off;


pltname = 'Subject 2: TEMP and VANTAN';

labels={'UP1','UP2','P1','P2','REC'}
corrcoef(averagevan(2:end),avgs)
title(pltname)
xlabel('Phase')
xticklabels(labels)
xticks([1 2 3 4 5])
%savefig(pltname)