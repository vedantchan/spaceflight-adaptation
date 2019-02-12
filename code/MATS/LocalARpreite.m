function [mapeT,nmseT,nrmseT,ccT] = LocalARpreite(xV,fraction,tauV,mV,nneiV,q,TV)
% [mapeT,nmseT,nrmseT,ccT] = LocalARpreite(xV,fraction,tauV,mV,nneiV,q,TV)
% LOCALARPREITE makes iterative predictions with a local model on a test set
% given by the last part of the given time series 'xV' (as the 'fraction' 
% porportion of 'xV').A number of input parameters determine the local 
% model. For each parameter multiple values can be given (the input  
% parameter can have a vector form) and the fitting is done for each one
% independently.  
% The state space reconstruction is done with the method of delays and the 
% parameters are the embedding dimension 'm' (component of 'mV') and the 
% delay time 'tau' (component of 'tauV'). The first target point is for 
% the time index 'n-nlast' (where nlast=fraction*n and 'n' is the length 
% of 'xV'), i.e. the reconstruction uses samples from the training set of 
% length 'n-nlast'. 
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
% - factor   : The fraction of last samples of 'xV' to form the test set.
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
% - mapeT   : The Mean Absolute Percentage Error for predicted and real values.
%             A matrix of dimension 4 and size (ntau+1)x(nm+1)x(nnnei+1)x(nT+1)
%             where ntau=length(tauV), nm=length(mV), nnnei=length(nneiV) 
%             and nT = length(TV). 
% - nmseT   : The normalized mean square error for predicted and real
%             values. The matrix has size as for mapeT. 
% - nrmseT  : The normalized root mean square error for predicted and real
%             values. The matrix has size as for mapeT. 
% - ccT     : The correlation coefficient between predicted and real
%             values. The matrix has size as for mapeT.
% 
%========================================================================
%     <LocalARpreite.m>, v 1.1 2019/01/13 Kugiumtzis & Tsimpiris
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
 
if nargin == 6
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
n1 = round((1-fraction)*n);
nlast = n-n1; % The size of the test set

mapeT = NaN*ones(ntau,nm,nnnei,nT); 
nmseT = NaN*ones(ntau,nm,nnnei,nT); 
nrmseT = NaN*ones(ntau,nm,nnnei,nT); 
ccT = NaN*ones(ntau,nm,nnnei,nT); 

for itau=1:ntau
    tau = tauV(itau);
    for im=1:nm
        m = mV(im);
        if nlast>=n-2*m*tau || n1<2*((m-1)*tau-Tmax)
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
            n1vec = n1-(m-1)*tau-1;
            xM = NaN*ones(n1vec,m);
            for i=1:m
                xM(:,m-i+1) = xV(1+(i-1)*tau:n1vec+(i-1)*tau);
            end
            kdtreeS = KDTreeSearcher(xM); % k-d-tree data structure of the 
                % training set. For each target point, find neighbors, 
                % apply the local state space model for each time step 
                % ahead T. 
            ntar = nlast-Tmax+1;
            preM = NaN*ones(ntar,Tmax);
            winnowM = NaN*ones(ntar,(m-1)*tau+1);
            ifirst = n1-(m-1)*tau;
            for i=1:(m-1)*tau+1
                winnowM(:,i) = xV(ifirst+(i-1):ifirst+ntar-1+(i-1));
            end
            for T = 1:Tmax
                targM = winnowM(:,end:-tau:end-(m-1)*tau);
                neiindM=knnsearch(kdtreeS,targM,'K',nnei);
                for i=1:ntar
                    neiM = xM(neiindM(i,:),:);
                    yV = xV(neiindM(i,:)+(m-1)*tau+1);
                    if q==0 || nnei==1
                        preM(i,T) = mean(yV);
                    else
                        mneiV = mean(neiM);
                        my = mean(yV);
                        zM = neiM - ones(nnei,1)*mneiV;
                        [Ux, Sx, Vx] = svd(zM, 0);
                        tmpM = Vx(:,1:q) * inv(Sx(1:q,1:q)) * Ux(:,1:q)';
                        lsbV = tmpM * (yV - my);
                        preM(i,T) = my + (targM(i,:)-mneiV) * lsbV;
                    end
                end  
                winnowM = [winnowM preM(:,T)];
            end % for T
            preM = [[n1:n-Tmax];preM']'; %Add the target point index before the iterative predictions
            for iT=1:nT
                T = TV(iT);
                tarV = xV(preM(:,1)+T);
                prenowV = preM(:,T+1);
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
