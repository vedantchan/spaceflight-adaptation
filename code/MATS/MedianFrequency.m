function [MedFreq,errormsg] = MedianFrequency(xV,leftcutoff,rightcutoff)
% [MedFreq,errormsg] = MedianFrequency(xV,leftcutoff,rightcutoff)
% MEDIANFREQUENCY2 computes the median frequency in a frequency range given 
% by 'leftcutoff' and 'rightcuroff' for a given time series 'xV'. 
% The standard periodogram is called to compute the power spectrum assuming 
% frequency=1, so that the largest frequency the power spectrum is computed 
% for is 0.5 if 'rightcuroff' is specified. The lower frequency is given 
% by 'leftcutoff' or 0 if 'leftcutoff' is not specified. The frequency 
% resolution is given by the length of the time series. 
% INPUT 
% - xV      : the given time series
% - leftcutoff: the left cutoff of frequency (to avoid the effect of drifts 
%               in the signal).
% - rightcutoff: the right cutoff of frequency (to avoid the effect of  
%                high frequency elements in the signal).
% OUTPUT
% - MedFreq : The median frequency
% - errormsg: a string of error message in case output cannot be generated.
%========================================================================
%     <MedianFrequency.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
if nargin==2
    rightcutoff = 0.5;
elseif nargin==1
    rightcutoff = 0.5;
    leftcutoff = 0.0;
end
errormsg = [];
[psV,freqV]=periodogram(xV); 
freqV = freqV / (2*pi);   % Corrected, thanks to Robert Reijntjes, Leiden University Medical Centre
MedFreq = [];
if length((find(isnan(psV))))==0
    d=length(psV(find(freqV<leftcutoff)));
    op=find(cumsum(psV(find(freqV>=leftcutoff)))>0.5*sum(psV(find(freqV>=leftcutoff & freqV<=rightcutoff))));
    if length(op)>0
        MedFreq=freqV(op(1)+d);
    end
else
    errormsg = 'The periodogram could not be computed or cutoff values are not proper.';
end
