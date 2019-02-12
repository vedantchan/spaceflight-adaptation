function [mapeT,nmseT,nrmseT,ccT,flagtxt] = ARMApreite(xV,fraction,mV,pV,TV)
% [mapeT,nmseT,nrmseT,ccT,flagtxt] = ARMApreite(xV,fraction,mV,pV,TV)
% ARMAPREITE computes statistical errors of prediction at lead times given
% in 'TV' with each of a number of ARMA models of AR orders given in 'mV'
% and MA orders given in 'pV' on a time series 'xV'. The iterative
% prediction scheme is utilized. 
% The different prediction error statistics given to the output have size 
% nm x np x nT, wherre nT is the length of 'TV', 'np' is the length of 'pV'
% and 'nm' is the length of  'mV'. 
% INPUT
% - xV      : The time series to be modelled, a column vector
% - fraction: A number in [0.1,0.9] that determines the length of the test
%             set as 'fraction x n' where 'n' is the length of 'xV'.
% - mV      : The vector of different orders of the AR part of the model
% - pV      : The vector of different orders of the MA part of the model
% - T       : The time step ahead for predicting the ARMA-model (if omitted,
%             default is T=1)
% OUTPUT
% - mapeT   : The Mean Absolute Percentage Error for predicted and real values.
%             A tensor matrix of size nm x np x nT. 
% - nmseT   : The normalized mean square error for predicted and real values.
%             A tensor matrix of size nm x np x nT. 
% - nrmseT  : The normalized root mean square error for predicted and real values
%             A tensor matrix of size nm x np x nT. 
% - ccT     : The correlation coefficient between predicted and real values
%             A tensor matrix of size nm x np x nT. 
% - flagtxt : A string of error message in case the AR matlab functions are
%             not supported by user's matlab product (missing toolbox).
%========================================================================
%     <ARMApreite.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
if nargin == 3
    TV = 1;
end
mV=mV(:);
pV=pV(:);
TV=TV(:);
nm = length(mV);
np = length(pV);
nT = length(TV);
mapeT = NaN*ones(nm,np,nT); 
nmseT = NaN*ones(nm,np,nT); 
nrmseT = NaN*ones(nm,np,nT); 
ccT = NaN*ones(nm,np,nT); 
flagtxt = [];

n = length(xV);
n1 = round((1-fraction)*n);
n2 = n-n1;
x1V = xV(1:n1);
x2V = xV(n1+1:n);

for im=1:nm
    m = mV(im);
    for ip=1:np
        p = pV(ip);
        if n1<2*(m+p)+max(TV)
            break;
        end
        if exist('armax')==2
            armamod = armax(x1V,[m p]);
        else
            flagtxt = 'You need to add toolbox ''ident'' to be able to run measures of ARMA fitting.';
            return;
        end
        for iT=1:nT
            T = TV(iT);
            xpreV = predict(x2V,armamod,T);
            xpreV = xpreV{1};
            iV = [max(max(1,m-p+1),T):n2];
            mtar = mean(x2V(iV));
            vartar = var(x2V(iV));
            mapeT(im,ip,iT) = mean(abs((x2V(iV)-xpreV(iV))./x2V(iV)));
            nmseT(im,ip,iT) = mean((x2V(iV)-xpreV(iV)).^2) / vartar;
            nrmseT(im,ip,iT) = sqrt(nmseT(im,ip,iT));
            mxpre = mean(xpreV(iV));
            ntar = length(iV);
            ccT(im,ip,iT) = sum((xpreV(iV)-mxpre).*(x2V(iV)-mtar)) / sqrt((ntar-1)*vartar*(sum(xpreV(iV).^2)-ntar*mxpre^2));
        end
    end
end
