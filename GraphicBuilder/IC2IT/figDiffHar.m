%FIGDIFFERENTSPECS Visualize the freq spectrum, mel spectrum, surf freq spectrum

%% read signals data
% original signals and their interpolated signal
wavDir = 'F:/IFEFSR/ExpSphinx/';
expDir = 'F:\IFEFSR\ExpSphinx\';
dataSet = 'FCMATLABRBS2FS';
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);
wavName = ['/wav/' fileList{30} '.raw'];
sigO8 = rawread([wavDir 'BASE8' wavName]);
sigO16 = rawread([wavDir 'BASE16' wavName]);
sigInt816 = interp(sigO8, 2, 4, 1.0);

% reconstructed using fractal coding
sigR8_rbs2 = rawread([wavDir 'FCMATLABRBS2FS816' wavName]);
sigR16_rbs2 = rawread([wavDir 'FCMATLABRBS2FS1616' wavName]);
sigR8_rbs4 = rawread([wavDir 'FCMATLABRBS4FS816' wavName]);
sigR16_rbs4 = rawread([wavDir 'FCMATLABRBS4FS1616' wavName]);

harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
    16 * 1000, 16  * 1000, ...
    'npitch', nPitch, 'nhar', nHar, 'mincd', minCD, 'minhd', minHD, ...
    'enableexcludeorigin', exclude);
sigR16_rbs4_har = harfunc(sigO16, sigR16_rbs4);

harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
    8 * 1000, 16  * 1000, ...
    'npitch', nPitch, 'nhar', nHar, 'mincd', minCD, 'minhd', minHD, ...
    'enableexcludeorigin', exclude);
sigR816_rbs4_har = harfunc(sigO8, sigR8_rbs4);

%% extract the informations
% original signals
[MFCCO8, FBEO8, SPECO8] = mfcc2( sigO8, 8000);
SPECO8 = [SPECO8; zeros(size(SPECO8))]; % pad zeros
[MFCCO16, FBEO16, SPECO16] = mfcc2( sigO16, 16000 );

% recon signals
[MFCCR816_rbs4, FBER816_rbs4, SPECR816_rbs4] = mfcc2( sigR8_rbs4, 16000);
[MFCCR16_rbs4, FBER16_rbs4, SPECR16_rbs4] = mfcc2( sigR16_rbs4, 16000);
[MFCCR816_rbs4_har, FBER816_rbs4_har, SPECR816_rbs4_har] = mfcc2( sigR816_rbs4_har, 16000);
[MFCCR16_rbs4_har, FBER16_rbs4_har, SPECR16_rbs4_har] = mfcc2( sigR16_rbs4_har, 16000);


fig = figure(4);
plotCMPSpec(fig,...
    SPECO16, {'Spectrum of', 'original signal 16 kHz'}, ...
    SPECO8, {'Spectrum of', 'original signal 8 kHz'}, ...
    SPECR16_rbs4, {'Spectrum of', 'reconstructed signal', '16->16 kHz'}, ...
    SPECR816_rbs4, {'Spectrum of', 'reconstructed signal', '8->16 kHz'} ...
    )
set(gcf, 'position', [0 0 900 300])

fig = figure(4);
plotCMPSpec(fig,...
    SPECO16, {'Spectrum of', '16-kHz original signal'}, ...
    SPECO8, {'Spectrum of', '8-kHz original signal'}, ...
    SPECR16_rbs4, {'Spectrum of', '16-kHz-to-16kHz', 'reconstructed signal'}, ...
    SPECR816_rbs4, {'Spectrum of', '8-kHz-to-16kHz', 'reconstructed signal'} ...
    )
set(gcf, 'position', [0 0 900 300])

fig = figure(5);
plotCMPSpec(fig,...
    abs(zscore(SPECO16) -zscore(SPECR16_rbs4)),...
    {'Spectrum of', 'reconstructed signal', '16->16 kHz'}, ...
    abs(zscore(SPECO16) -zscore(SPECR16_rbs4_har)), ...
    {'Spectrum of', 'reconstructed signal', '16->16 kHz'}, ...
    abs(zscore(SPECR16_rbs4) -zscore(SPECR816_rbs4_har)), ...
    {'Spectrum of', 'reconstructed signal', '8->16 kHz'} ...
    )
set(gcf, 'position', [0 0 900 300])

% subplot(1,6,3), 
% ylabel('Mel frequency index');
% ax = gca;
% set(ax, 'YTick', [1:2:30]);
% set(ax, 'YTickLabel', [1:2:30]);
% subplot(1,6,4), 
% ylabel('Mel frequency index');
% ax = gca;
% set(ax, 'YTick', [1:2:30]);
% set(ax, 'YTickLabel', [1:2:30]);
% 
% subplot(1,6,5), 
% ylabel('Pitch index');
% ax = gca;
% set(ax, 'YTick', [1:2:30]);
% set(ax, 'YTickLabel', [1:2:30]);
% subplot(1,6,6), 
% ax = gca;
% ylabel('Pitch index');
% set(ax, 'YTick', [1:2:30]);
% set(ax, 'YTickLabel', [1:2:30]);



