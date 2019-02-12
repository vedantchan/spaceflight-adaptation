function varargout = guisavedata(varargin)
%========================================================================
%     <guisavedata.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guisavedata_OpeningFcn, ...
                   'gui_OutputFcn',  @guisavedata_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before guisavedata is made visible.
function guisavedata_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for guisavedata
handles.output = hObject;
dat = getappdata(0,'datlist');
handles.current_data = dat;
listdatS = sprintf('%s (%d)',dat{1,1},dat{1,3});
for i=2:size(dat(:,1),1)
    listdatS = str2mat(listdatS,sprintf('%s (%d)',dat{i,1},dat{i,3}));
end
set(handles.listbox1,'String',listdatS,'Value',1)
set(handles.text1,'String',pwd)
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = guisavedata_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes on button press in Select directory button.
function pushbutton1_Callback(hObject, eventdata, handles)
startpath = get(handles.text1,'String');
dirtxt = uigetdir(startpath,'dialog_title');
% uiwait;
if dirtxt==0
    return;
end
set(handles.text1,'String',dirtxt)
cd (dirtxt)
guidata(hObject,handles)    % update handles

% --- Executes on button press in Select time series to save button.
function pushbutton2_Callback(hObject, eventdata, handles)
list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
k2=length(index_selected); 

dat = handles.current_data;
fileformatind = get(handles.popupmenu1,'Value');
fileformattxt = get(handles.popupmenu1,'String');
fileformattxt = fileformattxt(fileformatind);
messageS = sprintf('Saving files in format %s ... \n',char(fileformattxt));
set(handles.edit4,'String',messageS);
pause(0.0000000000001);
switch fileformatind 
    case 1
    % The selected format is plain ascii (use suffix .dat)
        for i=1:k2
            dattxt = sprintf('%s.dat',dat{index_selected(i),1});
            tmp=dat{index_selected(i),2};
            save(dattxt,'tmp','-ascii')
        end
        messageS = sprintf('Each selected time series with name <name> is saved in file <name>.dat.\n'); 
        set(handles.edit4,'String',messageS);
    case 2
        failflag = 0;
        for i=1:k2
            dattxt = sprintf('%s.xls',dat{index_selected(i),1});
            tmp=dat{index_selected(i),2};
            eval(['success = xlswrite(''',dattxt,''',tmp);'])
            if ~success
                messageS = sprintf('%s File %s could not be saved.\n',messageS,dattxt);
                set(handles.edit4,'String',messageS);
                failflag = 1;
            end
        end
        if ~failflag
            messageS = sprintf('Each selected time series with name <name> is saved in file <name>.xls.\n'); 
            set(handles.edit4,'String',messageS);
        end
    case 3
        for i=1:k2
            dattxt = sprintf('%s.mat',dat{index_selected(i),1});
            tmp=dat{index_selected(i),2};
            save(dattxt,'tmp','-mat')          
        end
        messageS = sprintf('Each selected time series with name <name> is saved in file <name>.mat.\n'); 
        set(handles.edit4,'String',messageS);
end

% --- Executes on button press in Exit pushbutton.
function pushbutton3_Callback(hObject, eventdata, handles)
delete(guisavedata)

% --- Executes on button press in Help pushbutton.
function pushbutton4_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\SaveTimeSeries.htm'')'])

% --- Executes on selection change in File Format popupmenu.
function popupmenu1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% The editbox for output messages
function edit4_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


