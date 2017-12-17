%FIGDIFFERENTSPECS Visualize the freq spectrum, mel spectrum, surf freq spectrum

%% read signals data
% original signals and their interpolated signal
wavDir = 'F:/IFEFSR/ExpSphinx/';
wavName = '/wav/an4_clstk/fash/an251-fash-b.raw';
sigO8 = rawread([wavDir 'BASE8' wavName]);
sigO16 = rawread([wavDir 'BASE16' wavName]);
sigInt816 = interp(sigO8, 2, 4, 1.0);

% reconstructed using fractal coding
sigR8_rbs2 = rawread([wavDir 'FCMATLABRBS2FS816' wavName]);
sigR16_rbs2 = rawread([wavDir 'FCMATLABRBS2FS1616' wavName]);
sigR8_rbs4 = rawread([wavDir 'FCMATLABRBS4FS816' wavName]);
sigR16_rbs4 = rawread([wavDir 'FCMATLABRBS4FS1616' wavName]);

%% extract the informations
% original signals
[MFCCO8, FBEO8, SPECO8] = mfcc2( sigO8, 8000);
SPECO8 = [SPECO8; zeros(size(SPECO8))]; % pad zeros
[MFCCO16, FBEO16, SPECO16] = mfcc2( sigO16, 16000 );

% recon signals
[MFCCR816_rbs4, FBER816_rbs4, SPECR816_rbs4] = mfcc2( sigR8_rbs4, 16000);
[MFCCR16_rbs4, FBER16_rbs4, SPECR16_rbs4] = mfcc2( sigR16_rbs4, 16000);

fig = figure(1);
plotCMPSpec(fig,...
    SPECO16, {'Spectrum of', '16-kHz original signal'}, ...
    SPECO8, {'Spectrum of', '8-kHz original signal'}, ...
    FBEO16, {'Mel frequency spectrum of', '16-kHz original signal'}, ...
    FBEO8, {'Mel frequency spectrum of', '8-kHz original signal'} ...
    )
set(gcf, 'position', [0 0 900 300])

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

fig = figure(2);
plotCMPSpec(fig,...
    MFCCO16, {'MFCCs of', '16-kHz original signal'}, ...
    MFCCO8, {'MFCCs of', '8-kHz original signal'} ...
    )
set(gcf, 'position', [0 0 900 300])

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


