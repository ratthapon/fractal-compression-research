origin16 = rawread('F:\IFEFSR\ExpSphinx\BASE16\wav\an4_clstk\fash\an251-fash-b.raw');
origin8 = rawread('F:\IFEFSR\ExpSphinx\BASE8\wav\an4_clstk\fash\an251-fash-b.raw');
inWave = rawread('F:\IFEFSR\ExpSphinx\FCMATLABRBS4FS816\wav\an4_clstk\fash\an251-fash-b.raw');

oddharsig = addOddHar(zscore(inWave), 3, 2.5);
evenharsig = addEvenHar(zscore(inWave));
oddevenharsig = addOddEvenHar(zscore(inWave));

figure(1),
subplot(4,1,1), plot(inWave); title('Input wave FCMATLABRBS4FS816');
subplot(4,1,2), plot(oddharsig); title('Odd harmonic signal');
subplot(4,1,3), plot(evenharsig); title('Even harmonic signal');
subplot(4,1,4), plot(oddevenharsig); title('Odd-even harmonic signal');

[ CC08, FBE08, OUTMAG08, MAG08, H08, DCT08] = mfcc2( origin8, 8000);
OUTMAG08 = [OUTMAG08; zeros(size(OUTMAG08)) ];
[ CC016, FBE016, OUTMAG016, MAG016, H016, DCT016] = mfcc2( origin16, 16000);

[ CC1, FBE1, OUTMAG1, MAG1, H1, DCT1] = mfcc2( oddharsig, 16000);
[ CC2, FBE2, OUTMAG2, MAG2, H2, DCT2] = mfcc2( evenharsig, 16000);
[ CC3, FBE3, OUTMAG3, MAG3, H3, DCT3] = mfcc2( oddevenharsig, 16000);
[ CC0, FBE0, OUTMAG0, MAG0, H0, DCT0] = mfcc2( inWave, 16000);

figure(2),
subplot(1,4,1), imagesc(OUTMAG0); title('Input signal FCMATLABRBS4FS816 spectrum');
subplot(1,4,2), imagesc(OUTMAG1); title('Odd harmonic spectrum');
subplot(1,4,3), imagesc(OUTMAG2); title('Even harmonic spectrum');
subplot(1,4,4), imagesc(OUTMAG3); title('Odd-even harmonic spectrum');

figure(3),
subplot(1,2,1), imagesc(OUTMAG08); title('Spectrum original signal 8k');
subplot(1,2,2), imagesc(OUTMAG016); title('Spectrum original signal 16k');

%%
Fs = 4000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.025;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
Fc = 250;

pulseFilter = sin(2 * pi * 40 * t);
pulseFilter(end/2:end) = 0;

latency = 0.015; % sec

sWave = 0.8 * sin(2 * pi * Fc * t);
sWave = sWave .* pulseFilter;

sampleLag = latency * Fs ;
dsWave = [ zeros(sampleLag, 1); sWave(1:end - sampleLag) ];

hWave = sWave + dsWave;
hWave = addOddEvenHar(zscore(sWave));
% sWave = dsWave;

figure(4), 
subplot(3,1,1), plot(sWave); title('Synth sine-wave f0 250Hz fs 4000Hz');
subplot(3,1,2), plot(dsWave); title('Delay latency = 0.015 sec');
subplot(3,1,3), plot(hWave); title('Odd-even harmonic signal');

sWaveCeps = rceps(sWave);
sWaveCeps = sWaveCeps(1:end);
sWaveFreq = abs(fft(sWave, 64));
sWaveFreq = sWaveFreq(1:end);

hWave = addOddHar(zscore(sWave));
hWaveCeps = rceps(hWave);
hWaveCeps = hWaveCeps(1:end);
hWaveFreq = abs(fft(hWave, 64));
hWaveFreq = hWaveFreq(1:end);

figure(5),
subplot(4,1,1), stem(sWaveFreq); title('Spectrum of synth wave');
subplot(4,1,2), stem(sWaveCeps); title('Cepstrum of synth wave');
subplot(4,1,3), stem(hWaveFreq); title('Spectrum of Odd harmonic synth wave');
subplot(4,1,4), stem(hWaveCeps); title('Cepstrum of Odd harmonic synth wave');


hWave = addEvenHar(zscore(sWave));
hWaveCeps = rceps(hWave);
hWaveCeps = hWaveCeps(1:end);
hWaveFreq = abs(fft(hWave, 64));
hWaveFreq = hWaveFreq(1:end);

figure(6),
subplot(4,1,1), stem(sWaveFreq); title('Spectrum of synth wave');
subplot(4,1,2), stem(sWaveCeps); title('Cepstrum of synth wave');
subplot(4,1,3), stem(hWaveFreq); title('Spectrum of even harmonic synth wave');
subplot(4,1,4), stem(hWaveCeps); title('Cepstrum of even harmonic synth wave');


hWave = addOddEvenHar(zscore(sWave));
hWaveCeps = rceps(hWave);
hWaveCeps = hWaveCeps(1:end);
hWaveFreq = abs(fft(hWave, 64));
hWaveFreq = hWaveFreq(1:end);

figure(7),
subplot(4,1,1), stem(sWaveFreq); title('Spectrum of synth wave');
subplot(4,1,2), stem(sWaveCeps); title('Cepstrum of synth wave');
subplot(4,1,3), stem(hWaveFreq); title('Spectrum of Odd-even harmonic synth wave');
subplot(4,1,4), stem(hWaveCeps); title('Cepstrum of Odd-even harmonic synth wave');



%% harmonic from FC



