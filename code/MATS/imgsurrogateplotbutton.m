%========================================================================
%     <imgsurrogateplotbutton.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
ndata = 5;
nmea = 3;
randn('state',0);
meaM = randn(ndata,nmea);
buttonsize = [150 120];

h = figure(1);
clf
% axes('position',[0.12 0.16 0.80 0.65])
h1 = plot(meaM(:,1),'o-','Markersize',10,'linewidth',3);
hold on
plot(meaM(:,2),'x--k','Markersize',10,'linewidth',3)
plot(meaM(:,3),'+-.r','Markersize',10,'linewidth',3)
set(gca,'XTickLabelMode','Manual');
set(gca,'XTickLabel',num2str([1:ndata]'));
set(gca,'XTickMode','Manual');
set(gca,'XTick',[1:ndata]');
set(gca,'YTickLabelMode','Manual');
set(gca,'YTickLabel','');
set(gca,'YTickMode','Manual');
set(gca,'YTick',[]);
% leg = legend('measure 1','measure 2','measure 3','location','NorthEastOutside');
leg = legend('measure 1','measure 2','measure 3','location','Best');
set(leg,'EdgeColor',[1 1 1])
set(leg,'FontSize',24)
ax = axis;
xlabel('resampling index','fontsize',50)
ylabel('measure','fontsize',50)
h = title('measure vs resampled','fontsize',55)
% hpos = get(h,'Position');
% hpos(1) = 0.999*hpos(1);
% set(h,'Position',hpos)
print -r300 -dbmp buttonsurrogateplot.bmp
