function [S,t,N2] = cross_recur(signal1,signal2,m,tau)

if length(signal2)>length(signal1)
    signal1 = resample(signal1,length(signal2),length(signal1));
elseif length(signal2) < length(signal1)
    signal2 = resample(signal2,length(signal1),length(signal2));
end

signal1 = normalize(signal1);
signal2 = normalize(signal2);

% 2 Variable Cross-Recurrence

t = 1:length(signal1);

N2 = length(signal1) - tau*(m-1);
clear xe

for mi = 1:m
    if mod(mi,2) == 1
        xe(:,mi) = signal1([1:N2] + tau * (mi-1));
    elseif mod(mi,2) == 0
        xe(:,mi) = signal2([1:N2] + tau * (mi-2));
    end
end


x1 = repmat(xe, N2, 1);
x2 = reshape(repmat(xe(:), 1, N2)', N2 * N2, m);

S = sqrt(sum( (x1 - x2) .^ 2, 2 ));
S = reshape(S, N2, N2);

% imagesc(t(1:N2), t(1:N2), -S);
% c = colorbar('Direction','reverse');
% title(c,'Negative Distance');
% colormap jet;
% axis square;
% caxis([-4,0])
% xlabel('Samples'), ylabel('Samples');

end