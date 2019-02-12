function [mapeT,nmseT,nrmseT,ccT] = LocalARfitdir(xV,tauV,mV,nneiV,q,TV)
% [mapeT,nmseT,nrmseT,ccT] = LocalARfitdir(xV,tauV,mV,nneiV,q,TV)
% LOCALARFITDIR makes in-sample direct predictions with a local model on a
% given time series 'xV'. A number of input parameters determine the local 
% model. For each parameter multiple values can be given (the input  
% parameter can have a vector form) and the fitting is done for each one
% independently. 
% The state space reconstruction is done with the method of delays and the 
% parameters are the embedding dimension 'm' (component of 'mV') and the 
% delay time 'tau' (component of 'tauV'). The first target point is for 
% the time index '1+(m-1)*tau' and the last is for the time 'n-Tmax', where 
% 'n' is the length of the time series and 'Tmax' is the largest prediction
% time in 'TV'.
% The local prediction model is one of the following:
% Ordinary Least Squares, OLS (standard local linear model): if the 
% truncation parameter 'q' is q >= m
% Principal Component Regression, PCR, project the parameter space of the 
% model to only 'q' of the m principal axes: if 0<q<m
% Local Average Mapping, LAM: if q=0.
% The local region is determined by the number of neighbours 'nnei' 
% (component of 'nneiV') formed from the training set. The k-d-tree data 
% structure is utilized to speed up computation time in the search of 
% neighboring points. 
% The distance is computed using the Euclidean (L2) norm.
% INPUTS:
% - xV       : The vector of the scalar time series
% - tauV     : A vector of delay times
% - mV       : A vetcor of embedding dimensions.
% - nneiV    : A vector of the number of neighboring points to support the
%              local model. 
% - q        : The truncation parameter for a normalization of the local
%              linear model (to project the parameter space of the model, 
%              using Principal Component Regression, PCR, locally).
%             if q>=m -> Ordinary Least Squares, OLS (standard local linear
%                        model,no projection)
%             if 0<q<m -> PCR(q)
%             if q=0 -> local average model
% - TV       : A vector of the prediction times.
% OUTPUT: 
% - mapeT   : The Mean Absolute Percentage Error for fitted and real values.
%             A matrix of dimension 4 and size
%             (ntau+1)x(nm+1)x(nnnei+1)x(nT+1) where ntau=length(tauV),
%             nm=length(mV), nnnei=length(nneiV) and nT = length(TV). 
% - nmseT   : The normalized mean square error of the fit for fitted and
%             real values. The matrix has size as for mapeT.
% - nrmseT  : The normalized root mean square error of the fit for fitted
%             and real values. The matrix has size as for mapeT. 
% - ccT     : The correlation coefficient between fitted and real values.
%             The matrix has size as for mapeT. 
%
%========================================================================
%     <LocalARfitdir.m>, v 1.1 2019/01/13 Kugiumtzis & Tsimpiris
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

if nargin == 5
    TV = 1;
end
tauV=tauV(:);
mV=mV(:);
nneiV=nneiV(:);
TV=TV(:);
TV = sort(TV);
ntau = length(tauV);
nm = length(mV);
nnnei = length(nneiV);
Tmax = max(TV);
nT = length(TV);
n = length(xV); 

mapeT = NaN*ones(ntau,nm,nnnei,nT); 
nmseT = NaN*ones(ntau,nm,nnnei,nT); 
nrmseT = NaN*ones(ntau,nm,nnnei,nT); 
ccT = NaN*ones(ntau,nm,nnnei,nT); 

for itau=1:ntau
    tau = tauV(itau);
    for im=1:nm
        m = mV(im);
        if n<2*((m-1)*tau-Tmax)
            break;
        end
        for innei=1:nnnei
            nnei = nneiV(innei);
            % The solution for the model parameters is in the space of 
            % dimension 'q' (if q>0), so 'q' has to be smaller or equal
            % than the rank of the predictor matrix of size nnei x m.
            qnow = min([q m]); 
            if nnei>1 && m>=nnei && qnow>=nnei
                continue;
            end
            nvec = n-(m-1)*tau-Tmax;
            xM = NaN*ones(nvec,m);
            for i=1:m
                xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
            end
            kdtreeS = KDTreeSearcher(xM); % k-d-tree data structure of the 
                % training set. For each target point, find neighbors, 
                % apply the local state space model for each time step 
                % ahead T. 
            preM = NaN*ones(nvec,nT);
            neiindM=knnsearch(kdtreeS,xM,'K',nnei+1);
            neiindM(:,1) = [];
            for i=1:nvec
                neiM = xM(neiindM(i,:),:);
                xpreM = NaN*ones(nnei,nT);
                for inei=1:nnei
                    xpreM(inei,:)=xV(neiindM(i,inei)+(m-1)*tau+TV);
                end
                if nnei==1
                    xpreV = xpreM';
                elseif q==0
                    xpreV = (mean(xpreM))';
                else
                    mneiV = mean(neiM);
                    myV = mean(xpreM);
                    zM = neiM - ones(nnei,1)*mneiV;
                    [Ux, Sx, Vx] = svd(zM, 0);
                    tmpM = Vx(:,1:q) * inv(Sx(1:q,1:q)) * Ux(:,1:q)';
                    for j=1:nT
                        lsbV = tmpM * (xpreM(:,j) - myV(j));
                        xpreV(j) = myV(j) + (xM(i,:)-mneiV) * lsbV;
                    end
                end
                preM(i,:) = xpreV';
            end
            preM = [[1:nvec]+(m-1)*tau;preM']'; %Add the target point index 
                                         % before the iterative predictions
            for iT=1:nT
                T = TV(iT);
                tarV = xV(preM(:,1)+T);
                prenowV = preM(:,iT+1);
                ntar = length(tarV);
                mtar = mean(tarV);
                vartar = var(tarV);
                mapeT(itau,im,innei,iT) = mean(abs((tarV-prenowV)./prenowV));
                nmseT(itau,im,innei,iT) = mean((tarV-prenowV).^2) / vartar;
                nrmseT(itau,im,innei,iT) = sqrt(nmseT(itau,im,innei,iT));
                mxpre = mean(prenowV);
                ccT(itau,im,innei,iT) = sum((prenowV-mxpre).*(tarV-mtar))...
                    / sqrt((ntar-1)*vartar*(sum(prenowV.^2)-ntar*mxpre^2));
            end
        end
    end
end
