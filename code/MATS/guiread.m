function varargout = guiread(varargin)
% GUIREAD M-file for guiread.fig
%      GUIREAD, by itself, creates a new GUIREAD or raises the existing
%      singleton*.
%
%      H = GUIREAD returns the handle to a new GUIREAD or the handle to
%      the existing singleton*.
%
%      GUIREAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIREAD.M with the given input arguments.
%
%      GUIREAD('Property','Value',...) creates a new GUIREAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiread_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiread_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiread

% Last Modified by GUIDE v2.5 03-Jan-2008 14:24:41
%========================================================================
%     <guiread.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guiread_OpeningFcn, ...
                   'gui_OutputFcn',  @guiread_OutputFcn, ...
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

% --- Executes just before guiread is made visible.
function guiread_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
handles.current_data = [];
handles.current_count = 0;
handles.current_directory = pwd;
guidata(hObject,handles);    % update handles
if nargin == 3
    %    initial_dir =get(handles.edit1,'String');
    initial_dir = pwd;
elseif nargin == 4 & exist(varargin{1},'dir')
    initial_dir = varargin{1};
else
    errordlg('Input argument must be a valid directory','InputArgument Error!')
    return
end
% Populate the listbox
load_listbox(initial_dir,handles)

messageS = sprintf('Files with suffices: "xls" or "xlsx" are opened using excel, "edf" are opened using the biosig toolbox, all other files are opened as plain ascii \n');
set(handles.edit4,'String',messageS);

% --- Outputs from this function are returned to the command line.
function varargout = guiread_OutputFcn(hObject, eventdata, handles)
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
if strcmp(get(handles.figure1,'SelectionType'),'open') % If double click
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    filename = file_list{index_selected}; % Item selected in list box
    if handles.is_dir(handles.sorted_index(index_selected)) % If directory
        cd (filename)
        load_listbox(pwd,handles) % Load list box with new directory
    else
        [path,name,ext,ver] = fileparts(filename);
        switch ext
            case '.fig'
                guide(filename) % Open FIG-file with guide command
            otherwise
                try
                    open(filename) % Use open for other file types
                catch
                    errordlg(lasterr,'File Type Error','modal')
                end
        end
    end
end
% guidata(hObject,handles)    % update handles

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
seldat=handles.current_data;
count= handles.current_count;
messageS = sprintf('Files with suffices: "xls" are opened using excel, "edf" are opened using biosig toolbox, all other files are opened as plain ascii \n');
set(handles.edit4,'String',messageS);

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
k1=length(index_selected) ;
a=[];
fileC=[];
n2=[];
illegalV = [];
messageS = [];
% Scan each selected name and if it has proper format (suffices edf,xls, or 
% otheriwse plain ascii matrix form) add it in the active list of data files.
countnow = 0; % each time a valid data matrix is loaded successfully add it in the list.
for i=1:k1
    candfilename=list_entries{index_selected(i)};
    % Check if the name is directory, otherwise assume it is a data file
    if exist(candfilename)==7
        messageS = sprintf('%s The selected name "%s" is a directory and it is ignored. \n',messageS,candfilename);
        set(handles.edit4,'String',messageS);
    else
        % If the file name does not have a suffix, treat at as plain ascii
        % matrix.
        ii = find(candfilename=='.');
        if isempty(ii)
            suffixS = 'dat'; % Just a dummy text to enter switch (case otherwise)
            ii = length(candfilename);
        else
            suffixS = candfilename(ii+1:end);
        end
        readerror=0;
        switch lower(suffixS)
            case 'edf'
                messageS = sprintf('%s File "%s" is of edf format, biosig toolbox is called to open it.\n',messageS,candfilename);
                set(handles.edit4,'String',messageS);
                HDR = sopen(candfilename,'r');
                [canddataset,HDR] = sread(HDR);
                countnow = countnow+1;
                fileC{countnow,1} = candfilename(1:ii-1);
                fileC{countnow,2} = canddataset;
                fileC{countnow,3}=size(fileC{countnow,2},1);
                fileC{countnow,4}=size(fileC{countnow,2},2);
            case {'xls','xlsx'}
                messageS = sprintf('%s File "%s" is of xls or xlsx format, excel is called to open it.\n',messageS,candfilename);
                set(handles.edit4,'String',messageS);
                try
                    canddataset = xlsread(candfilename,-1);
                    countnow = countnow+1;
                    fileC{countnow,1} = candfilename(1:ii-1);
                    fileC{countnow,2} = canddataset;
                    fileC{countnow,3}=size(fileC{countnow,2},1);
                    fileC{countnow,4}=size(fileC{countnow,2},2);
                catch
                    readerror=1;
                end
            case 'mat'
                messageS = sprintf('%s File "%s" is of mat format, each data matrix is loaded.\n',messageS,candfilename);
                set(handles.edit4,'String',messageS);
                try
                    allC = load(candfilename);
                    nameallC = fieldnames(allC);
                    for iname=1:size(nameallC,1)
                        candfilenamenow = sprintf('%s',nameallC{iname});
                        eval(['canddataset = allC.',nameallC{iname},';'])
                        % The following can be uncommented if the dimension
                        % of larger number of samples has to be taken as
                        % the one corresponding to the time series data
                        % (and the other the different variables).
