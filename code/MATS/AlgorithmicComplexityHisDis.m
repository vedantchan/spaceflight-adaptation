function acV=AlgorithmicComplexityHisDis(xV,bV)
% acV = AlgorithmicComplexityHisDis(xV,bV)
% ALGORITHMICCOMPLEXITYHISDIS computes the algorithmic complexity on the
% time series 'xV'. The estimation of the algorithmic complexity is based
% on 'b' partitions of equal distance of 'xV'. 
% A number of different 'b' can be given in the input vector 'bV'.
% INPUT
% - xV      : a vector for the time series
% - bV      : a vector of the number of equidistant partitions. 
% OUTPUT
% - acV     : the vector of the algorithmic complexity values for the given
%             delays. 
%========================================================================
%     <AlgorithmicComplexityHisDis.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
n = length(xV);
if nargin==1
    bV = round(sqrt(n/5));
end
bV(bV==0) = round(sqrt(n/5));

nb = length(bV);
xmin=min(xV);
xrange=range(xV);
acV = NaN*ones(nb,1);
for ib=1:nb
    parxM = [];
    cel=[];
    b = bV(ib);
    if n<2*b
        break;
    end
    if b==1
        continue;
    end
    dV=[1:b]*xrange/b;
    dV=[0-xrange*10^(-6) dV+xrange*10^(-6)];
    dV=xmin+dV;
    for i=1:b
        parxM(i,:)=i*(xV>=dV(i) & xV<=dV(i+1));
    end
    symb=sum(parxM);
    symbc=char(symb+64);
    oo=max(symb);
    cel{1}=symbc(1);
    i=2;
    while i~=n+1
        pro=symbc(i);
        while sum(ismember(cel,pro))~=0 & i~=n
            i=i+1;
            prot=symbc(i);
            pro=[pro prot];
        end
        cel=union(cel,pro);
        if i~=n+1
           i=i+1;
        end
    end
    dic=length(cel);
    acV(ib)=(dic*log10(n))/(log10(b)*n);
end
