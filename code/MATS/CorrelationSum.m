function corsumT = CorrelationSum(xV,rV,tauV,mV,theiler)
% corsumT = CorrelationSum(xV,rV,tauV,mV,theiler)
% CORRELATIONSUM computes the correlation on a given time series 'xV' for a  
% number of radius in 'rV' and state space reconstructions with delays in
% 'tauV' and embedding dimensions in 'mV'. The parameter 'theiler' excludes
% temporally close points (smaller than 'theiler') from the inter-distance 
% computations.
% INPUT 
% - xV      : Vector of the scalar time series
% - rV      : A vector of the radius (assuming first that 'xV' is
%             standardized in [0,1]).
% - tauV    : A vector of the delay times.
% - mV      : A vector of the embedding dimension.
% - theiler : the Theiler window to exclude time correlated points in the
%             search for neighboring points. Default=0.
% OUTPUT: 
% - corsumT : A matrix of size 'nr' x 'ntau' x 'nm', where 'nr' is the 
%             number of given radius, 'ntau' is the number of given delays 
%             and 'nm' is the number of given embedding dimensions. The
%             components of the matrix are the correlation sum values.
%========================================================================
%     <CorrelationSum.m>, v 1.1 2019/01/13 Kugiumtzis & Tsimpiris
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

n = length(xV);
if isempty(theiler), theiler=0; end
% Rescale to [0,1]
xmin = min(xV);
xmax = max(xV);
xV = (xV - xmin) / (xmax-xmin);
nr = length(rV);
ntau = length(tauV);
nm = length(mV);
corsumT = NaN*ones(nr,ntau,nm);
for ir=1:nr
    r = rV(ir);
    for itau = 1:ntau
        tau = tauV(itau);
        for im=1:nm
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
            % For each target point, find the set points at a distance    
            % smaller than the radius, and save the set cardinality.
            countV = NaN*ones(nvec,1);
            neiindC = rangesearch(kdtreeS,xM,sqrt(m)*r);
            for i=1:nvec
                neiindV = neiindC{i};
                countV(i)=length(find(abs(i-neiindV(2:end))>theiler));
            end
            corsumT(ir,itau,im) = sum(countV)/(2*sum(nvec-theiler-...
                [1:theiler])+(nvec-2*theiler)*(nvec-2*theiler-1));
        end
    end
end