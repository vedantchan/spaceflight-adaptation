% 6/6/19: windowed variance function
% 7/12/19: change to matrix input
% need to fix: resampling (get rid of it), windowsize to windowpercent <<
% but maybe thats ok b/c window size 
%7/12/19: fixed resampling, still not sure about windowsize/percent

% input: sorted files (by epoch) and chosen window size (percent)
% output: array of variances

function cellofvars = windowvar(sortedcell, windowpercent)
rawdata1 = (sortedcell{1});
rawdata2 = (sortedcell{2});
rawdata3 = (sortedcell{3});
rawdata4 = (sortedcell{4});
rawdata5 = (sortedcell{5});

alldata = {rawdata1 rawdata2 rawdata3 rawdata4 rawdata5};
newdata1 = [];
newdata2 = [];
newdata3 = [];
newdata4 = [];
newdata5 = [];
cellofnew = {newdata1 newdata2 newdata3 newdata4 newdata5};

for datacount = 1:5     % loop through all epochs
    currentdata = alldata{datacount};
    tempnewarr = [];

    % window stuff
    windowsize = floor(windowpercent*length(currentdata));
    %***if less than 1:
    maxlength = length(currentdata);
    ml = maxlength;
    m = mod(ml,windowsize);
    while m > 0
        ml = ml-1;
        m = mod(ml,windowsize);
    end
    maxlength = ml;
    
     % - loop thru the data and calculate the variance at each index
            % - then repeat the variance value the same number of time as the
            % window size
            % - then put into new array
        for indcount = 1:windowsize:maxlength
            temparr = currentdata(indcount:indcount+windowsize-1);
            varofwindow = var(temparr);
            tempnewarr = [tempnewarr repelem(varofwindow,windowsize)];
        end
        cellofnew{datacount} = tempnewarr;
end

cellofvars = cellofnew;

