%========================================================================
%     <imgmea1_2_3plotbutton.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
ndata1 = 20;
ndata2 = 25;
nmea = 2;
randn('state',0);
buttonsize = [150 120];

mu1 = [5 0 0];
sigma1 = [1 0.3 0.3; 0.3 1 0.3; 0.3 0.3 1];
set1M = mvnrnd(mu1,sigma1,ndata1);
mu2 = [1 5 1];
sigma2 = [1 0.3 0.3; 0.3 1 0.3; 0.3 0.3 1];
set2M = mvnrnd(mu2,sigma2,ndata2);

h = figure(1);
clf
% axes('position',[0.12 0.16 0.80 0.65])
plot3(set1M(:,1),set1M(:,2),set1M(:,3),'.','Markersize',30);
hold on
plot3(set2M(:,1),set2M(:,2),set2M(:,3),'.','Markersize',30);
% set(gca,'XTickLabelMode','Manual');
% set(gca,'XTickLabel',num2str([1:ndata]'));
% set(gca,'XTickMode','Manual');
% set(gca,'XTick',[1:ndata]');
% set(gca,'YTickLabelMode','Manual');
% set(gca,'YTickLabel','');
% set(gca,'YTickMode','Manual');
% set(gca,'YTick',[]);
% leg = legend('measure 1','measure 2','measure 3','location','NorthEastOutside');
xlabel('measure 1','fontsize',40)
ylabel('measure 2','fontsize',40)
zlabel('measure 3','fontsize',40)
set(gca,'Box','On')
h = title('3D plot of measures','fontsize',55)
print -r300 -dbmp buttonmea1mea2mea3plot.bmp
