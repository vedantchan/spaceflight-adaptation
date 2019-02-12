function radiusT = RadiusCorrelationSum(xV,cV,tauV,mV,theiler)
% radiusT = RadiusCorrelationSum(xV,cV,tauV,mV,theiler)
% RADIUSCORRELATIONSUM computes the radii regarding a set of given 
% correlation sums in 'cV' on a given time series 'xV' and state space 
% reconstructions with delays in 'tauV' and embedding dimensions in 'mV'. 
% The parameter 'theiler' excludes temporally close points (smaller than 
% 'theiler') from the inter-distance computations. 
% The correlation sum is computed as a function of the radius iteratively
% starting at a predefined radius until a (predefined) accuracy in the 
% radius is reached.
% INPUT 
% - xV      : Vector of the scalar time series
% - cV      : A vector of the correlation sum values (assuming that 'xV' is
%             standardized in [0,1]).
% - tauV    : A vector of the delay times.
% - mV      : A vector of the embedding dimension.
% - theiler : the Theiler window to exclude time correlated points in the
%             search for neighboring points. Default=0.
% OUTPUT: 
% - radiusT : A matrix of size 'nr' x 'ntau' x 'nm', where 'nr' is the 
%             number of given radius, 'ntau' is the number of given delays 
%             and 'nm' is the number of given embedding dimensions. The
%             components of the matrix are the radius values.
%========================================================================
%     <RadiusCorrelationSum.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
epsilon = 0.0001; % The accuracy in the correlation sum in order to terminate.

n = length(xV);
if isempty(theiler), theiler=0; end
% Rescale to [0,1]
xmin = min(xV);
xmax = max(xV);
xV = (xV - xmin) / (xmax-xmin);
nc = length(cV);
ntau = length(tauV);
nm = length(mV);
rT = NaN*ones(nc,ntau,nm);
for ic=1:nc
    c = cV(ic);
    for itau = 1:ntau
        tau = tauV(itau);
        for im=1:nm
            m = mV(im);
            if n-(m-1)*tau-theiler < 2
                break;
            end
            % Some parameters for the iterative scheme are determined
            % below. The scheme is a simple line search procedure.
            a = roots([1 -4 4*c^(1/m)]); 
            if sign(a(1)) & sign(a(2))
                r0 = min(a);
            elseif sign(a(1))
                r0 = a(1);
            else sign(a(2))
                r0 = a(2);
            end
            d0 = r0/3;
            c0 = CorrelationSum(xV,r0,tau,m,theiler);
            if c0<c
               d = d0;
            else
               d = -d0;
            end
            r1 = abs(r0+d);
            c1 = CorrelationSum(xV,r1,tau,m,theiler);
            counter = 1;
            while (abs(c1-c0)>epsilon | abs(c1-c)>epsilon) & abs(d)>epsilon
                counter = counter+1;
                if c0<c & c1<c
                    d = abs(d);
                    if c0==c1
                        r2 = abs(r1+d/2);
                    else
                        r2 = abs(r1+d);
                    end
                elseif c0>c & c1>c
                    d = -abs(d);
                    r2 = abs(r1+d);
                elseif abs(c0-c)<abs(c1-c)
                    d = d/2;
                    r2 = abs(r0+d);
                else
                    d = -d/2;
                    r2 = abs(r1+d);
                end
                r0 = r1;
                r1 = r2;
                c0 = c1;
                c1 = CorrelationSum(xV,r1,tau,m,theiler);
%                 fprintf('%d) r0=%f \t r1=%f \t r2=%f \n',counter,r0,r1,r2);
%                 fprintf('    c0=%f \t c1=%f \t c=%f \n',c0,c1,c);
%                 fprintf('    d=%f \n',d);
%                 pause;
            end
            radiusT(ic,itau,im) = r1;
        end
    end
end
