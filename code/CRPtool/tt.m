function [a_out, b_out, c_out]=tt(x)
% TT   Mean trapping time and its distribution.
%    A=TT(X) computes the mean of the length of the vertical 
%    line structures in a recurrence plot, so called trapping 
%    time TT.
%
%    [A B]=TT(X) computes the TT and the lengths of the
%    found vertical lines, stored in B. In order to get the 
%    histogramme of the line lengths, simply call 
%    HIST(B,[1 MAX(B)]).
%
%    Examples: X = crp(rand(200,1),1,1,.3,'fan','silent');
%              [v v_dist] = tt(X);
%              hist(v_dist,200)
%
%    See also CRQA, DL, RPDE.

% Copyright (c) 2008-
% Norbert Marwan, Potsdam Institute for Climate Impact Research, Germany
% http://www.pik-potsdam.de
%
% Copyright (c) 2001-2008
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% $Date: 2017/03/30 14:33:27 $
% $Revision: 3.11 $
%
% $Log: tt.m,v $
% Revision 3.11  2017/03/30 14:33:27  marwan
% fixing a bug in tt.m if applied to CRP
%
% Revision 3.10  2016/03/03 14:57:40  marwan
% updated input/output check (because Mathworks is removing downwards compatibility)
% bug in crqad_big fixed (calculation of xcf).
%
% Revision 3.9  2014/09/23 07:07:50  marwan
% RT corrected
%
% Revision 3.8  2013/08/22 06:35:01  marwan
% bugfix in estimation black and white vertical lines
%
% Revision 3.7  2010/06/30 12:02:52  marwan
% Help text modified
%
% Revision 3.6  2009/03/24 08:33:47  marwan
% copyright address changed
%
% Revision 3.5  2008/04/29 14:50:06  marwan
% fixed problem of empty RP
%
% Revision 3.4  2007/12/20 16:26:57  marwan
% includes also white vertical lines
%
% Revision 3.3  2005/11/23 07:29:14  marwan
% help text updated
%
% Revision 3.2  2005/03/16 11:19:02  marwan
% help text modified
%
% Revision 3.1  2004/11/10 07:07:35  marwan
% initial import
%
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or any later version.

narginchk(1,1)
nargoutchk(0,3)
    
%a_out = NaN; b_out = NaN; c_out = NaN;

warning off
try

    if any(x(:))


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for black vertical lines
        xb=double(x); 
        xb(end+1,:)=0;xb=double(xb(:));
        z=diff(xb);
        z0=find(z==1); % begin of black sequence
        z1=find(z==-1); % end of black sequence


        % measure the length of black lines
        if z0(1)>z1(1)
          z0(2:end+1,1)=z0(1:end);z0(1,1)=0;
          if length(z0)>length(z1) 
             z0(end)=[];
          end
        end

        t=sort(z1-z0);
        t1=t(find(t-1));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for white vertical lines
        
        % if LOI is not present then put it in!
        if ~all(diag(x))
           x = double(x) + eye(size(x));
        end
        x(x > 1) = 1;
        
        for i = 1:size(x,2)
            i_ = find(x(:,i));
            i1 = min(i_); i2 = max(i_);
            x(1:i1,i) = 1;
            x(i2:end,i) = 1;
        end

        xw=double(x); xw(end+1,:)=1;
        zw=diff(xw(:));
        z0w=find(zw==-1); % begin of white sequence
        z1w=find(zw==1); % end of white sequence


        % measure the length of white lines
        if z0w(1)>z1w(1)
          z0w(1)=[]; 
          if length(z1w)>length(z0w) 
             z1w(end)=[];
          end
        end
        if length(z1w)>length(z0w) 
             z0w=[1;z0w];
        end

        tw=sort(z1w-z0w);
        t1w=tw(find(tw-1));

        if nargout==3
           c_out=zeros(length(tw),1);
           c_out=tw+1; % +1 correction to get the correct RT
        end

        if nargout>=2
           b_out=zeros(length(t),1);
           b_out=t;
        end

        if nargout>0
           if isempty(t1), a_out=0;
           else, a_out=mean(t1); 
           end
        else
           mean(t1)
        end

    else

        if nargout==3
           c_out=NaN;
        end

        if nargout>=2
           b_out=NaN;
        end

        if nargout>0
           a_out=NaN;
        else
           NaN
        end

    end

    warning on

catch
    if nargout==3
        c_out=NaN;
    end

    if nargout>=2
        b_out=NaN;
    end

    if nargout>0
        a_out=NaN;
    else
        NaN
    end
end
