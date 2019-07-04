function[cdim,error] = shcorrdim(signal1,signal2,m,tau,makeplot)
% Calculate number of points on trajectory within
% certain distance of given reference point, and repeat
% using evenly-spaced reference points, separated by skip
% (i.e. to use all points as reference, set skip=1).
% Cr=correlation integral estimate array
% r=distance criterion array
% skip=increment in choosing reference points
% A=trajectory matrix (each row is a point on the trajectory)
% Twin=?Theiler window? length
%

if nargin < 5
    makeplot = 0;
end

if length(signal2)>length(signal1)
    signal1 = resample(signal1,length(signal2),length(signal1));
elseif length(signal2) < length(signal1)
    signal2 = resample(signal2,length(signal1),length(signal2));
end

signal1 = normalize(signal1);
signal2 = normalize(signal2);

clear xe
N2 = length(signal1) - tau*(m-1);
for mi = 1:m
    if mod(mi,2) == 1
        xe(:,mi) = signal1([1:N2] + tau * (mi-1));
    elseif mod(mi,2) == 0
        xe(:,mi) = signal2([1:N2] + tau * (mi-2)); % CHANGE THIS BACK TO 2
    end
end
 

A = xe;
r = logspace(-1,2,100);
Twin = 0;
skip = 1;
[N,M]=size(A);
rsize=length(r);
k=zeros(rsize,1);
nn=N/skip;
iref=0;
kount=0;


%
% Loop to pick reference point
for j=1:skip:N
    AA=A-ones(N,1)*A(j,:); % subtract point j from others AA=max(abs(AA')); % distance from j to others (max norm) AA(max(1,j-Twin):min(N,j+Twin))=...
    inf*ones(1,length(max(1,j-Twin):min(N,j+Twin))); % substitute inf for pts in Twin
    kount1=N-length(max(1,j-Twin):min(N,j+Twin)); kount=kount+kount1;
    iref=iref+1;
    % number of ref points
    
    %
    AA=sort(AA');
    AA=AA(find(AA~=inf)); %
    i1=find(r<min(AA)); 
    i2=find(r>max(AA));
    k(i2)=k(i2)+kount1*ones(size(i2))';
    %
    i2=min(i2);
    i=max(i1); 
    if(isempty(i)) 
        i=1; 
    end
    for ii=1:length(AA)
        if(AA(ii)>r(i)) k(i)=k(i)+ii-1;
            i=i+1;
            if(i==i2|i>length(r)) 
                break; 
            end; 
        end
    end
end;

Cr=(k')/kount;
Cr;

Cr = log10(Cr).';
r = log10(r).';

idx = (find(Cr == 0,1))-1;
Cr(idx:end) = [];
r(idx:end) = [];


f1 = glmfit(r,Cr);
cdim = (f1(2));

if makeplot == 1
    hold off
    plot(r,Cr,'k.')
    hold on
    plot(r,f1(2)*r + f1(1))
    plot(r, Cr - (f1(2)*r + f1(1)))
end