%                         if size(canddataset,1)<size(canddataset,2)
%                             canddataset = canddataset';
%                         end                        
                        countnow = countnow+1;
                        fileC{countnow,1} = candfilename(1:ii-1);
                        fileC{countnow,2} = canddataset;
                        fileC{countnow,3}=size(fileC{countnow,2},1);
                        fileC{countnow,4}=size(fileC{countnow,2},2);
                    end    
                catch
                    readerror=1;
                end
            otherwise
                try
                    load(candfilename);
                    eval(['canddataset=',candfilename(1:ii-1),';'])
                    countnow = countnow+1;
                    fileC{countnow,1} = candfilename(1:ii-1);
                    fileC{countnow,2} = canddataset;
                    fileC{countnow,3}=size(fileC{countnow,2},1);
                    fileC{countnow,4}=size(fileC{countnow,2},2);
                catch
                    readerror=1;
                end
        end
        if readerror==1
            messageS = sprintf('%s File "%s" is not in a numeric matrix form and it is ignored.\n',messageS,candfilename);
            set(handles.edit4,'String',messageS);
        end
    end
end
k1 = countnow;
% Select all columns of the given data files and join them in a cell array with
% first component the name <filename>C<i>, where i runs over all columns,
% and second component the data vector.
if k1>0
    for i=1:k1
        for j=1:fileC{i,4}
            count = count+1;
            newname = sprintf('%sC%d',fileC{i,1},j);
            if isempty(seldat) || isempty(strmatch(newname,seldat(:,1),'exact'))
                seldat{count,1}=newname;
                seldat{count,2}=fileC{i,2}(:,j);
                seldat{count,3}=fileC{i,3};
            else
                count = count-1;
            end
        end
        eval(['clear ',fileC{i,1}])
    end
    clear fileC
    listdatS = sprintf('%s (%d)',seldat{1,1},seldat{1,3});
    for i=2:size(seldat(:,1),1)
        listdatS = str2mat(listdatS,sprintf('%s (%d)',seldat{i,1},seldat{i,3}));
    end
    set(handles.listbox2,'String',listdatS,'Value',1)
end
handles.current_data = seldat;  % store x variable for use to other callbacks
handles.current_count = count;  % store x variable for use to other callbacks
guidata(hObject,handles)    % update handles
%----------------------

function load_listbox(dir_path, handles)
cd (dir_path)
dir_struct = dir(dir_path);
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = [sorted_index];
guidata(handles.figure1,handles)
set(handles.listbox1,'String',handles.file_names,'Value',1)
set(handles.text1,'String',pwd)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit1_Callback(hObject, eventdata, handles)
initial_dir =get(handles.edit1,'String');  %pwd;
load_listbox(initial_dir,handles)


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)


% --- Executes on button press in Load selected time series pushbutton.
function pushbutton2_Callback(hObject, eventdata, handles)
list_entries = get(handles.listbox2,'String');
index_selected = get(handles.listbox2,'Value');
k2=length(index_selected); 
seldat = handles.current_data;
dat = getappdata(0,'datlist');
% In case the data list is empty, fill it without checking existing names 
% in the list
if isempty(dat)
    for i=1:k2
        dat{i,1}=seldat{index_selected(i),1};
        dat{i,2}=seldat{index_selected(i),2};
        dat{i,3}=length(dat{i,2});
    end
else
    count = length(dat(:,1));
    for i=1:k2
        newname = seldat{index_selected(i),1};
        if isempty(strmatch(newname,dat(:,1),'exact'))
            count = count+1;
            dat{count,1}=newname;
            dat{count,2}=seldat{index_selected(i),2};
            dat{count,3}=length(dat{count,2});
        end
    end
end
clear seldat
setappdata(0,'datlist',dat);
eval(['cd ',handles.current_directory]);
delete(guiread)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit2_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit3_Callback(hObject, eventdata, handles)


% --- Executes on button press in Cancel button.
function pushbutton3_Callback(hObject, eventdata, handles)
eval(['cd ',handles.current_directory]);
delete(guiread)

% --- Executes on button press in Help button.
function pushbutton4_Callback(hObject, eventdata, handles)
dirnow = handles.current_directory;
eval(['web(''',dirnow,'\helpfiles\LoadTimeSeries.htm'')'])

function edit4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


