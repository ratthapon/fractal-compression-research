close all; clear all;
mfccparams; % load mfcc params
Fs = 8000;
HF = 6800;
LF = 130;
M = 40;
C = 13;
Tw = 25.625;
Ts = 10;
alpha = 0.97;
L = M;%22;                 % cepstral sine lifter parameter
% view signal
tuneSet = [
    {'AN4_8K_TUNE_ORI'}, ...
    {'AN4_8K_TUNE_NONE'}, ...
    {'AN4_8K_TUNE_MAXCOEFF_0.99'}, ...
    {'AN4_8K_TUNE_MAXCOEFF_1.1'}, ...
    {'AN4_8K_TUNE_MAXCOEFF_1.2'}, ...
    {'AN4_8K_TUNE_THRESH_E-6'}, ...
    {'AN4_8K_TUNE_R_2_64'}, ...
    {'AN4_8K_TUNE_R_4_64'}, ...
    {'AN4_8K_TUNE_CV'}
    ];
cmpPSNR = zeros(9,1);
cmpSNR = zeros(9,1);

for i = 1:size(tuneSet,2)
    inDir = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\'];
    signal = audioread([inDir tuneSet{i} '\an4test_clstk\fcaw\' 'an407-fcaw-b.wav']);
    oSignal = audioread([inDir tuneSet{1} '\an4test_clstk\fcaw\' 'an407-fcaw-b.wav']);
    SIG(i) = {signal};

    figure(1),subplot(9,1,i)
    plot(signal);
    
    cmpPSNR(i,1) = PSNR(oSignal,signal)
    cmpSNR(i,1) = snr(signal,oSignal)
    
    [MFCCs,FBE] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    figure(1+i),
    imagesc(FBE);
end




