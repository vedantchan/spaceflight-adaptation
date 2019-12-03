function [fisherZ,surrzs] = fisherz(signal1,signal2,makeplot)

if nargin<3
    makeplot = 0;
end

if length(signal2)>length(signal1)
    signal1 = resample(signal1,length(signal2),length(signal1));
elseif length(signal2) < length(signal1)
    signal2 = resample(signal2,length(signal1),length(signal2));
end



r = corrgram(signal1,signal2);

z = atanh(r);
z(isnan(z)) = 0;

fisherZ = mean(mean(abs(z)));

surrzs = [];

for i = 1:5
    surr2 = signal2(randperm(length(signal2)));
    rsurr = corrgram(signal1,surr2);
    zsurr = atanh(rsurr);
    zsurr(isnan(zsurr))=0;
    surrfisher = mean(mean(abs(zsurr)));
    surrzs = [surrzs surrfisher];    

if makeplot == 1
    figure()
    corrgram(signal1,signal2)
end
end