function de = quickde(ts,dim,lag,nmin)
% de = quickde(ts,dim,lag,nmin)
% does a quick-and-dirty characterization of determinism using de
% ts -- the time series
% dim -- the embedding dimension
% lag -- the embedding lag
% nmin -- optional: number of points to use for delta-eps fitting
%           default value: 500
% Copyright (c) 1996 by D. Kaplan, All Rights Reserved

if nargin < 4
  nmin=500;
end

% embed the data
xx = lagembed(ts,dim,lag);
% get the 'forecasting' pre-image and image
[pre,post] = getimage(xx,1);
% find a 'typical' distance to use for delta-epsilon
% we want to have at least nmin points, so we pick

perc = (2*nmin)/(length(ts).^2);
deltamax = disttyp(pre,perc);

[delta,epsilon] = deltaeps(pre,post);
[de,b] = defit(delta,epsilon,deltamax);



