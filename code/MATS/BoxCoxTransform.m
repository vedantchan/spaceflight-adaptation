function yM = BoxCoxTransform(xV,lambdaV)
% yV = BoxCoxTransform(xV,lambda)
% BOXCOXTRANSFORM takes a time series 'xV' and applies the Box Cox power
% transform for given parameter lambda in 'lambdaV'.
% INPUTS:
% - xV      : vector of a scalar time series
% - lambdaV : vector of lambda values (can be a single lambda as well)
% OUTPUTS:
% - yM      : a matrix of the Box-Cox transformed time series.
%========================================================================
%     <BoxCoxTransform.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
xV = xV(:);
n = length(xV);
if isempty(lambdaV) 
    yM=[];
else
    nlambda = length(lambdaV);
    yM = NaN*ones(n,nlambda);
    for ilambda=1:nlambda
        lambda=lambdaV(ilambda);
        if lambda==0
            xmin = min(xV);
            if xmin<=0
                xV = xV-xmin+1;
            end
            yM(:,ilambda) = log(xV);
        else
            yM(:,ilambda) = (xV.^lambda-1)/lambda;
        end
    end
end