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
figure(2),plot(sig)

%% fast fourier transform
nfft = 2^nextpow2( size(sig,1) );     % length of FFT analysi
hnfft = nfft/2+1;
spectrum = abs( fft(sig,nfft,1) );

%% 3d plot section
K = 10; % N frequecy
coloreMap = jet(K);  % See the help for COLORMAP to see other choices.
figure(1),plot3([1:size(sig,1)]',repmat(0,size(sig)),(sig/2^2) ...
                ,'linewidth',2); % origin sig
for k = 1:K
    % bandpass filtering 
    bandPassSpectrum = zeros(size(spectrum));
    bandPassSpectrum(k) = spectrum(k); % floor(nfft/K)
    
    % ifft
    iSig = ifft(bandPassSpectrum,nfft,1);
    hold on, grid on;
    figure(1),plot3([1:nfft]', repmat(k,nfft,1), iSig(1:nfft), ...
        'color',coloreMap(k,:),'linewidth',2);
    xlabel('time'),ylabel('frequency order (0 = original)'),zlabel('spectrum magnitude');
    
end





