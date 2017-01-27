%%
Fs = 4000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.025;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
Fc = 250;

pulseFilter = sin(2 * pi * 40 * t);
pulseFilter(end/2:end) = 0;

latency = 0.015; % sec

sWave = 1.3 * sin(2 * pi * Fc * t);
sWave = sWave .* pulseFilter;

%%
domain = -1:0.01:1;
figure(7),
set(gcf, 'Position', [100, 100, 800, 500]);
grid on
fh1 = addOddHar(domain, 1, 1.0);
fh2 = addOddHar(domain, 2, 1.0);
fh3 = addOddHar(domain, 3, 1.0);
fh4 = addEvenHar(domain);
fh5 = addOddEvenHar(domain);
subplot( 2, 2, 1), plot(domain, fh1), title('Spatial response of odd harmonic function T1');
subplot( 2, 2, 2), plot(domain, fh2), title('Spatial response of odd harmonic function T2');
subplot( 2, 2, 3), plot(domain, fh3), title('Spatial response of odd harmonic function T3');
subplot( 2, 2, 4), plot(domain, fh4), title('Spatial response of even harmonic function');

grid off

%% odd harmonic
oddharsigT1 = addOddHar(zscore(sWave), 1, 1.0);
oddharsigT2 = addOddHar(zscore(sWave), 2, 1.0);
oddharsigT3 = addOddHar(zscore(sWave), 3, 1.0);

plotCMPSigSpecCeps(1, Fs, sWave, 'Original', oddharsigT1, 'Odd harmonic T1' )
plotCMPSigSpecCeps(2, Fs, sWave, 'Original', oddharsigT2, 'Odd harmonic T2' )
plotCMPSigSpecCeps(3, Fs, sWave, 'Original', oddharsigT3, 'Odd harmonic T3' )

%% even harmonic
evenharsig = addEvenHar(zscore(sWave));
plotCMPSigSpecCeps(4, Fs, sWave, 'Original', evenharsig, 'Even harmonic' )

%% odd-even harmonic
oddevenharsig = addOddEvenHar(zscore(sWave));
plotCMPSigSpecCeps(5, Fs, sWave, 'Original', oddevenharsig, 'Odd-even harmonic' )

%% pitch's harmonic
sWave_128 = sWave;
sWave_128(128) = 0;
spec = abs(fft(zscore(sWave_128), 258));
halfSpec = spec(1:end/2);
[ specWithHar ] = addHarToSpecFromCeps( zscore(sWave_128), halfSpec, 4000, 8000 );
halfSpecWithHar = specWithHar(1:2:end);
DCT = dctm( 50, length(halfSpecWithHar) );
cc0 = DCT * log(1 + halfSpec(1:2:end));
cc= DCT * log(1 + halfSpecWithHar);

plotCMPSigSpecCeps(6, Fs, sWave, 'Original', sWave, 'Pitch harmonic' )
figure(6), 
subplot(2, 3, 2),
stem((1:length(halfSpec(1:2:end))) / length(halfSpec(1:2:end)) * Fs/2, halfSpec(1:2:end))
title(['Original spectrum'])
ylabel('Mag.')
xlabel('Frequency (Hz)')

subplot(2, 3, 3),
stem((1:length(cc)) * Fs / length(cc)^2, cc0)
title(['Original cepstrum'])
ylabel('Mag.')
xlabel('Time (ms)')

subplot(2, 3, 4),
plot((1:length(sWave)) / Fs * 1000, sWave)
title(['Pitch harmonic signal'])
ylabel('Amp.')
xlabel('Time (Ms)')

subplot(2, 3, 5),
stem((1:length(halfSpecWithHar)) / length(halfSpecWithHar) * Fs/2, halfSpecWithHar)
title(['Pitch harmonic spectrum'])
ylabel('Mag.')
xlabel('Frequency (Hz)')

subplot(2, 3, 6),
stem((1:length(cc)) * Fs / length(cc)^2, cc)
title(['Pitch harmonic cepstrum'])
ylabel('Mag.')
xlabel('Time (ms)')

%%  Real data
origin16 = rawread('F:\IFEFSR\ExpSphinx\BASE16\wav\an4_clstk\fash\an251-fash-b.raw');
origin8 = rawread('F:\IFEFSR\ExpSphinx\BASE8\wav\an4_clstk\fash\an251-fash-b.raw');
recWave = rawread('F:\IFEFSR\ExpSphinx\FCMATLABRBS4FS816\wav\an4_clstk\fash\an251-fash-b.raw');

