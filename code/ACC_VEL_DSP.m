afunction [Result]=ACC_VEL_DSP(Data,fs,TprRat)

% fs : Sampling Frequency
% TprRat : Window Tapered Ratio  for tukeywin windowing .Use 0 if no windowing required


Raw = Data';


%initialize Acc,Vel,Dsp
Acc = zeros(size(Raw,1),size(Raw,2));
for K = 1:1:size(Raw,2)   
    %Acceleration
    Sig = Raw(:,K);                                     % calling raw data
    Sig = detrend(Sig);  
    CosTpr = window('tukeywin',length(Sig),TprRat);     % windowing 'tukeywin'
    Sig = Sig.*CosTpr;                                                           
    Acc(:,K) =Sig;
    clear Sig;
    
    %Velocity
    Sig = cumtrapz([0:length(Acc(:,K))-1]/fs,Acc(:,K));
    Sig = detrend(Sig);
    CosTpr = window('tukeywin',length(Sig),TprRat); 
    Sig = Sig.*CosTpr;
    Vel(:,K) = Sig;
    clear Sig
    
    %Displacement
    Sig = cumtrapz([0:length(Acc(:,K))-1]/fs,Vel(:,K));
    Sig = detrend(Sig);
    CosTpr = window('tukeywin',length(Sig),TprRat);
    Sig = Sig.*CosTpr;
    Dsp(:,K) = Sig;
    clear Sig K    
end
Result.ACC=Acc';
Result.VEL=Vel';
Result.DSP=Dsp';
end