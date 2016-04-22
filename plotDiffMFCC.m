% show different between two feature of diff sampling rate
Tw = 25;                % analysis frame duration (ms)
Ts = 20;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)

Fs11k = ['F:\IFEFSR\CropSpeech\11k_train\11k_speaker_1_sp_1-01.wav'];
Fs22k = ['F:\IFEFSR\CropSpeech\22k_train\22k_speaker_1_sp_1-01.wav'];
Fs44k = ['F:\IFEFSR\CropSpeech\44k_train\44k_speaker_1_sp_1-01.wav'];
listFileName = [{Fs11k};{Fs22k};{Fs44k}];

% Read speech samples, sampling rate and precision from file
[ speech, fs ] = audioread( listFileName{1} );
speech = speech(:,1);
% Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = ...
    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCs1 = MFCCs(2:end,:);

% Read speech samples, sampling rate and precision from file
[ speech, fs ] = audioread( listFileName{2} );
speech = speech(:,1);
% Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = ...
    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCs2 = MFCCs(2:end,:);

% Read speech samples, sampling rate and precision from file
[ speech, fs ] = audioread( listFileName{3} );
speech = speech(:,1);
% Feature extraction (feature vectors as columns)
[ MFCCs, FBEs, frames ] = ...
    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCs3 = MFCCs(2:end,:);

plotMfcc(MFCCs3, FBEs, frames,speech, M, C, Ts, fs)

% for i=1:55
%     plot([MFCCs1(:,i) MFCCs2(:,i) MFCCs3(:,i) ])
%     legend('11k','22k','44k');
% end

% for i=1:55
%     scatter([f11k(i,1) f22k(i,1) f44k(i,1) ]',[f11k(i,2) f22k(i,2) f44k(i,2) ]' )
%     legend('11k','22k','44k');
% end
% fractal plot plot([f11k(i,1:2) f22k(i,1:2) f44k(i,1:2) ])
