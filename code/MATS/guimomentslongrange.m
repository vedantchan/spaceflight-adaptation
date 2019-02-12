function varargout = guimomentslongrange(varargin)
% GUIMOMENTSLONGRANGE M-file for guimomentslongrange.fig
%      GUIMOMENTSLONGRANGE, by itself, creates a new GUIMOMENTSLONGRANGE or raises the existing
%      singleton*.
%
%      H = GUIMOMENTSLONGRANGE returns the handle to a new GUIMOMENTSLONGRANGE or the handle to
%      the existing singleton*.
%
%      GUIMOMENTSLONGRANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMOMENTSLONGRANGE.M with the given input arguments.
%
%      GUIMOMENTSLONGRANGE('Property','Value',...) creates a new GUIMOMENTSLONGRANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guimomentslongrange_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guimomentslongrange_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guimomentslongrange

% Last Modified by GUIDE v2.5 31-Jan-2008 20:46:18
%========================================================================
%     <guimomentslongrange.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guimomentslongrange_OpeningFcn, ...
                   'gui_OutputFcn',  @guimomentslongrange_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guimomentslongrange is made visible.
function guimomentslongrange_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
measureC = getappdata(0,'parlist');
handles.measures = measureC;
handles.firstfunmea = 49; % Declares the first index of measures 
handles.lastfunmea = 59;% Declares the last index of measures 
% Fill the measures and parameters in the specified fields of the panel.
firstfunmea = handles.firstfunmea; 
lastfunmea = handles.lastfunmea;
measureC = measureC(firstfunmea:lastfunmea,:);
nfunmea = lastfunmea-firstfunmea+1;
curposV = [2 35];
checkwidth = 2.5;
checkheight = 1;
spaceheight = 0.5;
spacewidth = 1;
allheight = 2.5;
namewidth = 40; 
partextwidth = 20;
parvaluewidth = 10;
labeltextheight = 1;
labeltextwidth = 15;
countpar = 0;
% yposnow = curposV(2);
ypospanel = 22;
yposnow = ypospanel;
for i=1:7
    yposnow = yposnow-(allheight+spaceheight);
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',i,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i)])
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i+countpar,xposnow,yposnow,namewidth,allheight)])
end
ypospanel = 7;
yposnow = ypospanel;
for i=8:9
    yposnow = yposnow-(allheight+spaceheight);
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',i,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i)])
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,xposnow,yposnow,namewidth,allheight)])
    countpar = countpar + 1;
end 
ypospanel = 7;
yposnow = ypospanel;
for i=10:11
    yposnow = yposnow-(allheight+spaceheight);
    eval([sprintf('set(handles.checkbox%d,''Value'',%s)',i,measureC{i,1})])
    eval([sprintf('set(handles.checkbox%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,curposV(1),yposnow+allheight/4,checkwidth,checkheight)])
    namecode = sprintf('%s (%s)',measureC{i,2},measureC{i,3});
    xposnow = curposV(1)+checkwidth+spacewidth;
    eval([sprintf('set(handles.text%d,''String'',''%s'')',i,namecode)])
    eval([sprintf('set(handles.text%d,''HorizontalAlignment'',''left'')',i)])
    eval([sprintf('set(handles.text%d,''Position'',[%2.2f %2.2f %2.2f %2.2f])',...
        i,xposnow,yposnow,namewidth,allheight)])
end 
guidata(hObject,handles);


% --- Outputs from this function are returned to the command line.
function varargout = guimomentslongrange_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% Time Series mean
function checkbox1_Callback(hObject, eventdata, handles)


% Time Series median
function checkbox2_Callback(hObject, eventdata, handles)


% Time Series variance
function checkbox3_Callback(hObject, eventdata, handles)


% Time Series Standard Deviation
function checkbox4_Callback(hObject, eventdata, handles)

% Time Series intequartile range
function checkbox5_Callback(hObject, eventdata, handles)


% Time Series skewness
function checkbox6_Callback(hObject, eventdata, handles)


% Time Series kurtosis
function checkbox7_Callback(hObject, eventdata, handles)


% Hjorth Mobility
function checkbox8_Callback(hObject, eventdata, handles)


% Hjorth Complexity
function checkbox9_Callback(hObject, eventdata, handles)

% Hurst Exponent
function checkbox10_Callback(hObject, eventdata, handles)

% Detrended Fluctuation Analysis
function checkbox11_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
measureC = handles.measures;
firstfunmea =handles.firstfunmea;
lastfunmea =handles.lastfunmea;
nfunmea = lastfunmea-firstfunmea+1;
for i=firstfunmea:firstfunmea+nfunmea-1
    eval([sprintf('tmp=get(handles.checkbox%d,''Value'');',i-firstfunmea+1)])
    measureC{i,1}=num2str(tmp);
end
setappdata(0,'parlist',measureC);
delete(guimomentslongrange)


% --- Executes on button press in Cancel pushbutton.
function pushbutton2_Callback(hObject, eventdata, handles)
delete(guimomentslongrange)


% --- Executes on button press in Help pushbutton.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\MomentLongRangeMeasures.htm'')'])


