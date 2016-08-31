function f = plotSigVsFreqRes( sig, caption, Fs )
%PLOTSIGVSFREQRES Summary of this function goes here
%   Detailed explanation goes here
f = figure();

subplot(2,1,1), plot(sig);
title(caption);

subplot(2,2,3), psd(sig);
title('Power spectrum density');
set(gca,'XTickLabel',[0:10]*(Fs/20));

spec = abs(fft(sig, 256));
subplot(2,2,4), stem(spec(1:128));
title('Frequency Spectrum');
set(gca,'XTick',[0:10]*(128/10));
set(gca,'XTickLabel',[0:10]*(Fs/20));

end

