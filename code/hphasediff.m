function [phasediff] = hphasediff(signal1,signal2,makeplots)


signal1 = normalize(signal1);
signal2 = normalize(signal2);

% Resample to same length

if length(signal2)>length(signal1)
    signal1 = resample(signal1,length(signal2),length(signal1));
elseif length(signal2) < length(signal1)
    signal2 = resample(signal2,length(signal1),length(signal2));
end

% Hilbert Transform

hsignal1 = imag(hilbert(signal1));
hsignal2 = imag(hilbert(signal2));


% Plotting

if makeplots == 1

    figure()
    subplot(1,2,1)
    plot(signal1)
    hold on 
    plot(hsignal1)
    title('Signal 1')
    legend('Signal 1','Hilbert')
    xlabel('Samples')
    ylabel('Signal')
    subplot(1,2,2)
    plot(signal2)
    hold on
    plot(hsignal2)
    title('Signal 2')
    legend('Signal 2','Hilbert')
    xlabel('Samples')
    ylabel('Signal')
end

phasediff = atan((dot(hsignal1,signal2) - dot(signal1,hsignal2)) / ((dot(signal2,signal1) + dot(hsignal2,hsignal1))));

end