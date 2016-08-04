close all; clear all;
% 3d fourier
spectrum = [];

%% gen test data
inFName = ['F:\IFEFSR\SpeechData\an4\wav\' ...
    'an4_clstk\fash\an251-fash-b.raw'];
fid = fopen(inFName, 'r');
sig = fread(fid, 'int16');
sig = sig(6001:6256);
fclose(fid);
% figure(2),plot(sig)

%% fast fourier transform
nfft = 2^nextpow2( size(sig,1) );     % length of FFT analysi
hnfft = nfft/2+1;
rawSpectrum = abs( fft(sig,nfft,1) );

%% 3d plot section
K = 10; % N frequecy
coloreMap = jet(K);  % See the help for COLORMAP to see other choices.
figure(1),plot3([1:size(sig,1)]', repmat(0,size(sig)), (sig/2^2) ...
                ,'linewidth',2); % origin sig
amplitude = zeros(K,1);

% filterbank to K bands.
spectrum = zeros(K+1,1);
chBandwidth = floor(nfft/K);
for k = 0:K-1
   spectrum(k+1) = sum(rawSpectrum(k*chBandwidth + 1 : (k+1)*chBandwidth));
end

for k = 1:K
    % bandpass filtering 
    bandPassSpectrum = zeros(size(spectrum));
    bandPassSpectrum(k+1) = spectrum(k); % floor(nfft/K)
    
    % ifft
    iSig = ifft(bandPassSpectrum,nfft,1);
    amplitude(k) = max(abs(iSig));
    hold on, grid on;
    figure(1),plot3([1:nfft]' , repmat(k,nfft,1), iSig(1:nfft), ...
        'color',coloreMap(k,:),'linewidth',2);
   
end
set(gca,'XTick',[32:32:nfft]);
set(gca,'XTickLabel',[1:nfft/32]*2);
set(gca,'YTick',0:K);
% freqLabel = [{'Original Signal'}];
freqLabel = [{'Original Signal'}];
for i = 1:K
    freqLabel = [freqLabel, {num2str(i * 800)}];
end
set(gca,'YTickLabel',freqLabel);


stem3(zeros(K, 1), [1:K]', amplitude,'linewidth',2);
plot3(zeros(K, 1), [1:K]', zeros(K, 1),'linewidth',2);
xlabel('time (ms)'),ylabel('frequency (Hz)'),zlabel('spectrum magnitude');



