function [sautV,cumsautV,decsaut,zerosaut] = Spearmanautocorrelation(xV,tauV,flag)
% [sautV,cumsautV,decsaut,zerosaut] = Spearmanautocorrelation(xV,tauV,flag)
% SPEARMANAUTOCORRELATION computed the Spearman autocorrelation on the time
% series 'xV' for given delays in 'tauV'.
% According to a given flag, it can also compute the cumulative Spearman
% autocorrelation for each given lag, the decorrelation time (the delay
% for which the Spearman autocorrelation is 1/e) and the time the
% Spearman autocorrelation falls to zero.
% INPUT
% - xV       : a vector for the time series
% - tauV     : a vector of the delays to be evaluated for
% - flag    : if 0-> compute only Spearman autocorrelation,
%           : if 1-> compute the Spearman autocorrelation, the cumulative
%             Spearman autocorrelation, the decorrelation time and the time
%             of zero Spearman autocorrelation.
%             if 2-> compute (also) the cumulative Spearman autocorrelation.
%             if 3-> compute (also) the decorrelation time.
%             if 4-> compute (also) the time of zero Spearman autocorrelation.
% OUTPUT
% - sautV    : the vector of the Spearman autocorrelations for the given delays
% - cumsautV : the vector of the cumulative Spearman autocorrelations for the
%              given delays
% - decsaut  : the decorrelation time from Spearman autocorrelation.
% - zerosaut : the time the Spearman autocorrelation falls to zero.
%========================================================================
%     <Spearmanautocorrelation.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
    flag = 1;
end
tauV = sort(tauV);
ntau = length(tauV);
taumax = tauV(end);
n = length(xV);
if n<taumax+1
    return;
end
sautV=NaN;
cumsautV=NaN;
decsaut=NaN;
zerosaut=NaN;

switch flag
    case 0
        % Compute only the Spearman autocorrelation for the given lags
        sautV=spearmancor(xV,tauV);
    case 1
        % Compute the Spearman autocorrelation for the given lags, the
        % cumulative Spearman autocorrelation, and find, if possible,
        % the decorrelation time and the zero Spearman autocorrelation time
        sacV=spearmancor(xV,[1:taumax]');
        sautV = sacV(tauV); % store only the delays given in 'tauV'
        % Compute the cumulative Spearman autocorrelation for the given delays
        cumsautV = NaN*ones(ntau,1);
        for i=1:ntau
            cumsautV(i) = sum(abs(sacV(1:tauV(i))));
        end
        % Find, if possible, the decorrelation time
        dectauV = find(sacV <= 1/exp(1));
        if ~isempty(dectauV)
            decsaut = dectauV(1);
        end
        % Find, if possible, the zero Spearman autocorrelation time
        zerotauV = find(sacV <= 0);
        if ~isempty(zerotauV)
            zerosaut = zerotauV(1);
        end
    case 2
        % Compute the cumulative Spearman autocorrelation for the given lags
        sacV=spearmancor(xV,[1:taumax]');
        % Compute the cumulative Spearman autocorrelation for the given delays
        cumsautV = NaN*ones(ntau,1);
        for i=1:ntau
            cumsautV(i) = sum(abs(sacV(1:tauV(i))));
        end
    case 3
        % Find, if possible, the decorrelation time
        sacV=spearmancor(xV,[1:taumax]');
        dectauV = find(sacV <= 1/exp(1));
        if ~isempty(dectauV)
            decsaut = dectauV(1);
        end
    case 4
        % Find, if possible, the zero Spearman autocorrelation time
        sacV=spearmancor(xV,[1:taumax]');
        zerotauV = find(sacV <= 0);
        if ~isempty(zerotauV)
            zerosaut = zerotauV(1);
        end
end

