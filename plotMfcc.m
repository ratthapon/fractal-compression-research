function plotMfcc(MFCCs, FBEs, frames,speech, M, C, Ts, fs)

% Generate data needed for plotting
[ Nw, NF ] = size( frames );                % frame length and number of frames
time_frames = [0:NF-1]*Ts*0.001+0.5*Nw/fs;  % time vector (s) for frames
time = [ 0:length(speech)-1 ]/fs;           % time vector (s) for signal samples
logFBEs = 20*log10( FBEs );                 % compute log FBEs for plotting
logFBEs_floor = max(logFBEs(:))-50;         % get logFBE floor 50 dB below max
logFBEs( logFBEs<logFBEs_floor ) = logFBEs_floor; % limit logFBE dynamic range


% Generate plots
figure('Position', [30 30 800 600], 'PaperPositionMode', 'auto', ...
    'color', 'w', 'PaperOrientation', 'landscape', 'Visible', 'on' );

subplot( 311 );
plot( time, speech, 'k' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Time (s)' );
ylabel( 'Amplitude' );
title( 'Speech waveform');

subplot( 312 );
imagesc( time_frames, [1:M], logFBEs );
axis( 'xy' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Time (s)' );
ylabel( 'Channel index' );
title( 'Log (mel) filterbank energies');

subplot( 313 );
imagesc( time_frames, [1:C+1], MFCCs(1:end,:) ); % HTK's TARGETKIND: MFCC
%imagesc( time_frames, [1:C+1], MFCCs );       % HTK's TARGETKIND: MFCC_0
axis( 'xy' );
xlim( [ min(time_frames) max(time_frames) ] );
xlabel( 'Time (s)' );
ylabel( 'Cepstrum index' );
title( 'Mel frequency cepstrum' );

% Set color map to grayscale
colormap( 1-colormap('gray') );