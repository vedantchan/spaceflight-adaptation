function [L,embDim,corrDim,std_corrDim] = vcorrdim(signal)
siz = size(signal);
if siz(2) > 1
    signal=signal.';
end

% Full pipeline to estimate the correlation dimension of a signal
% Uses MATS
%addpath('MATS')

%% Find time delay L

[acorr,lagtime] = xcorr(signal-mean(signal),'coeff');
[dummmy,mid] = max(acorr);
acorr(1:mid-1) = [];
lagtime = lagtime(mid:end);
L = find(acorr < max(acorr)/exp(1),1);

L = 2*L;

%% False Nearest Neighbours for embDim

dims = [1:20];
fnn = FalseNearestNeighbors(signal,L,dims,10,0);
plot(fnn)
title('False Nearest Neighbours')

fnnthresh = 0.1;

for i = 1:length(dims)
    if fnn(i) < fnnthresh
        embDim = i;
        break
    else
        continue
    end
end

%% Correlation Dimension

% Corrdim is average of correlation dimension in embedding dimensions from 
% embDim to 2*embDim (from NLD in Physio, Shelhamer)

corrDims = CorrelationDimension(signal,L,1:embDim*2,0,4,100);
%plot(corrDims)
corrdim(corrdim == NaN) = [];
corrDim = mean(corrDims(embDim:end))
std_corrDim = std(corrDims(embDim:end));


end

