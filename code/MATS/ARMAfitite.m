function [mapeT,nmseT,nrmseT,ccT,flagtxt] = ARMAfitite(xV,mV,pV,TV)
% [mapeT,nmseT,nrmseT,ccT,flagtxt] = arfitite(xV,mV,pV,TV)
% ARMAFITITE computes statistical errors of fit at lead times given in 'TV' 
% with each of a number of ARMA models of AR orders given in 'mV' and MA 
% orders given in 'pV' on a time series 'xV'. The iterative prediction
% scheme is utilized. 
% The different fit error statistics given to the output have size 
% nm x np x nT, wherre nT is the length of 'TV', 'np' is the length of 'pV'
% and 'nm' is the length of  'mV'. 
% INPUT
% - xV      : The time series to be modelled, a column vector
% - mV      : The vector of different orders of the AR part of the model
% - pV      : The vector of different orders of the MA part of the model
% - T       : The time step ahead for fitting the ARMA-model (if omitted,
%             default is T=1)
% OUTPUT
% - mapeT   : The Mean Absolute Percentage Error for fitted and real values.
%             A tensor matrix of size nm x np x nT. 
% - nmseT   : The normalized mean square error for fitted and real values.
%             A tensor matrix of size nm x np x nT. 
% - nrmseT  : The normalized root mean square error for fitted and real values
%             A tensor matrix of size nm x np x nT. 
% - ccT     : The correlation coefficient between fitted and real values
%             A tensor matrix of size nm x np x nT. 
% - flagtxt : A string of error message in case the AR matlab functions are
%             not supported by user's matlab product (missing toolbox).
%========================================================================
%     <ARMAfitite.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
n = length(xV);           % Choose length of time series
nm = length(mV);
np = length(pV);
nT = length(TV);
mapeT = NaN*ones(nm,np,nT); 
nmseT = NaN*ones(nm,np,nT); 
nrmseT = NaN*ones(nm,np,nT); 
ccT = NaN*ones(nm,np,nT); 
flagtxt = [];

for im=1:nm
    m = mV(im);
    for ip=1:np
        p = pV(ip);
        if n<2*(m+p)+max(TV)
            break;
        end
        if exist('armax')==2
            armamod = armax(xV,[m p]);
        else
            flagtxt = 'You need to add toolbox ''ident'' to be able to run measures of ARMA fitting.';
            return;
        end
        for iT=1:nT
            T = TV(iT);
            xpreV = predict(xV,armamod,T);
            xpreV = xpreV{1};
            iV = [max(max(1,m-p+1),T):n];
            mtar = mean(xV(iV));
            vartar = var(xV(iV));
            mapeT(im,ip,iT) = mean(abs((xV(iV)-xpreV(iV))./xV(iV)));
            nmseT(im,ip,iT) = mean((xV(iV)-xpreV(iV)).^2) / vartar;
            nrmseT(im,ip,iT) = sqrt(nmseT(im,ip,iT));
            mxpre = mean(xpreV(iV));
            ntar = length(iV);
            ccT(im,ip,iT) = sum((xpreV(iV)-mxpre).*(xV(iV)-mtar)) / sqrt((ntar-1)*vartar*(sum(xpreV(iV).^2)-ntar*mxpre^2));
        end
    end
end

