function Hurst=HurstExponent(xV)
% Hurst=HurstExponent(xV)
% HURSTEXPONENT computes the Hurst exponent for a given time series 'xV'.
% INPUTS:
% - xV          : The given scalar time series (vector of size n x 1).
% OUTPUTS
% - Hurst       : The value of the Hurst exponent.
%========================================================================
%     <HurstExponent.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
n=length(xV);
d=[];
len=[];
y=xV;
y2=cumsum(y-mean(y),1);
d(1)=mean(range(y2)./std(y,1));
i=1;
len(1)=size(y,1);
while size(y,1)>=16
    i=i+1;
    rnr=floor(n/(2^(i-1)));
    rnc=floor(n/rnr);
    y=reshape(xV(1:rnr*rnc),rnr,rnc);
    n2=size(y,1);
    pop=find(std(y,1)~=0);     %
    if ~isempty(pop)
        y=y(:,pop);                %
        len(i)=n2;
        y2=cumsum(y-kron(mean(y),ones(n2,1)),1);
        d(i)=mean(range(y2)./std(y,1));
    else
        len(i) = NaN;
        d(i)=NaN;
    end
end
dlog=log2(d(end:-1:1));
blog=log2(len(end:-1:1));
pone=polyfit(blog,dlog,1);
Hurst=pone(1);
