Tw = 25;                % analysis frame duration (ms)
Ts = 20;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)


wav = audioread('F:\IFEFSR\SpeechData\TestDAT\11k_speaker_1_sp_1-01.wav');
load('F:\IFEFSR\Output\sampling11k_trainfs8dstep1\1');
decode = fractalDecode(f,11025,8,1,11025,[],[]);
decode2 = fractalDecode(f,11025,8,1,44100,[],[]);
% signal = fractalDecode(f,aFs(sIdx),eFs(sIdx),1,dFs,[],[]);


load(['F:\IFEFSR\MData\22k_frames_fractal_16fs\TrainFFCDatas']);
catMFCCs = [];

% Read speech samples, sampling rate and precision from file
codes = FFCDatas{1}(1,:);
frames = [];
for i = 1:size(codes,2)
    signal = fractalDecode(codes{i},22050,16,1,44100,[],[]);
    frames = [frames signal];
end
% Feature extraction (feature vectors as columns)
[ MFCCs ] = ...
    frames_mfcc( frames, 44100, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCs = MFCCs(2:end,:);


figure(1),plot(wav)
figure(2),plot(decode)
figure(3),plot(decode2)
figure(6),image(MFCCs)