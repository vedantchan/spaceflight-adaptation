function [zM,flagtxt] = AMRBootstrap(xV,arm,nsur)
% [zM,flagtxt] = AMRBootstrap(xV,arm,nsur)
% ARMB : Autoregressive Model Residual Bootstrap 
% AMRBOOTSTRAP generates 'nsur' surrogate data for the given time series 'xV' 
% using an estimated AR model and bootstrapping the residuals of the
% model. The order 'm' of AR is found by AIC calculated for p=1,...,arm.
% INPUT
% - xV  : the given time series
% - arm : order of the AR model to generate the bootstrap time series
% - nsur: the number of surrogate time series (default is 1)
% OUTPUT
% - zM  : the n x nsur matrix of 'nsur' ARMB surrogate time series
% - flagtxt : A string of error message in case the AR matlab functions are
%             not supported by user's matlab product (missing toolbox).
%========================================================================
%     <AMRBootstrap.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
ntrans = 100;
if nargin==2
    nsur = 1;
end
n = length(xV);
mx = mean(xV);
yV = xV-mx;
zM = NaN*ones(n,nsur);
flagtxt = [];
if n<2*arm
    return;
end
if exist('armcov')==2
    [a,e]=armcov(yV,1);
    aold = a;
    aicold = log(e)+2*1/n;
elseif exist('ar')==2
    armod = ar(yV,1); 
    aold = armod.a;
    aicold = log(armod.noise)+2*1/n;
else
    flagtxt = 'You need to add toolbox ''ident'' or ''signal'' to be able to run AR-boot surrogates.';
    return;
end
p=2;
pfound = 'n';
while p<=arm & pfound=='n'
    if exist('armcov')==2
        [a,e]=armcov(yV,p);
        anew = a;
        aicnew = log(e)+2*p/n;
    else
        armod = ar(yV,p); 
        anew = armod.a;
        aicnew = log(armod.noise)+2*p/n;
    end
    if aicnew > aicold
        pfound = 'y';
    else
        p=p+1;
        aold = anew;
        aicold = aicnew;
    end
end
bV = -aold(2:end);
bV = bV(:);
p = length(bV);
yM = NaN*ones(n-p,p);
for i=1:p
    yM(:,i) = yV(p-i+1:n-i);
end
eV = yV(p+1:n) - yM*bV;

for isur=1:nsur
    zV = NaN*ones(n+p+ntrans,1);
    zV(1:p) = yV(unidrnd(n,p,1));
    for j=p+1:n+p+ntrans
        zV(j) = bV' * zV(j-1:-1:j-p) + eV(unidrnd(n-p));
    end
    zV = zV(p+ntrans+1:n+p+ntrans);
    zM(:,isur) = zV+mx;
end
