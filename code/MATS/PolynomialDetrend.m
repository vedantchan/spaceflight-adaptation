function [yM,poldegreeV] = PolynomialDetrend(xV,poldegreeV)
% yV = PolynomialDetrend(xV,poldegree)
% POLYNOMIALDETREND takes a time series 'xV' and fits polynomials of 
% given degree in 'poldegreeV'. The residual time series of the fits are
% given to the output as the detrended time series. 
% INPUTS:
% - xV      : vector of a scalar time series
% - poldegreeV : vector of polynomial degrees (can be a single degree as well)
% OUTPUTS:
% - yM      : a matrix of the detrended time series.
% - poldegreeV : the vector of valid polynomial degrees (in case given degrees are <=0)
%========================================================================
%     <PolynomialDetrend.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
poldegreeV = poldegreeV(poldegreeV>=0 & poldegreeV<n/2);
if isempty(poldegreeV) 
    yM=[];
else
    npoldegree = length(poldegreeV);
    yM = NaN*ones(n,npoldegree);
    for ipoldegree=1:npoldegree
        poldegree=poldegreeV(ipoldegree);
        if poldegree==0
            yM(:,ipoldegree) = xV-mean(xV);
        else
            parV = polyfit([1:n]',xV,poldegree);
            yM(:,ipoldegree) = xV - polyval(parV,[1:n]');
        end
    end
end
