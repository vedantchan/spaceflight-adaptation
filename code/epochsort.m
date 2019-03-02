function [files] = epochsort(prefiles)
%sortfiles : Sorts given files by epoch, using identifiers in name. 

files = cell(1,5)

for i = 1:length(prefiles)
    
    if contains(prefiles{i},'UP1')
        files{1} = prefiles{i};
    elseif contains(prefiles{i},'UP2')
        files{2} = prefiles{i};
    elseif contains(prefiles{i},'P1')
        files{3} = prefiles{i};
    elseif contains(prefiles{i},'P2')
        files{4} = prefiles{i};
    elseif contains(prefiles{i},'Rec')
        files{5} = prefiles{i};
    elseif contains(prefiles{i},'REC')
        files{5} = prefiles{i};
    end
end

return

end

