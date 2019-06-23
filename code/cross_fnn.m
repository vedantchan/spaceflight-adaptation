function [emdim,tau] = cross_fnn(signal1,signal2,makeplot)

if nargin < 3
    makeplot == 0
end

if length(signal2)>length(signal1)
    signal1 = resample(signal1,length(signal2),length(signal1));
elseif length(signal2) < length(signal1)
    signal2 = resample(signal2,length(signal1),length(signal2));
end

signal1 = normalize(signal1);
signal2 = normalize(signal2);

%% Determine Tau

corrs = abs(xcorr(signal1,signal2,'coeff'));
[~,maxidx] = max(corrs);
corrs(1:maxidx-1) = [];
tau = find(corrs < max(corrs)/exp(1),1);

%% fnn
fnns = [];
for m = 1:10
    
    N2 = length(signal1) - tau*(m-1);
    clear xe
    for mi = 1:m
        if mod(mi,2) == 1
            xe(:,mi) = signal1([1:N2] + tau * (mi-1));
        elseif mod(mi,2) == 0
            xe(:,mi) = signal2([1:N2] + tau * (mi-1)); %CHANGE THIS BACK TO 2
        end
    end
    
    Rtol = 15;
    falsecount = 0;
    
    for i = 1:length(xe(:,1))-1
        Rdmin = 100;
        for j = 1:length(xe(:,1))-1
            
            Rd = norm(xe(i,:)-xe(j,:));
            if j == i
                continue;
            elseif Rd < Rdmin
                idx = j;
                Rdmin = Rd;
            end
            
        end
        
        j = idx;
        Rdnext =  norm(xe(i+1,:)-xe(j+1,:));
        Rd = norm(xe(i,:)-xe(j,:));
        R = Rdnext/Rd;
        if R > Rtol
            falsecount = falsecount + 1;
        end
        
    end
    
    fnnprop = falsecount/length(xe(:,1));
    fnns = [fnns fnnprop];
    
    if fnnprop < 0.005
        break
    end
    
end

emdim = find(fnns < 0.01,1);

if mod(emdim,2) == 1
    emdim = emdim + 1;
end

if makeplot == 1
    figure
    plot(fnns,'LineWidth',2);
    title('FNN')
    xlabel('Embedding Dimension')
    ylabel('Proportion of False Nearest Neighbors')
    
    clear xe
    m = emdim;
    N2 = length(signal1) - tau*(m-1);
    for mi = 1:m
        if mod(mi,2) == 1
            xe(:,mi) = signal1([1:N2] + tau * (mi-1));
        elseif mod(mi,2) == 0
            xe(:,mi) = signal2([1:N2] + tau * (mi-1));
        end
    end
    
    figure
    if emdim < 3
        plot(xe(:,1),xe(:,2))
    elseif emdim >= 3
        plot3(xe(:,1),xe(:,2),xe(:,3))
    end
end
end