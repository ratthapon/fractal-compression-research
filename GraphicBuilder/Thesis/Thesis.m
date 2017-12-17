
expDir = 'F:\IFEFSR\ExpSphinx\';
dataSet = 'FCMATLABRBS4FS816';
dataSet2 = 'FCMATLABRBS4FSPITCH3NHAR20MINCD1MINHD10EXCLUDEORIGINT9HARFS816';
nPitch = 3;
nHar = 20;
minCD = 1;
minHD = 10;
exclude = false;
harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
    16 * 1000, 16  * 1000, ...
    'npitch', nPitch, 'nhar', nHar, 'mincd', minCD, 'minhd', minHD, ...
    'enableexcludeorigin', exclude);
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);

sampleIdx = 30:30
reconFilePath = normpath([expDir dataSet '\wav\' fileList{sampleIdx} '.raw']);
reconFilePath2 = normpath([expDir dataSet2 '\wav\' fileList{sampleIdx} '.raw']);
originFilePath = normpath([expDir 'BASE16' '\wav\' fileList{sampleIdx} '.raw']);
subsampleFilePath = normpath([expDir 'BASE8' '\wav\' fileList{sampleIdx} '.raw']);

speech00 = rawread(subsampleFilePath);
[ CC00, FBE00, OUTMAG00, MAG00, H00, DCT00] = mfcc2( speech00, 8000);
OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];

speech0 = rawread(originFilePath);
[ CC0, FBE0, OUTMAG0, MAG0, H0, DCT0] = mfcc2( speech0, 16000);

speech1 = rawread(reconFilePath);
[ CC1, FBE1, OUTMAG1, MAG1, H1, DCT1] = mfcc2( speech1, 16000);

speech2 = rawread(reconFilePath2);
[ CC2, FBE2, OUTMAG2, MAG2, H2, DCT2] = mfcc2( speech2, 16000);

%% Different sampling rate
% extract the informations
% original signals
wavDir = 'F:/IFEFSR/ExpSphinx/';
wavName = '/wav/an4_clstk/fash/an251-fash-b.raw';
sigO8 = rawread([wavDir 'BASE8' wavName]);
sigO16 = rawread([wavDir 'BASE16' wavName]);
sigR8_rbs4 = rawread([wavDir dataSet wavName]);
sigR16_rbs4 = rawread([wavDir dataSet wavName]);

[MFCCO8, FBEO8, SPECO8] = mfcc2( sigO8, 8000);
SPECO8 = [SPECO8; zeros(size(SPECO8))]; % pad zeros
[MFCCO16, FBEO16, SPECO16] = mfcc2( sigO16, 16000 );

% recon signals
[MFCCR816_rbs4, FBER816_rbs4, SPECR816_rbs4] = mfcc2( sigR8_rbs4, 16000);
[MFCCR16_rbs4, FBER16_rbs4, SPECR16_rbs4] = mfcc2( sigR16_rbs4, 16000);

fig = figure(31);
plotCMPSpec(fig,...
    SPECO16, {'Spectrum of', '16-kHz original signal'}, ...
    SPECO8, {'Spectrum of', '8-kHz original signal'}, ...
    FBEO16, {'Mel frequency spectrum of', '16-kHz original signal'}, ...
    FBEO8, {'Mel frequency spectrum of', '8-kHz original signal'} ...
    )
set(gcf, 'position', [0 0 1200 500])

subplot(1,4,3),
ylabel('Mel frequency index');
ax = gca;
set(ax, 'YTick', [1:2:30]);
set(ax, 'YTickLabel', [1:2:30]);
subplot(1,4,4),
ylabel('Mel frequency index');
ax = gca;
set(ax, 'YTick', [1:2:30]);
set(ax, 'YTickLabel', [1:2:30]);

fig = figure(32);
plotCMPSpec(fig,...
    MFCCO16, {'MFCCs of', '16-kHz original signal'}, ...
    MFCCO8, {'MFCCs of', '8-kHz original signal'} ...
    )
set(gcf, 'position', [0 0 1200 500])

subplot(1,2,1),
ylabel('Pitch index');
ax = gca;
set(ax, 'YTick', [1:2:30]);
set(ax, 'YTickLabel', [1:2:30]);
subplot(1,2,2),
ax = gca;
ylabel('Pitch index');
set(ax, 'YTick', [1:2:30]);
set(ax, 'YTickLabel', [1:2:30]);



% debuging harfunc
plotCMPSpec(4011, ...
    OUTMAG0(:, 25:65), {'Spectrum of','original signal 16 kHz'}, ...
    OUTMAG1(:, 25:65), {'Spectrum of','FCD method 16->16 kHz'}, ...
    OUTMAG2(:, 25:65), {'Spectrum of','hybrid of FCD and HP method 16->16 kHz'} ...
    );
set(gcf, 'position', [0 0 1200 500])

g = fspecial('average', [1 512]);
diff1 = rangefilt( abs(zscore(OUTMAG0)-zscore(OUTMAG1)), ones(41, 3));
diff2 = rangefilt( abs(zscore(OUTMAG0)-zscore(OUTMAG2)), ones(41, 3));
plotCMPSpec(4012, ...
    diff1(:, 25:65), {'Difference of','16 kHz spectrum from','FCD method and original signal'}, ...
    diff2(:, 25:65), {'Difference of','16 kHz spectrum from','hybrid of FCD and HP method and original signal'} ...
    );
set(gcf, 'position', [0 0 1200 500])

figure(4012)
for subfig = 1:2
    subplot(1, 2, subfig),
    hold on,
    plot(repmat([ 100 220 380 520 ], 2, 1), repmat([2:3]', 1, 4), 'k');
    plot(1:700 , ones(1,700) * 2.5, 'k');
    text([15 260 550],[2.5 2.5 2.5], 'silence', ...
        'BackgroundColor', 'white', 'FontSize', 8);
    text([120 410],[2.5 2.5], 'speech', ...
        'BackgroundColor', 'white', 'FontSize', 8);
end

%%
% data obtain from debuging
[ sigWithHar, fundFreq, synthHar ] = harfunc(speech00, speech1);

[ Tw, Ts, ~, ~, ~, ~, ~, ~ ] = getMFCCSphinxParams();
Nw = round( 1E-3*Tw* 8000);    % frame duration (samples)
Ns = round( 1E-3*Ts* 8000);    % frame shift (samples)
frames = vec2frames( speech00, Nw, Ns, 'cols', @hamming, false );
dt = 1/8000;
t = 0:dt:length(speech00)*dt-dt;       % time index of sample
freq = (1:512) * 8/512 *1000;
frameIdx = 25;
originCeps(:, frameIdx) = cceps(frames(:, frameIdx));
timeRange = t(t>=2e-3 & t<=10e-3);
pitches = originCeps(t>=2e-3 & t<=10e-3, frameIdx);
  
%% pitches  
figure(306), plot(timeRange * 1000 * 100, pitches);
title('Pitches extracted from cepstrum extraction')
xlabel('time (delay) (ms)')
ylabel('magnitude')
set(gcf, 'position', [0 0 1200 500])

%% Peaks
% determine the pitch index
[~, sortedPitch] = findpeaks(pitches(:), ...
    'MinPeakDistance', minCD, 'SortStr', 'descend');
nPitch = min(nPitch, length(sortedPitch));

figure(307), 
plot(timeRange * 1000 * 100, pitches, 'b--');
hold on,
scatter(timeRange(sortedPitch(1:nPitch)) * 1000 * 100, ...
    pitches(sortedPitch(1:nPitch)), 'r');
hold off,

title('Peakes of pitches extracted from cepstrum extraction')
xlabel('time (delay) (ms)')
ylabel('magnitude')
set(gcf, 'position', [0 0 1200 500])

%% harmonic signal
df = 1/512;                            % nft per sample
stopFreq = 1;                           % nft
fh = (0:df:stopFreq-df)';               % seconds
I = sortedPitch(2);
% get the fundamental frequency from index
f0 = 1/timeRange(I);
fundFreq(frameIdx) = f0;
% caculate the new frequency index of pitch
f0FT = 16000/2/512/f0;
% synthesize the harmonic filter
illusSynthHar = (sin(2 * pi * 1/f0FT * fh - pi/2));

figure(3081),
plot(freq,illusSynthHar)

title('Harmonic pattern of a pitch')
xlabel('frequency (Hz)')
ylabel('magnitude')
set(gcf, 'position', [0 0 1200 500])
ylim([-1.1 1.1])

%%
harmonicPattern = ones(512, 1);
for p = 1:nPitch
    I = sortedPitch(p);
    
    % get the fundamental frequency from index
    f0 = 1/timeRange(I);
    fundFreq(frameIdx) = f0;
    
    % caculate the new frequency index of pitch
    f0FT = 16000/2/512/f0;
    
    % synthesize the harmonic filter
    harmonicPattern = harmonicPattern .*  ...
        (sin(2 * pi * 1/f0FT * fh - pi/2));
end
figure(3082),
plot(freq,harmonicPattern)

title('Harmonic pattern of multiple pitches')
xlabel('frequency (Hz)')
ylabel('magnitude')
set(gcf, 'position', [0 0 1200 500])
ylim([-1.1 1.1])


%% weighted harmonic signal
magFilt = exp(-(1:512)/512)';
harmonicPattern2 = harmonicPattern - min(harmonicPattern) ...
    / (max(harmonicPattern) - min(harmonicPattern)) ;
harmonicPattern2 = harmonicPattern2 + 1;
harmonicPattern2 = harmonicPattern2 .* magFilt;

figure(309),
plot(freq,harmonicPattern2)

title('Weighted harmonic pattern of multiple pitches')
xlabel('frequency (Hz)')
ylabel('magnitude')
set(gcf, 'position', [0 0 1200 500])
ylim([0 2.5])

%%
figure(311),
plot((1:length(speech00))/16000 * 1000, speech00')
title('8-kHz original speech signal')
xlabel('time (ms)')
ylabel('amplitude')
set(gcf, 'position', [0 0 1200 500])

figure(3102),
plot((1:length(speech2))/16000 * 1000, speech2')
title({'reconstructed 8-kHz-to-16-kHz speech signal', 'obtained from fractal code descriptor'})
xlabel('time (ms)')
ylabel('amplitude')
set(gcf, 'position', [0 0 1200 500])

%%
plotCMPSpec(3111, ...
    OUTMAG00, {'Spectrum of','8-kHz original speech signal'} ...
    );
set(gcf, 'position', [0 0 700 500])

plotCMPSpec(3112, ...
    OUTMAG1, {'Spectrum of','reconstructed 8-kHz-to-16-kHz speech signal', ...
    'obtained from fractal code descriptor'} ...
    );
set(gcf, 'position', [0 0 700 500])

plotCMPSpec(3121, ...
    OUTMAG2, {'Spectrum of','reconstructed 8-kHz-to-16-kHz speech signal', ...
    'obtained from hybrid of fractalc code descriptor and harmonicpattern generator'} ...
    );
set(gcf, 'position', [0 0 700 500])




