function [EbandV,freqV,psV,errormsg] = EnergyBand(xV,bandM,leftcutoff)
% [EbandV,freqV,psV,errormsg] = EnergyBand(xV,bandM,leftcutoff)
% ENERGYBAND computes the energy in the frequency band given by 'bandM' 
% for a given time series 'xV'. 
% The standard periodogram is called to compute the power spectrum assuming 
% frequency=1, so that the largest frequency the power spectrum is computed 
% for is 0.5. The lower frequency is given by 'leftcutoff'. The frequency 
% resolution is given by the length of the time series. The energy in the 
% given frequency band is simply the fraction of the sum of the values of 
% the power spectrum at the discrete frequencies within the band to the
% energy over the entire frequency band (constraint left by 'leftcutoff').
% A number of 'k' bands can be given in a 'k'x2 matrix 'bandM'. 
% INPUT 
% - xV      : the given time series
% - bandM   : a k x 2 matrix where k bands are given with the left and
%             right limit in the first and second column, respectively.
% - leftcutoff: the left cutoff of frequency (to avoid the effect of drifts 
%               in the signal).
% OUTPUT
% - EbandV  : a k x 1 vector of the energy in the k bands.
% - freqV   : the frequencies for which the power spectrum is evaluated.
% - psV     : the power spectrum. 
% - errormsg: a string of error message in case output cannot be generated.
%========================================================================
%     <EnergyBand.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
    leftcutoff = 0;
end
errormsg = [];
[k,tmp]=size(bandM);
if tmp~=2 
    errormsg = 'Wrong format of the input for the frequency bands.';
end
nband=size(bandM,1);
EbandV = NaN*ones(nband,1);
[psV,freqV]=periodogram(xV); 
freqV = freqV / (2*pi);  % Corrected, thanks to Robert Reijntjes, Leiden University Medical Centre
if length((find(isnan(psV))))==0
    totalenergy = sum(psV(find(freqV>=leftcutoff)));
    for i=1:nband
        EbandV(i)=sum(psV(find(freqV>=bandM(i,1) & freqV<=bandM(i,2))))/totalenergy;
    end
else
    errormsg = 'The periodogram could not be computed.';
end
