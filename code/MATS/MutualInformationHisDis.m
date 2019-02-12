function [mutM,cummutM,minmuttauV] =  MutualInformationHisDis(xV,tauV,bV,flag)
% [mutM,cummutM,minmuttauV] =  MutualInformationHisDis(xV,tauV,bV,flag)
% MUTUALINFORMATIONHISDIS computes the mutual information on the time
% series 'xV' for given delays in 'tauV'. The estimation of mutual
% information is based on 'b' partitions of equal distance at each dimension. 
% A number of different 'b' can be given in the input vector 'bV'.
% According to a given flag, it can also compute the cumulative mutual 
% information for each given lag, as well as the time of the first minimum 
% of the mutual information.
% INPUT
% - xV      : a vector for the time series
% - tauV    : a vector of the delays to be evaluated for
% - bV      : a vector of the number of partitions of the histogram-based
%             estimate. 
% - flag    : if 0-> compute only mutual information,
%           : if 1-> compute the mutual information, the first minimum of
%             mutual information and the cumulative mutual information. 
%             if 2-> compute (also) the cumulative mutual information
%             if 3-> compute (also) the first minimum of mutual information
% OUTPUT
% - mutM    : the vector of the mutual information values s for the given
%             delays. 
% - cummutM : the vector of the cumulative mutual information values for
%             the given delays 
% - minmuttauV : the time of the first minimum of the mutual information.
%========================================================================
%     <MutualInformationHisDis.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
%     This is part of the MATS-Toolkit http://eeganalysis.web.auth.gr/

%========================================================================
% Copyright (C) 2010 by Dimitris Kugiumtzis and Alkiviadis Tsimpiris 
%                       <dkugiu@gen.auth.gr>

%========================================================================
% Version: 1.0

% The FreeBSD Copyright:	
% Copyright 1992-2012 The FreeBSD Project. All rights reserved.	

% Redistribution and use in source and binary forms, with or without modification, 
% are permitted provided that the following conditions are met:	

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
% Reference : D. Kugiumtzis and A. Tsimpiris, "Measures of Analysis of Time Series (MATS): 
% 	          A Matlab  Toolkit for Computation of Multiple Measures on Time Series Data Bases",
%             Journal of Statistical Software, Vol. 33, Issue 5, 2010
% Link      : http://eeganalysis.web.auth.gr/
%========================================================================= 

 
nsam = 1;
n = length(xV);
if nargin==3
    flag = 1;
elseif nargin==2 
    flag = 1;
    bV = round(sqrt(n/5));
end
if isempty(bV)
    bV = round(sqrt(n/5));
end
bV(bV==0)=round(sqrt(n/5));
tauV = sort(tauV);
ntau = length(tauV);
taumax = tauV(end);
% Normalise the data
xmin = min(xV);
[xmax,imax] = max(xV);
xV(imax) = xmax + (xmax-xmin)*10^(-10); % To avoid multiple exact maxima
yV = (xV-xmin)/(xmax-xmin);
nb = length(bV);

switch flag
    case 0
        % Compute only the mutual information for the given lags
        mutM = NaN*ones(ntau,nb);
        for ib=1:nb
            b = bV(ib);
            if n<2*b
                break;
            end
            mutM(:,ib)=mutinfHisDis(yV,tauV,b,imax);
        end % for ib
        cummutM=[];
        minmuttauV=[];
    case 1
        % Compute the mutual information for all lags up to the
        % largest given lag, then compute the lag of the first minimum of
        % mutual information and the cumulative mutual information for the
        % given lags.
        mutM = NaN*ones(ntau,nb);
        cummutM = NaN*ones(ntau,nb);
        minmuttauV = NaN*ones(nb,1);
        miM = NaN*ones(taumax+1,nb);
        for ib=1:nb
            b = bV(ib);
            if n<2*b
                break;
            end
            miM(:,ib)=mutinfHisDis(yV,[0:taumax]',b,imax);
            mutM(:,ib) = miM(tauV+1,ib);
            minmuttauV(ib) = findminMutInf(miM(:,ib),nsam);
            % Compute the cumulative mutual information for the given delays
            for i=1:ntau
                cummutM(i,ib) = sum(miM(1:tauV(i)+1,ib));
            end
        end % for ib
    case 2
        % Compute the mutual information for all lags up to the largest 
        % given lag and then sum up to get the cumulative mutual information 
        % for the given lags.
        cummutM = NaN*ones(ntau,nb);
        miM = NaN*ones(taumax+1,nb);
        for ib=1:nb
            b = bV(ib);
            if n<2*b
                break;
            end
            miM(:,ib)=mutinfHisDis(yV,[0:taumax]',b,imax);
            % Compute the cumulative mutual information for the given delays
            for i=1:ntau
                cummutM(i,ib) = sum(miM(1:tauV(i)+1,ib));
            end
        end % for ib
        mutM = [];
        minmuttauV=[];
    case 3
        % Compute the mutual information for all lags up to the largest 
        % given lag and then compute the lag of the first minimum of the
        % mutual information.
        minmuttauV = NaN*ones(nb,1);
        miM = NaN*ones(taumax+1,nb);
        for ib=1:nb
            b = bV(ib);
            if n<2*b
                break;
            end
            miM(:,ib)=mutinfHisDis(yV,[0:taumax]',b,imax);
            minmuttauV(ib) = findminMutInf(miM(:,ib),nsam);
        end % for ib
        mutM = [];
        cummutM=[];
end