% generate signals with harmonic
recWaveH1 = addOddHar(zscore(recWave), 1, 1.0);
recWaveH2 = addOddHar(zscore(recWave), 2, 1.0);
recWaveH3 = addOddHar(zscore(recWave), 3, 1.0);
recWaveH4 = addEvenHar(zscore(recWave));
recWaveH5 = addOddEvenHar(zscore(recWave));

% extract information
[ CC08, FBE08, OUTMAG08, MAG08, H08, DCT08] = mfcc2( origin8, 8000);
OUTMAG08 = [OUTMAG08; zeros(size(OUTMAG08)) ];
[ CC016, FBE016, OUTMAG016, ~, ~, ~] = mfcc2( origin16, 16000);
[ CC0REC, FBE0REC, OUTMAG0REC, ~, ~, ~] = mfcc2( recWave, 16000);

[ CC0RECH1, FBE0RECH1, OUTMAG0RECH1, ~, ~, ~] = mfcc2( recWaveH1, 16000);
[ CC0RECH2, FBE0RECH2, OUTMAG0RECH2, ~, ~, ~] = mfcc2( recWaveH2, 16000);
[ CC0RECH3, FBE0RECH3, OUTMAG0RECH3, ~, ~, ~] = mfcc2( recWaveH3, 16000);
[ CC0RECH4, FBE0RECH4, OUTMAG0RECH4, ~, ~, ~] = mfcc2( recWaveH4, 16000);
[ CC0RECH5, FBE0RECH5, OUTMAG0RECH5, ~, ~, ~] = mfcc2( recWaveH5, 16000);

[ OUTMAG0RECH6 ] = addHarToSpecFromCeps( origin8, OUTMAG0REC, 8000, 16000 );
[ Tw, Ts, alpha, M, N, L, LF, HF ] = getMFCCSphinxParams();
[ CC,FBE, OUTMAG, MAG, H, DCT] = mfcc3( recWave, origin8, 8000, 16000, Tw, Ts, alpha, @hamming, [LF, HF], M, N, L );

% n-pitch harmonic
recWaveH6_1 = addHarToSigFromCeps( origin8, recWave, 8000, 16000);
recWaveH6_3 = addHarToSigFromCeps( origin8, recWave, 8000, 16000, 2 );
recWaveH6_5 = addHarToSigFromCeps( origin8, recWave, 8000, 16000, 3 );
recWaveH6_7 = addHarToSigFromCeps( origin8, recWave, 8000, 16000, 4 );
recWaveH6_9 = addHarToSigFromCeps( origin8, recWave, 8000, 16000, 5 );

[ CC0RECH6_1, FBE0RECH6_1, OUTMAG0RECH6_1, ~, ~, ~] = mfcc2( recWaveH6_1, 16000);
[ CC0RECH6_3, FBE0RECH6_3, OUTMAG0RECH6_3, ~, ~, ~] = mfcc2( recWaveH6_3, 16000);
[ CC0RECH6_5, FBE0RECH6_5, OUTMAG0RECH6_5, ~, ~, ~] = mfcc2( recWaveH6_5, 16000);
[ CC0RECH6_7, FBE0RECH6_7, OUTMAG0RECH6_7, ~, ~, ~] = mfcc2( recWaveH6_7, 16000);
[ CC0RECH6_9, FBE0RECH6_9, OUTMAG0REC, ~, ~, ~] = mfcc2( recWaveH6_9, 16000);

% visualize spectrum
plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH1, 'Spectrum reconstructed harmonic T1 8->16kHz');

plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH2, 'Spectrum reconstructed harmonic T2 8->16kHz');

plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH3, 'Spectrum reconstructed harmonic T3 8->16kHz');

plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH4, 'Spectrum reconstructed harmonic T4 8->16kHz');

plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH5, 'Spectrum reconstructed harmonic T5 8->16kHz');

plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH6, 'Spectrum reconstructed harmonic T6 8->16kHz');

plotCMPSpec(figure, ...
    OUTMAG08, 'Spectrum original 8kHz', ...
    OUTMAG016, 'Spectrum original 16kHz', ...
    OUTMAG0REC, 'Spectrum reconstructed 8->16kHz', ...
    OUTMAG0RECH6_3, 'Spectrum reconstructed harmonic T6-3 8->16kHz');

