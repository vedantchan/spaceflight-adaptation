function txtout = replacesymbol(txtin,symbolfind,symbolreplace)
% txtout = replacesymbol(txtin,symbolinfind,symbolreplace)
% REPLACESYMBOL replaces all occurences of a given symbol 'symbolfind' with 
% another symbol 'symbolreplace' (can also be blank '') in a given cell array 
% of strings or matrix of strings 'txtin'.
% INPUT 
% - txtin       : the input cell array of strings or matrix of strings.
% - symbolfind  : the symbol to be found
% - symbolreplace : the symbol to replace symbolfind.
% OUTPUT
% - txtout      : same as txtin but with symbolfind replaced by
%                 symbolreplace.
%========================================================================
%     <replacesymbol.m>, v 1.0 2010/02/11 22:09:14  Kugiumtzis & Tsimpiris
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

 
if iscell(txtin)
    [n,m]=size(txtin);
    for i=1:n
        for j=1:m
            if n>1 & m>1
                txtout{i,j}=strrep(txtin{i,j},symbolfind,symbolreplace);
            elseif n==1
                txtout{j}=strrep(txtin{j},symbolfind,symbolreplace);
            elseif m==1
                txtout{i}=strrep(txtin{i},symbolfind,symbolreplace);
            else
                txtout=strrep(txtin,symbolfind,symbolreplace);
            end
        end
    end
elseif ischar(txtin)
    [n,m]=size(txtin);
    txtout=str2mat(strrep(txtin(1,:),symbolfind,symbolreplace));
    if n>1
        for i=2:n
            txtout=str2mat(txtout,strrep(txtin(i,:),symbolfind,symbolreplace));
        end
    end
end
