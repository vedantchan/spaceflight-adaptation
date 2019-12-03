function [plugin_exist, plugin_name, plugin_path] = is_crp_plugin
% IS_CRP_PLUGIN   Checks if extern plugin exist and is executable
%    Used by CRP Toolbox

% Copyright (c) 2008-
% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
% http://www.pik-potsdam.de
%
% Copyright (c) 2005-2008
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2016/03/03 14:57:22 $
% $Revision: 4.4 $
%
% $Log: is_crp_plugin.m,v $
% Revision 4.4  2016/03/03 14:57:22  marwan
% updated input/output check (because Mathworks is removing downwards compatibility)
% bug in crqad_big fixed (calculation of xcf).
%
% Revision 4.3  2009/03/24 08:36:04  marwan
% copyright address updated
%
% Revision 4.2  2005/04/15 09:03:03  marwan
% minor bugfix in plugin section
%
% Revision 4.1  2005/04/08 09:03:53  marwan
% plugin added
%
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

global errcode

plugin_exist = 0;
plugin_path = '';
plugin_name = '';

if exist('rp_plugin','file')
      plugin_exist = 0;
      plugin_path = fileparts(which('rp_plugin'));
      plugin_name = rp_plugin;
      try
          [status dummy] = system([plugin_path,filesep,plugin_name,' -V']);
      catch
          status = 1;
      end
      if ~status, plugin_exist = 1; end
end
