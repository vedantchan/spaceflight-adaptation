% windowed variance function, 6/6/19

% input: sorted files (by epoch) and chosen window size (percent)
% output: array of variances

function cellofvars = windowedvariance(hrsortedfiles, windowpercent)

% resample data to max length data so window size can be applied to all
hrrawdata1 = importdata(hrsortedfiles{1}{1});
hrrawdata2 = importdata(hrsortedfiles{2}{1});
hrrawdata3 = importdata(hrsortedfiles{3}{1});
hrrawdata4 = importdata(hrsortedfiles{4}{1});
hrrawdata5 = importdata(hrsortedfiles{5}{1});

% hrrawdata1 = hrrawdata1(20:end);
% hrrawdata5 = hrrawdata5(20:end-20);

maxlength = max([length(hrrawdata1); length(hrrawdata2);length(hrrawdata3);length(hrrawdata4);length(hrrawdata5)]);

hrdata1 = resample(hrrawdata1,maxlength,length(hrrawdata1));
hrdata2 = resample(hrrawdata2,maxlength,length(hrrawdata2));
hrdata3 = resample(hrrawdata3,maxlength,length(hrrawdata3));
hrdata4 = resample(hrrawdata4,maxlength,length(hrrawdata4));
hrdata5 = resample(hrrawdata5,maxlength,length(hrrawdata5));

hralldata = [hrdata1 hrdata2 hrdata3 hrdata4 hrdata5];

% window stuff

windowsize = round(windowpercent*length(hrdata1));

ml = maxlength;
m = mod(ml,windowsize);

while m > 0
    ml = ml-1;
    m = mod(ml,windowsize);
end

maxlength = ml;

newdata1 = [];
newdata2 = [];
newdata3 = [];
newdata4 = [];
newdata5 = [];

cellofnew = {newdata1 newdata2 newdata3 newdata4 newdata5};

for datacount = 1:5     % loop through all epochs
    currentdata = hralldata(:,datacount);
    tempnewarr = [];

    for indcount = 1:windowsize:maxlength
        % - loop thru the data and calculate the variance at each index
        % - then repeat the variance value the same number of time as the
        % window size
        % - then put into new array
        temparr = currentdata(indcount:indcount+windowsize-1);
        varofwindow = var(temparr);
        tempnewarr = [tempnewarr repelem(varofwindow,windowsize)];
    end
    cellofnew{datacount} = tempnewarr;
end

% spit out variance vector
% newdata1 = cellofnew{1}';
% newdata2 = cellofnew{2}';
% newdata3 = cellofnew{3}';
% newdata4 = cellofnew{4}';
% newdata5 = cellofnew{5}';

cellofvars = cellofnew;

