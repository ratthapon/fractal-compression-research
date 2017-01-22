load mtlb

origin8 = rawread('F:\IFEFSR\ExpSphinx\BASE8\wav\an4_clstk\fash\an251-fash-b.raw');
inWave = rawread('F:\IFEFSR\ExpSphinx\FCMATLABRBS4FS816\wav\an4_clstk\fash\an251-fash-b.raw');

segmentlen = 100;
noverlap = 90;
NFFT = 256;

figure, spectrogram(mtlb,segmentlen,noverlap,NFFT,Fs,'yaxis')

dt = 1/Fs;
I0 = round(0.1/dt);
Iend = round(0.25/dt);
x = mtlb(I0:Iend);

% Fs = 8000;
% x = origin8;

c = cceps(x);

t = 0:dt:length(x)*dt-dt;

trng = t(t>=2e-3 & t<=10e-3);
crng = c(t>=2e-3 & t<=10e-3);

[~,I] = max(crng);

fprintf('Complex cepstrum F0 estimate is %3.2f Hz.\n',1/trng(I))

plot(trng*1e3,crng)
xlabel('ms')

hold on
plot(trng(I)*1e3,crng(I),'o')
hold off

[b0,a0] = butter(2,325/(Fs/2));
xin = abs(x);
xin = filter(b0,a0,xin);
xin = xin-mean(xin);
x2 = zeros(length(xin),1);
x2(1:length(x)-1) = xin(2:length(x));
zc = length(find((xin>0 & x2<0) | (xin<0 & x2>0)));
F0 = 0.5*Fs*zc/length(x);
fprintf('Zero-crossing F0 estimate is %3.2f Hz.\n',F0)


% synthHar = sin(2 * pi * I * (1:128));
NFT = 256;                   % samples per second
f0FT = Fs/2/NFT/f0;
df = 1/NFT;                   % nft per sample
stopFreq = 1;             % nft
fh = (0:df:stopFreq-df)';     % seconds

f0 = 1/trng(I);

magFilt = exp(-(1:NFT)/NFT)';

synthHar = (sin(2 * pi * 1/f0FT * fh + 1/f0FT) + 1) .* magFilt;
figure, plot(synthHar)

originSpec = abs(fft(x, 512));
originSpec = originSpec(1:256);
addHarSpec = originSpec .* synthHar;
reconSig = real(ifft(addHarSpec, 8000));
figure, plot(originSpec)
figure, plot(addHarSpec)
figure, plot(reconSig)


figure, plot((1:256)/256 * 8000,(0.5*sin(2 * pi * 1/f0FT * fh - pi/2) + 0.5))
title(['Harmonic pattern of ' num2str(f0) ' Hz'])
ylabel('Magnitude')
xlabel('Frequency (Hz)')
set(gcf, 'Position', [100, 100, 400, 200]);

ceps = originCeps(:, i);
ceps = ceps(t>=2e-3 & t<=10e-3);
figure, plot(2e-3:(8e-3)/65:((10e-3) - (8e-3)/65), ceps)
hold on
plot(trng(I),crng(I),'ro')
hold off
title(['Potential Cepstrum  of original signal 8k'])
ylabel('Pitch magnitude')
xlabel('Time (ms)')
set(gcf, 'Position', [100, 100, 400, 200]);

figure, plot((1:256)/256 * 8000, magFilt)
title(['Exponential decay function'])
ylabel('Weight')
xlabel('Frequency (Hz)')
set(gcf, 'Position', [100, 100, 400, 200]);

figure, plot((1:256)/256 * 8000, (0.5*sin(2 * pi * 1/f0FT * fh - pi/2) + 0.5) .* magFilt)
title(['Weighted harmonic pattern'])
ylabel('Magnitude')
xlabel('Frequency (Hz)')
set(gcf, 'Position', [100, 100, 400, 200]);

[ specWithHar ] = addHarToSpecFromCeps( origin8, OUTMAG0, 8000, 16000 );

