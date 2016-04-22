[x1,fq1] = audioread('F:\IFEFSR\NECTEC_matlabResampling\8\CF001_Va001\CF001_Va001_001.wav');
[x2,fq2] = audioread('F:\IFEFSR\NECTEC_matlabResampling\16\CF001_Va001\CF001_Va001_001.wav');
[x3,fq3] = audioread('F:\IFEFSR\NECTEC_matlabResampling\32\CF001_Va001\CF001_Va001_001.wav');

mfccparams;
M = 12;                 % number of filterbank channels
LF = 130;               % lower frequency limit (Hz)
HF = 4000;              % upper frequency limit (Hz)

[ MFCCsx1, FBEx1 ] = ...
    mfcc( x1 , fq1,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

[ MFCCsx2, FBEx2 ] = ...
    mfcc( x2 , fq2,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

[ MFCCsx3, FBEx3 ] = ...
    mfcc( x3 , fq3,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

[r1_3, r2_3] = pearsoncorrelation(FBEx1,FBEx2);
[r1_4, r2_4] = pearsoncorrelation(FBEx3,FBEx2);
figure(1),
subplot(3,2,1),imagesc(FBEx1);
subplot(3,2,3),imagesc(FBEx2);
subplot(3,2,5),imagesc(FBEx3);

[r1_1, r2_1] = pearsoncorrelation(MFCCsx1,MFCCsx2);
[r1_2, r2_2] = pearsoncorrelation(MFCCsx3,MFCCsx2);
figure(1),
subplot(3,2,2),imagesc(MFCCsx1);
subplot(3,2,4),imagesc(MFCCsx2);
subplot(3,2,6),imagesc(MFCCsx3);
