function[] = makesubjectcorrplot(inputtable,name) 

figure()
array = table2array(inputtable);
imagesc(corrcoef(array))
cbar = colorbar;
colormap('cool')
title(strcat(name," - Inter-Subject Correlation Across Epochs"))
xlabel("Subjects")
ylabel("Subjects")
ylabel(cbar,"Correlation Coefficient")


end