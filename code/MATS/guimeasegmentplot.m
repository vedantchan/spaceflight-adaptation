function varargout = guimeasegmentplot(varargin)
%========================================================================
%     <guimeasegmentplot.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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
                   'gui_OpeningFcn', @guimeasegmentplot_OpeningFcn, ...
                   'gui_OutputFcn',  @guimeasegmentplot_OutputFcn, ...
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


% --- Executes just before guimeasegmentplot is made visible.
function guimeasegmentplot_OpeningFcn(hObject, eventdata, handles, varargin)
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

messageS = sprintf('Graph measures vs segment index: \n The given time series names should differ only with respect to the segment index, otherwise they are ignored. \n When up to 5 measures are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
set(handles.edit1,'String',messageS);

% Choose default command line output for guimeasegmentplot
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = guimeasegmentplot_OutputFcn(hObject, eventdata, handles) 
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

% --- Executes on button press in View Selected Plot button.
function pushbutton1_Callback(hObject, eventdata, handles)
datalist_entries = get(handles.listbox1,'String');
dataindex_selected = get(handles.listbox1,'Value');
measurelist_entries = get(handles.listbox2,'String');
measureindex_selected = get(handles.listbox2,'Value');
cols=length(measureindex_selected); 
rows=length(dataindex_selected);
if rows == 1
    messageS = sprintf('At least two segments should be selected for displaying the graph measures vs segment index.');
    set(handles.edit1,'String',messageS);
else
    messageS = ''; % To be ready to show a new message
    datnameM = handles.current_dataname;
    meadatC = handles.current_meadat;
    datnamelist = datnameM(dataindex_selected,:);
    validS = [];
    foundnum = 1;
    i=1;
    while i<=rows & foundnum
        datnamenowS = char(datnamelist{i});
        Stxt = find(datnamenowS=='S');
        if ~isempty(Stxt)
            nS = length(Stxt);
            for j=1:nS                
                if Stxt(j)<length(datnamenowS) & ~isempty(str2num(datnamenowS(Stxt(j)+1)))
                    validS = Stxt(j);
                end
            end
            if ~isempty(validS)
                foundnum = 0;
                validS = validS(end);
                validi = i;
            end
        end
        i = i+1;
    end
    % Find only the datnames that constitute segments of a common time
    % series
    if ~isempty(validS)
        datnamevalidS = char(datnamelist{validi});
        datnameleft = datnamevalidS(1:validS);
        datnameleftlength = length(datnameleft);
        j=datnameleftlength+1;
        foundnum = 1;
        while j<=length(datnamevalidS) & foundnum==1
            if ~isempty(str2num(datnamevalidS(j)))
                j=j+1;
            else
                foundnum=0;
            end
        end
        if j<=length(datnamevalidS)
            datnameright = datnamevalidS(j:end);
        else
            datnameright = [];
        end
        segM = [];
        for i=1:rows
            datnamenowS = char(datnamelist{i});
            if length(datnamenowS)>=datnameleftlength & strmatch(datnameleft,datnamenowS(1:datnameleftlength),'exact') 
                j=datnameleftlength+1;
                foundnum = 1;
                while j<=length(datnamenowS) & foundnum==1
                    if ~isempty(str2num(datnamenowS(j)))
                        j=j+1;
                    else
                        foundnum=0;
                    end
                end
                candnum = datnamenowS(datnameleftlength+1:j-1);
                if (isempty(datnameright) & j>length(datnamenowS)) | (~isempty(datnameright) & ~isempty(datnamenowS(j:end)) & strmatch(datnameright,datnamenowS(j:end),'exact')) 
                    segM = [segM; [dataindex_selected(i) str2num(candnum)]];
                end
            end
        end
        if size(segM,1)==1
            messageS = sprintf('At least two segments should be selected for displaying the graph measures vs segment index.');
            set(handles.edit1,'String',messageS);
        else
            meanamelist = [];
            nseg = size(segM,1);
            plottableM = NaN*ones(nseg,cols);
            for j=1:cols
                meanamelist{j}=meadatC{measureindex_selected(j),1};
                for i=1:nseg
                    plottableM(i,j)= meadatC{measureindex_selected(j),2}(segM(i,1));
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
            eval(['plot(segM(:,2),plottableM(:,1),''',symbV(1,:),''',''Markersize'',8,''linewidth'',2);'])
            hold on
            for j=2:cols
                k = mod(j-1,nsymb)+1;
                eval(['plot(segM(:,2),plottableM(:,j),''',symbV(k,:),''',''Markersize'',8,''linewidth'',2);'])
            end
            if cols<=5
                meanamelist2 = replacesymbol(meanamelist,'_','');
                eval(['leg = legend([meanamelist2],''location'',''Best'');'])
                set(leg,'EdgeColor',[1 1 1])
            else
                for j=1:cols
                    k = mod(j-1,nsymb)+1;
                    messageS = sprintf('%s ''%s'': %s \n',messageS,symbV(k,:),char(meanamelist{j}));
                end
                set(handles.edit1,'String',messageS);
            end
            xlabel('segment index')
            ylabel('measure')
            if isempty(datnameright)
                title(sprintf('Segments of type %s<seg index>',datnameleft))
            else
                title(sprintf('Segments of type %s<seg index>%s',datnameleft,datnameright))
            end
            if cols<=5
                messageS = sprintf('Graph measures vs segment index: \n The given time series names should differ only with respect to the segment index, otherwise they are ignored. \n When up to 5 measures are selected, they are listed in a legend. \n Otherwise they are listed in this text box (matlab color and symbol syntax for the measures).');
                set(handles.edit1,'String',messageS);
            end
        end % if No of segments == 1
    end % ~isemty(validS)
end % if No of time series == 1
guidata(hObject, handles);

% --- Executes on button press in Exit button.
function pushbutton2_Callback(hObject, eventdata, handles)
% if isfield(handles,'PlotFigure') & ishandle(handles.PlotFigure),
%     close(handles.PlotFigure);
% end
delete(guimeasegmentplot)

% --- Executes on button press in Help button.
function pushbutton3_Callback(hObject, eventdata, handles)
dirnow = getappdata(0,'programDir');
eval(['web(''',dirnow,'\helpfiles\ViewMeasureSegment.htm'')'])

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


