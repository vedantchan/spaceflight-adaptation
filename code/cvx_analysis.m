clear; close all;
origin = pwd;
addpath('.')
master = [];
paths = uipickfiles('FilterSpec','/Users/vedantchandra/JHM-Research/spaceflight-adaptation/data/*.csv','output','cell');
allscores = [];
for j = 1:length(paths)
    path = strcat(paths{j},'/EmpaticaSplit/');
    %path = paths{j};
    try
        cd(path);
    catch
        disp('No file');
        continue;
    end
    
    prefiles = dir('*.csv');
    files = {prefiles.name};
    str = pwd;
    idx = strfind(str,'/');
    subjname = str(idx(end)+1:end);


    file1 = cell(5);
    c1 = 1;

    param1 = 'EDA';


    for i = 1:length(files)
        if startsWith(files{i},'.')
            continue;
        elseif contains(files{i},param1)
            file1{c1} = files{i};
            c1 = c1+1;
        end
    end

    file1 = epochsort(file1);
    
    p_max = [];
    for i = 1:5

       signal1 = load(file1{i});
%        Fs = 4.;
%        yn = zscore(signal1);
%        [r, p, t, l, d, e, obj] = cvxEDA(yn, 1/Fs);
%        %figure;
%        tm = (1:length(yn))'/Fs;
%        %plot(tm,p);
%        phasic_pks = findpeaks(p,'SortStr','descend','NPeaks',25);
       p_max = [p_max iqr(signal1)];
       %figure;
       %plot(p);
    end
    
master = [master; p_max];
figure;
hold on;
plot(p_max);
drawnow;
end
cd(origin);