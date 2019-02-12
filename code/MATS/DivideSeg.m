function xM = DivideSeg(xV,n,s,first)
% xM = DivideSeg(xV,n,s,first)
% DIVIDESEG takes a time series 'xV' and splits in segments of length 'n'. 
% The segments either overlap if 's' is smaller than 'n' or not (otherwise).
% If the length of 'xV' is not multiple of 'n', then the remainder segment 
% is omitted either from the beginning of 'xV' when 'first' is 1, or from
% the end (otherwise).
% INPUTS:
% - xV      : vector of a scalar time series
% - n       : length of each of the segments splitting 'xV'.
% - s       : the sliding window if 0<s<n, otherwise use consecutive
%             segments. Defaults is n. 
% - first   : if 1, ignore the remainder segment (only if length(xV) is not
%             multiple of n) from the beginning of 'xV', otherwise from the
%             end of 'xV'. Default is 1.
% OUTPUTS:
% - xM      : a matrix of size n x floor(length(xV)/n) of the segments.

% Give default values to input variables if not set
%========================================================================
%     <DivideSeg.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
    first = 1;
elseif nargin == 2
    first = 1;
    s = n;
end
if isempty(first), first=1; end
if isempty(s), s=n; end
if s<=0 | s>n, s=n; end

nbig = length(xV);
if n>nbig
    return;
end

% Make splitting if no-overlapping is given and then when 0<s<n
if s==n
    nseg = floor(nbig / n);
    nrest=nbig - nseg*n;
    if nrest>0
        switch first
            case 1
                xV = xV(1+nrest:nbig);
            otherwise
                xV = xV(1:nbig-nrest);
        end
    end
    xM = reshape(xV,n,nseg);
else
    nseg = floor((nbig-n)/s)+1;
    nrest = nbig - (n+(nseg-1)*s);
    if nrest>0
        switch first
            case 1
                xV = xV(1+nrest:nbig);
            otherwise
                xV = xV(1:nbig-nrest);
        end
    end
    xM = NaN*ones(n,nseg);
    for iseg=1:nseg
        xM(:,iseg)=xV(1+(iseg-1)*s:n+(iseg-1)*s);
    end
end
    