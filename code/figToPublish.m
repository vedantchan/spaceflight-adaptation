clear; close all;
origin = pwd;

[file,filepath] = uigetfile('*.fig','multiselect','on');
addpath('.');
%%
if class(file) == 'char'
    file = {file};
end
cd(filepath)
mkdir('png')
mkdir('pdf')
for i = 1:length(file)
    
   figure = openfig(file{i},'invisible');
   filename = file{i};
   filename = filename(1:end-3);
   saveas(figure,strcat('png/',filename,'.png'));
   cd('pdf')
   savepdf(figure,filename);
   cd ..
   
end

cd(origin)

function[] = savepdf(figure,filename)
gcf = figure;
set(gcf,'Units','inches');
screenposition = get(gcf,'Position');
set(gcf,...
    'PaperPosition',[0 0 screenposition(3:4)],...
    'PaperSize',[screenposition(3:4)]);
print(strcat(filename,'.pdf'),'-dpdf','-painters')
end