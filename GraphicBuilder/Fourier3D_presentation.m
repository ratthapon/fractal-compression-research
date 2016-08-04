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
% figure(1),plot3([1:size(sig,1)]', repmat(0,size(sig)), (sig/2^2) ...
%                 ,'linewidth',2); % origin sig
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
    if k == 1 || k == K
       iSig = iSig*0.5; 
    end
    amplitude(k) = max(abs(iSig));
    hold on, grid on;
    figure(1),plot3(repmat(k,nfft,1), [1:nfft]', iSig(1:nfft), ...
        'color',coloreMap(k,:),'linewidth',2);
   
end
set(gca,'YTick',[32:32:nfft]);
set(gca,'YTickLabel',[]);
set(gca,'XTick',0:K);
% freqLabel = [{'Original Signal'}];
freqLabel = [{''}];
for i = 1:K
    freqLabel = [freqLabel, {num2str(i * 800)}];
end
set(gca,'XTickLabel',freqLabel);

stem3([1:K]', zeros(K, 1), amplitude,'linewidth',1.5);
plot3([1:K]', zeros(K, 1), zeros(K, 1),'linewidth',1);
xlabel('frequency (Hz)'),ylabel('time'),zlabel('magnitude');
axis([0 K 32 nfft -400 400]);

%% sig without partition
Fc = 1;
Fs = 10;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:3)';     % seconds

x = 0.3*sin(2*pi*Fc*t);
sampleIdx = 1:size(t,1);
f2 = figure(2);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
hold on
stem(sampleIdx-1,x(sampleIdx),'LineWidth',1);
axis([0 size(t,1)-1 -0.5 0.5]);
title('Signal')
xlabel('time')
ylabel('amplitude')
set(f2, 'Position', [100, 100, 500, 150]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);

%% spectrum
f3 = figure(3);
stem(amplitude,'LineWidth',1);
axis([0 size(amplitude,1)+1 -100 900]);
title('Frequency Spectrum')
ylabel('magnitude')
xlabel('frequency (Hz)')
set(f3, 'Position', [100, 100, 500, 150]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gca,'XTick',0:2:K);
set(gca,'XTickLabel',freqLabel(1:2:end));