function fnnM = FalseNearestNeighbors(xV,tauV,mV,escape,theiler)
% fnnM = FalseNearestNeighbors(xV,tauV,mV,escape,theiler)
% FALSENEARESTNEIGHBORS computes the percentage of false nearest neighbors
% for a range of delays in 'tauV' and embedding dimensions in 'mV'.
% INPUT 
%  xV       : Vector of the scalar time series
%  tauV     : A vector of the delay times.
%  mV       : A vector of the embedding dimension.
%  escape   : A factor of escaping from the neighborhood. Default=10.
%  theiler  : the Theiler window to exclude time correlated points in the
%             search for neighboring points. Default=0.
% OUTPUT: 
%  fnnM     : A matrix of size 'ntau' x 'nm', where 'ntau' is the number of
%             given delays and 'nm' is the number of given embedding
%             dimensions, containing the percentage of false nearest
%             neighbors.
% 
%========================================================================
%     <FalseNearestNeighbors.m>, v 1.1 2019/01/13 Kugiumtzis & Tsimpiris
%     This is part of the MATS-Toolkit http://eeganalysis.web.auth.gr/

%========================================================================
% Copyright (C) 2019 by Dimitris Kugiumtzis and Alkiviadis Tsimpiris 
%                       <dkugiu@auth.gr>

%========================================================================
% Version: 1.1

% The FreeBSD Copyright:	
% Copyright 1992-2012 The FreeBSD Project. All rights reserved.	

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:

% Redistributions of source code must retain the above copyright notice, 
% this list of conditions and the following disclaimer.	
% Redistributions in binary form must reproduce the above copyright notice, 
% this list of conditions and the following disclaimer in the documentation 
% and/or other materials provided with the distribution.	

% "THIS SOFTWARE IS PROVIDED BY THE FREEBSD PROJECT ``AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE FREEBSD PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
% OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
% ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
% IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

% The views and conclusions contained in the software and documentation are those of the authors and should not
% be interpreted as representing official policies, either expressed or implied, of the FreeBSD Project.

%=========================================================================
% Reference : D. Kugiumtzis and A. Tsimpiris, "Measures of Analysis of Time 
% Series (MATS): A Matlab  Toolkit for Computation of Multiple Measures on 
% Time Series Data Bases", Journal of Statistical Software, Vol. 33, 
% Issue 5, 2010
% 
% Link      : http://eeganalysis.web.auth.gr/
%========================================================================= 
fthres = 0.1; % A factor of the data SD to be used as the maximum radius 
              % for searching for valid nearest neighbor.
propthres = 0.1; % Limit for the proportion of valid points, i.e. points 
                 % for which a nearest neighbor was found. If the proporion 
                 % of valid points is beyond this limit, do not compute
                 % FNN.              
n = length(xV);
if isempty(escape), escape=10; end
if isempty(theiler), theiler=0; end
% Rescale to [0,1] and add infinitesimal noise to have distinct samples
xmin = min(xV);
xmax = max(xV);
xV = (xV - xmin) / (xmax-xmin);
xV = AddNoise(xV,10^(-10));
rthresmax = fthres*std(xV); % The maximum distance to look for nearest neighbor
ntau = length(tauV);
nm = length(mV);
fnnM = NaN*ones(ntau,nm);
for itau = 1:ntau
    tau = tauV(itau);
    im=1;
    nextm = 1;
    while im<=nm && nextm
        m = mV(im);
        nvec = n-m*tau; % to be able to add the component x(nvec+tau) for m+1 
        if nvec-theiler < 2
            break;
        end
        xM = NaN*ones(nvec,m);
        for i=1:m
            xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
        end
        % k-d-tree data structure of the training set for the given m
        kdtreeS = KDTreeSearcher(xM); 
        % For each target point, find the nearest neighbor, and check 
        % whether the distance exceeds the escape distance by adding the
        % next component for m+1.
        if theiler == 0
            [neiindM,neidisM]=knnsearch(kdtreeS,xM,'K',2);
            idxV = neiindM(:,2); 
            distV = neidisM(:,2);
        else
            [neiindM,neidisM]=knnsearch(kdtreeS,xM,'K',2*theiler+2);
            idxV = NaN(nvec,1);
            distV = NaN(nvec,1);
            for ivec = 1:nvec
                i1 = max(ivec-theiler,1);
                i2 = min(ivec+theiler,nvec);
                ineiV = find(neiindM(ivec,:)<i1 | neiindM(ivec,:)>i2); 
                inei = ineiV(1);
                idxV(ivec) = neiindM(ivec,inei);
                distV(ivec) = neidisM(ivec,inei);
            end
        end
        iV = find(distV< rthresmax*sqrt(m));
        if isempty(iV)
            nextm = 0;
        else
            nproper = length(iV);
        end
        % Compute fnn only if there is a sufficient number of target points 
        % having nearest neighbor (in R^m) withing the threshold distance
        if nproper>propthres*nvec
            nnfactorV = 1+(xV(iV+m*tau)-xV(idxV(iV)+m*tau)).^2./distV(iV).^2;
            fnnM(itau,im) = length(find(nnfactorV > escape^2))/nproper;
        end
        im = im+1;
    end
end
