clear; close all;
origin = pwd;

[file,filepath] = uigetfile('*.fig','multiselect','on');

%%

cd(filepath)
mkdir('png')
mkdir('pdf')
for i = 1:length(file)
    
   figure = openfig(file{i},'invisible');
   filename = file{i};
   filename = filename(1:end-3);
   saveas(figure,strcat('png/',filename,'.png'));
   saveas(figure,strcat('pdf/',filename,'.pdf'));
   
end

cd(origin)