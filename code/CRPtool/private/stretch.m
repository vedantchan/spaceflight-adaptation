function stretch(hCRP,xscale,yscale,Nx,Ny)
% STRETCH   Stretches/unstretches the CRP plot
%    Used by CRP Toolbox

% Copyright (c) 2008-
% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
% http://www.pik-potsdam.de
%
% Copyright (c) 1998-2008
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2016/03/03 14:57:23 $
% $Revision: 4.9 $
%
% $Log: stretch.m,v $
% Revision 4.9  2016/03/03 14:57:23  marwan
% updated input/output check (because Mathworks is removing downwards compatibility)
% bug in crqad_big fixed (calculation of xcf).
%
% Revision 4.8  2009/03/24 08:36:04  marwan
% copyright address updated
%
% Revision 4.7  2004/11/10 07:04:29  marwan
% initial import
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

  if get(findobj('Tag','Stretch','Parent',gcf),'value')==1
     set(findobj('Tag','CRPPlot','Parent',hCRP),'PlotBoxAspectRatio',[max(Nx, Ny) max(Nx, Ny) 1])
     set(findobj('Tag','DataPlot1','Parent',hCRP),'xlim',[yscale(1) yscale(Ny)])
     set(findobj('Tag','DataPlot2','Parent',hCRP),'xlim',[xscale(1) xscale(Nx)])
  elseif get(findobj('Tag','Stretch','Parent',gcf),'value')==0
     if Nx>=Ny
        set(findobj('Tag','DataPlot2','Parent',hCRP),'xlim',[xscale(1) xscale(Nx)])
        set(findobj('Tag','DataPlot1','Parent',hCRP),'xlim',[xscale(1) xscale(Nx)])
     else
        set(findobj('Tag','DataPlot2','Parent',hCRP),'xlim',[yscale(1) yscale(Ny)])
        set(findobj('Tag','DataPlot1','Parent',hCRP),'xlim',[yscale(1) yscale(Ny)])
     end
     set(findobj('Tag','CRPPlot','Parent',hCRP),'PlotBoxAspectRatio',[Nx Ny 1])
  end
