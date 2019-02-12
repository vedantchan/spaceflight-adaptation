function mutV=mutinfHisDis(yV,tauV,b,imax)
% mutV=mutinfHisDis(yV,tauV,b)
% mutinfHisDis computes the mutual information on the time series 'yV' 
% for given delays in 'tauV'. The estimation of mutual information is 
% based on 'b' partitions of equal distance at each dimension. 
% The last input parameter is the index of the maximum of the time series
% that will be assigned the largest bin index (a technical detail).
%========================================================================
%     <mutinfHisDis.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
n = length(yV);
ntau = length(tauV);
mutV = NaN*ones(ntau,1);
h1V = zeros(b,1);  % for p(x(t+tau))
h2V = zeros(b,1);  % for p(x(t))
h12M = zeros(b,b);  % for p(x(t+tau),x(t))
arrayV = floor(yV*b)+1; % Array of b: 1,...,b
arrayV(imax) = b; % Set the maximum in the last partition
for itau=1:ntau
    tau = tauV(itau);
    ntotal = n-tau;
    mutS = 0;
    for i=1:b
        for j=1:b
            h12M(i,j) = length(find(arrayV(tau+1:n)==i & arrayV(1:n-tau)==j));
        end
    end
    for i=1:b
        h1V(i) = sum(h12M(i,:));
        h2V(i) = sum(h12M(:,i));
    end
    for i=1:b
        for j=1:b
            if h12M(i,j) > 0
                mutS=mutS+(h12M(i,j)/ntotal)*log(h12M(i,j)*ntotal/(h1V(i)*h2V(j)));
            end
        end
    end
    mutV(itau) = mutS;
end
