%========================================================================
%     <imgpar1par2plotbutton.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
clear all
buttonsize = [150 120];
ylimnrm = [0.9 1.3];

load usbpmd355LS1___t2T1.nrm
nrmM = usbpmd355LS1___t2T1;

[nrow,ncol]=size(nrmM);
kV = nrmM(1,2:ncol);
mV = nrmM(2:nrow,1);
nk = length(kV);
nm = length(mV);
for irow=2:nrow
    for icol=2:ncol
        if nrmM(irow,icol)==-1
            nrmM(irow,icol)=NaN; 
        end
    end
end  

h = figure(1);
clf
surf(kV,mV,nrmM(2:nm+1,2:nk+1))
% set(gca,'XTickLabelMode','Manual');
% set(gca,'XTickLabel',num2str([1:ndata]'));
% set(gca,'XTickMode','Manual');
% set(gca,'XTick',[1:ndata]');
% set(gca,'YTickLabelMode','Manual');
% set(gca,'YTickLabel','');
% set(gca,'YTickMode','Manual');
% set(gca,'YTick',[]);
ax = axis;
axis([nrmM(1,2) nrmM(1,nk+1) nrmM(2,1) nrmM(nm+1,1) ylimnrm])
xlabel('par 1','fontsize',50)
ylabel('par 2','fontsize',50)
zlabel('measure','fontsize',50)
title('measure vs parameters','fontsize',50);
print -r300 -dbmp buttonpar1par2plot.bmp
