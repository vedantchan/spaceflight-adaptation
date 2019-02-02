% puts areas into one file

clear; close all;

try
%load in the data
[file, path] = uigetfile('*.csv','multiselect','on');   
catch 
    disp('FIX: Make sure Current Folder matches where you get the data when prompted.')
    disp('You can do this by clicking Desktop above this and navigating in the Current Folder.')
end    

%% for Xcorr data

% for right now, need to manually change the subject name

if contains(path,'XCorr')
    Comparison = [];
    areas = [];
    areaabs = [];
    firstpeak = [];
    peak = [];
    troughs = [];
    firsttroughs = [];
    othertroughs = [];
    otherpeaks= [];


    for i = 1:length(file)
        Comparison = [Comparison ; string(file{i}(1:end-4))];
        data = importdata(strcat(path,file{i}));
        areas = [areas ; data.data(:,1)];
        areaabs = [areaabs ; data.data(:,2)];
        firstpeak = [firstpeak ; data.data(:,3)];
        peak = [peak ; data.data(:,4)];
        firsttroughs = [firsttroughs; data.data(:,5)];
        troughs = [troughs; data.data(:,6)];
        otherpeaks = [otherpeaks ; data.data(:,7)];
        othertroughs = [othertroughs ; data.data(:,8)];
    
    end

    T = table(Comparison, areas, areaabs, firstpeak, peak, firsttroughs, troughs, otherpeaks, othertroughs);
    writetable(T, strcat(pwd, '/XCorr_combinedcsv_data/MC2_xcor_dataall_rec.csv'));

end

%% for Keys data

if contains(path, 'Key')
    mkdir('KeyAnalysis_results_combined');
    mkdir('betterKeyAnalysis_results_combined');

    for i = 1:length(file)
            data = importdata(strcat(path,file{i}));
            datatype = data.textdata;
        if contains(file{i},'_P1')
            P1 = data.data;
        elseif contains(file{i}, '_P2')
            P2 = data.data;
        elseif contains(file{i}, 'UP2')
            UP2 = data.data;
        elseif contains(file{i}, 'UP1')
            UP1 = data.data;
        elseif contains(file{i}, 'REC')
            REC = data.data;
        end            
    end
    datatype = datatype';
    UP1 = UP1';
    UP2 = UP2';
    P1 = P1';
    P2 = P2';
    REC = REC';
    
    T = table(datatype, UP1, UP2, P1, P2, REC);
    writetable(T, strcat('betterKeyAnalysis_results_combined', '/', file{1}(1:2), '_keys_combined', '.csv'));
end

% manually make graph bc easier to manipulate in excel

%% For autocorr



