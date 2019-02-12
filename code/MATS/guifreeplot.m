function varargout = guifreeplot(varargin)
%========================================================================
%     <guifreeplot.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guifreeplot_OpeningFcn, ...
                   'gui_OutputFcn',  @guifreeplot_OutputFcn, ...
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


% --- Executes just before guifreeplot is made visible.
function guifreeplot_OpeningFcn(hObject, eventdata, handles, varargin)
% Fill in listbox1 with time series names
datnameM = getappdata(0,'datnameM');
set(handles.listbox1,'Max',size(datnameM,1))
set(handles.listbox1,'String',datnameM,'Value',1)
% Fill in listbox2 with measure names
meadatC = getappdata(0,'mealist');
set(handles.listbox2,'Max',size(meadatC(:,1),1))
listdatS = meadatC{1,1};
for i=2:size(meadatC(:,1),1)
    listdatS = str2mat(listdatS,meadatC{i,1});
end
set(handles.listbox2,'String',listdatS,'Value',1)
set(handles.popupmenu1,'Value',1) % At start use lines from the popupmenu

handles.current_dataname = datnameM;
handles.current_meadat = meadatC;

messageS = sprintf('Graph measures vs time series index: \n When up to 10 time series are selected, they are displayed right of the figure. \n When up to 5 measures are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
set(handles.edit1,'String',messageS);

% Choose default command line output for guifreeplot
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guifreeplot_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in View Free Plot button.
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
measurelist_entries = get(handles.listbox2,'String');
measureindex_selected = get(handles.listbox2,'Value');
cols=length(measureindex_selected); 
rows=length(dataindex_selected);
if rows == 1
    messageS = sprintf('At least two time series should be selected for displaying the graph measures vs time series index.');
    set(handles.edit1,'String',messageS);
else
    messageS = ''; % To be ready to show a new message
    datnameM = handles.current_dataname;
    meadatC = handles.current_meadat;

    datnamelist = [];
    for i=1:rows
        datnamelist{i}=datnameM(dataindex_selected(i),:);
    end
    meanamelist = [];
    plottableM = NaN*ones(rows,cols);
    for j=1:cols
        meanamelist{j}=meadatC{measureindex_selected(j),1};
        for i=1:rows
            plottableM(i,j)= meadatC{measureindex_selected(j),2}(dataindex_selected(i));
        end
    end
    drawtype = get(handles.popupmenu1,'Value');
    if drawtype==1
        symbV = str2mat('-k','-c','-r','--k','--c','--r','-.k','-.c','-.r',':k',':c',':r');
    elseif drawtype==2
        symbV = str2mat('ok','oc','or','xk','xc','xr','+k','+c','+r','*k','*c','*r');
    else
        symbV = str2mat('o-k','o-c','o-r','x--k','x--c','x--r','+-.k','+-.c','+-.r','*:k','*:c','*:r');
    end
    nsymb = size(symbV,1);

    handles.PlotFigure = figure('NumberTitle','Off','Name','Measures vs Time Series',...
        'PaperOrientation','Landscape');
    axes('position',[0.12 0.16 0.60 0.80])
    eval(['plot(plottableM(:,1),''',symbV(1,:),''',''Markersize'',8,''linewidth'',2);'])
    hold on
    for j=2:cols
        k = mod(j-1,nsymb)+1;
        eval(['plot(plottableM(:,j),''',symbV(k,:),''',''Markersize'',8,''linewidth'',2);'])
    end
    set(gca,'XTickLabelMode','Manual');
    set(gca,'XTickLabel',num2str([1:rows]'));
    set(gca,'XTickMode','Manual');
    set(gca,'XTick',[1:rows]');
    if cols<=5
        meanamelist2 = replacesymbol(meanamelist,'_','');
        eval(['leg = legend([meanamelist2],''location'',''Best'');'])
        % set(leg,'EdgeColor',[1 1 1])
        set(leg,'Box','Off')
    else
        for j=1:cols
            k = mod(j-1,nsymb)+1;
            messageS = sprintf('%s ''%s'': %s \n',messageS,symbV(k,:),char(meanamelist{j}));
        end
        set(handles.edit1,'String',messageS);
    end
    ax = axis;
    axis([1 rows ax(3) ax(4)])
    if rows<=10
        ax = axis;
        dyax = 0.1*(ax(4)-ax(3));
        dxax = 0.04*(ax(2)-ax(1));
        for i=1:rows
            text(ax(2)+dxax,ax(3)+(i-0.5)*dyax,sprintf('%d: %s',rows-i+1,char(datnamelist{rows-i+1})),'fontsize',7)
        end
    else
        messageS = sprintf('%s \n',messageS);
        for i=1:rows
            messageS = sprintf('%s %d: %s \n',messageS,i,char(datnamelist{i}));
        end
        set(handles.edit1,'String',messageS);
    end
    xlabel('time series index')
    ylabel('measure')
%    title('free plot')
    if rows<=10 & cols<=5
        messageS = sprintf('Graph measures vs time series index: \n When up to 10 time series are selected, they are displayed right of the figure. \n When up to 5 measures are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
        set(handles.edit1,'String',messageS);
    end
end % if No of time series == 1
guidata(hObject, handles);

% --- Executes on button press in Exit button.
function pushbutton2_Callback(hObject, eventdata, handles)
% if isfield(handles,'PlotFigure') & ishandle(handles.PlotFigure),
%     close(handles.PlotFigure);
% end
delete(guifreeplot)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewFreePlot.htm'')'])

function edit1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


