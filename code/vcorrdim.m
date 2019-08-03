function [L,embDim,corrDim,std_corrDim] = vcorrdim(signal)
siz = size(signal);
if siz(2) > 1
    signal=signal.';
end

% Full pipeline to estimate the correlation dimension of a signal
% Uses MATS

%% Find time delay L

[acorr,lagtime] = xcorr(signal-mean(signal),'coeff');
[dummmy,mid] = max(acorr);
acorr(1:mid-1) = [];
lagtime = lagtime(mid:end);
L = find(acorr < max(acorr)/exp(1),1);

L = round(L/2);

%% False Nearest Neighbours for embDim

dims = 1:20;
fnn = FalseNearestNeighbors(signal,L,dims,10,0);
% plot(fnn)
% title('False Nearest Neighbours')

fnnthresh = 0.1;
fnd=0;
for i = 1:length(dims)
    if fnn(i) < fnnthresh
        embDim = i;
        fnd = 1;
        break
    elseif isnan(fnn(i))
        embDim = i-1;
        fnd = 1;
        break
    else
        continue
    end
end

if fnd == 0
    disp('ERROR: Embedding dimension > 20')
    return
end
%% Correlation Dimension

% Corrdim is average of correlation dimension in embedding dimensions from 
% embDim to embDim+1 (from NLD in Physio, Shelhamer)

corrDims = CorrelationDimension(signal,L,1:embDim*2,0,4,100);
%plot(corrDims)
corrDims(isnan(corrDims)) = [];
if 2*embDim <= length(corrDims)
    corrDim = mean(corrDims(embDim:2*embDim));
else
    corrDim = mean(corrDims(embDim:end))
end
std_corrDim = std(corrDims(embDim:end));


end

