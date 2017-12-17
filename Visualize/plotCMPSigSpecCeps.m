function plotCMPSigSpecCeps(fig, fs, varargin )
%PLOTCMPSPECTRUM Compare spectrum and cepstrum of signals
% fig - output figure number
% varargin{i} - signal samples
% varargin{i + 1} - title

figure(fig),
set(fig, 'Position', [100, 100, 1400, 500]);
nSubplot = length(varargin)/2;

for fIdx = 1:nSubplot
    sigData = varargin{(fIdx - 1)*2 + 1};
    sigName = varargin{(fIdx - 1)*2 + 2};
    
    spec = abs(fft(sigData, 128));
    halfSpec = spec(1:end/2);
    ceps = rceps(sigData);
    halfCeps = ceps(1:end/2);
    
    subplot(nSubplot, 3, (fIdx-1)*3 + 1), 
    plot((1:length(sigData)) / fs * 1000, sigData)
    title([sigName ' signal'])
    ylabel('Amp.')
    xlabel('Time (Ms)')
    
    subplot(nSubplot, 3, (fIdx-1)*3 + 2), 
    stem((1:length(halfSpec)) / length(halfSpec) * fs/2, halfSpec)
    title([sigName ' spectrum'])
    ylabel('Mag.')
    xlabel('Frequency (Hz)')
    
    subplot(nSubplot, 3, (fIdx-1)*3 + 3), 
    stem((1:length(halfCeps)) * fs / length(halfCeps)^2, halfCeps)
    title([sigName ' cepstrum'])
    ylabel('Mag.')
    xlabel('Time (ms)')
    
end