function [zM,errormsg] = STAPsur(xV, pol, arm, nsur)
% [zM,errormsg] = STAPsur(xV, pol, arm, nsur)
% STAP: Statically Transformed Autoregressive Process (STAP) surrogates
% STAP generates stochastic surrogates for a given time series as 
% statically transformed realisations of a Gaussian (autoregressive) 
% process. The generated surrogate data have the same amplitude 
% distribution (marginal cdf) and autocorrelation as the original time 
% series.
% The IAAFT algorithm is proposed in 
% Kugiumtzis D (2002) "Surrogate Data Test for Nonlinearity using 
% Statically Transformed Autoregressive Process", Physical Review E.
% INPUT
% - xV  : the given time series
% - pol	: degree of the polynomial to approximate the sample transform
% - arm : order of the AR model to generate the Gaussian time series
% - nsur: the number of surrogate time series (default is 1)
% OUTPUT
% - zM  : the n x nsur matrix of 'nsur' STAP surrogate time series
% - errormsg : a message for the error occured while running STAP. Note 
%              that the roots of the characteristic polynomial for the AR
%              process may not always give stable AR model, especially when
%              the order of the AR model is high.
%========================================================================
%     <STAPsur.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 

ntrans = 100; % transient steps for the generation of Gaussian time series
if nargin==3
    nsur = 1;
end
n = length(xV);
if n<2*pol | n<2*arm
    return;
end

[oxV,ixV] = sort(xV);
r_xV = xcorr(xV-mean(xV),arm,'coeff');
r_xV(1:arm) = [];  % the autocorrelation of xV
FxV = ([1:n]'-0.326)/(n+0.348); % The position plotting transform
owV = norminv(FxV);

%%% Unconstrained polynomial approximation (OLS) of the sample transform
pwxV = polyfit(owV,oxV,pol);
pwxV = pwxV(:);
[invr_xM,cV] = invtranscorcoef(r_xV,flipud(pwxV));
%%% The polynomial transform for autocorrelations
invr_xV = zeros(arm+1,1);
invr_xV(1) = r_xV(1);
for i=2:arm+1
    inowV = find(imag(invr_xM(i,:))==0 & abs(invr_xM(i,:))<=1);
    if length(inowV) == 1
        successflag=1;
        invr_xV(i) = invr_xM(i,inowV);
    else
        successflag=0;
        if length(inowV)>1
            errormsg = ['r_x(',int2str(i-1),') has ',int2str(length(inowV)),' solutions'];
        else   
            errormsg = ['r_x(',int2str(i-1),') has no solutions'];
        end
        break;
    end
end
%%%%% If a proper solution for r_u is found compute AR-parameters
if successflag == 1
    [bV,E]=levinson(invr_xV,arm);
    bV = bV(:);
    rootbV = roots(bV);
    if any(abs(rootbV) >= 1)
        bV = polystab(bV);
        bV = bV(:);
%        disp(['Root(s) > 1, polystab'])
        if any(abs(roots(bV)) >= 1)
            successflag = 0;
            errormsg = ['Root(s) > 1, no solution'];
        end
    end
end
%%%%% If a proper AR model is found generate the surrogate time series
if successflag == 1
    errormsg = [];
    zM = zeros(n,nsur);
    uM = zeros(n,nsur);
    for isur=1:nsur
        uV = zeros(n+arm+ntrans,1);
        uV(1:arm) = randn(arm,1);
        for j=arm+1:n+arm+ntrans
            uV(j) = - bV(2:arm+1)' * uV(j-1:-1:j-arm) + randn;
        end
        uV = uV(arm+ntrans+1:n+arm+ntrans);
        [T,iuV] = sort(uV);
        [T,juV] = sort(iuV);
        zM(:,isur) = oxV(juV); 
        uM(:,isur) = uV; 
    end
end
