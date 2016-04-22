% testADF
close all
mfccparams; % load mfcc params

% fs = [11025 22050 44100];
fs = [16000 32000 48000];
thresh = '1E-6';
load(['F:\IFEFSR\APFractalCode\16k_NECTEC_matlabResampling_Thresh' '1E-5' 'ds1\CF001_Va001_001.mat']);
deADF_low2low = apFractalDecode(f,fs(1),fs(1),[]);
deADF_low2med = apFractalDecode(f,fs(1),fs(2),[]);
deADF_low2high = apFractalDecode(f,fs(1),fs(3),[]);
adf11 = f;

load(['F:\IFEFSR\APFractalCode\32k_NECTEC_matlabResampling_Thresh' '1E-5' 'ds1\CF001_Va001_001.mat']);
deADF_med2low = apFractalDecode(f,fs(2),fs(1),[]);
deADF_med2med = apFractalDecode(f,fs(2),fs(2),[]);
deADF_med2high = apFractalDecode(f,fs(2),fs(3),[]);
adf22 = f;

load(['F:\IFEFSR\APFractalCode\48k_NECTEC_matlabResampling_Thresh' '1E-5' 'ds1\CF001_Va001_001.mat']);
deADF_high2low = apFractalDecode(f,fs(3),fs(1),[]);
deADF_high2med = apFractalDecode(f,fs(3),fs(2),[]);
deADF_high2high = apFractalDecode(f,fs(3),fs(3),[]);
adf44 = f;

oriWave_1 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
    '\48\CF001_Va001\CF001_Va001_001.wav']);
oriWave_1 = oriWave_1(:,1);
[ MFCCsoriWave_1,FBEoriWave_1,OUTMAG_1 ] =  mfcc( oriWave_1, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

oriWave_2 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
    '\16\CF001_Va001\CF001_Va001_001.wav']);
oriWave_2 = oriWave_2(:,1);
[ MFCCsoriWave_2,FBEoriWave_2,OUTMAG_2 ] =  mfcc( oriWave_2, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

oriWave_3 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
    '\32\CF001_Va001\CF001_Va001_001.wav']);
oriWave_3 = oriWave_3(:,1);
[ MFCCsoriWave_3,FBEoriWave_3,OUTMAG_3 ] =  mfcc( oriWave_3, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

[ MFCCs11to11,FBE11to11,OUTMAG11,FRAMES11  ] =  mfcc( deADF_low2low, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs11to22,FBE11to22 ] =  mfcc( deADF_low2med, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs11to44,FBE11to44] =  mfcc( deADF_low2high, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

[ MFCCs22to11,FBE22to11 ] =  mfcc( deADF_med2low, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs22to22,FBE22to22,OUTMAG22,FRAMES22 ] =  mfcc( deADF_med2med, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs22to44,FBE22to44 ] =  mfcc( deADF_med2high, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

[ MFCCs44to11,FBE44to11,~,~, H11] =  mfcc( deADF_high2low, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs44to22,FBE44to22,~,~, H22] =  mfcc( deADF_high2med, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs44to44,FBE44to44,OUTMAG44,FRAMES44, H44] =  mfcc( deADF_high2high, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );



figure,
subplot(3,3,1),imagesc(MFCCs11to11);
subplot(3,3,2),imagesc(MFCCs11to22);
subplot(3,3,3),imagesc(MFCCs11to44);

subplot(3,3,4),imagesc(MFCCs22to11);
subplot(3,3,5),imagesc(MFCCs22to22);
subplot(3,3,6),imagesc(MFCCs22to44);

subplot(3,3,7),imagesc(MFCCs44to11);
subplot(3,3,8),imagesc(MFCCs44to22);
subplot(3,3,9),imagesc(MFCCs44to44);

figure,
subplot(3,3,1),imagesc(FBE11to11);
subplot(3,3,2),imagesc(FBE11to22);
subplot(3,3,3),imagesc(FBE11to44);

subplot(3,3,4),imagesc(FBE22to11);
subplot(3,3,5),imagesc(FBE22to22);
subplot(3,3,6),imagesc(FBE22to44);

subplot(3,3,7),imagesc(FBE44to11);
subplot(3,3,8),imagesc(FBE44to22);
subplot(3,3,9),imagesc(FBE44to44);

figure,
subplot(3,1,1),imagesc(H11);axis([0 60 1 12]);
subplot(3,1,2),imagesc(H22);axis([0 60 1 12]);
subplot(3,1,3),imagesc(H44);axis([0 60 1 12]);

figure,
subplot(1,3,1),imagesc(OUTMAG_1(1:60,:));title('Original');
subplot(1,3,2),imagesc(OUTMAG_2(1:60,:));
subplot(1,3,3),imagesc(OUTMAG_3(1:60,:));

figure,
subplot(1,3,1),imagesc(OUTMAG11(1:60,:));title('Recon');
subplot(1,3,2),imagesc(OUTMAG22(1:60,:));
subplot(1,3,3),imagesc(OUTMAG44(1:60,:));

% figure,
% subplot(1,3,1),plot(FRAMES11);
% subplot(1,3,2),plot(FRAMES22);
% subplot(1,3,3),plot(FRAMES44);

figure,
subplot(3,1,1),plot(deADF_low2high); axis([0 inf -0.2 0.2]);title('Recon');
subplot(3,1,2),plot(deADF_med2high); axis([0 inf -0.2 0.2]);
subplot(3,1,3),plot(deADF_high2high); axis([0 inf -0.2 0.2]);

figure,
subplot(3,1,1),plot(oriWave_1); axis([0 inf -0.2 0.2]);title('Original');
subplot(3,1,2),plot(oriWave_2); axis([0 inf -0.2 0.2]);
subplot(3,1,3),plot(oriWave_3); axis([0 inf -0.2 0.2]);

figure,
subplot(3,1,1),imagesc(MFCCsoriWave_1); title('Original');
subplot(3,1,2),imagesc(MFCCsoriWave_2); 
subplot(3,1,3),imagesc(MFCCsoriWave_3); 

figure,
subplot(3,1,1),imagesc(FBEoriWave_1); title('Original');
subplot(3,1,2),imagesc(FBEoriWave_2); 
subplot(3,1,3),imagesc(FBEoriWave_3); 

% close all;
% n = [4 8 16 32 64 128 256 512 1024];
% for s=n
%     v = [];
%     for i=1:s:size(wORI,1)-s
%         v = [v var(wORI(i:i+s,1))];
%     end
%     figure,bar(v);axis([0 inf 0 0.0001]);
% end

% close all;
figure(10),
[r1, r2] = pearsoncorrelation(FBEoriWave_1,FBEoriWave_2);
subplot(1,2,1),scatter(1:28,r1); axis([0 inf 0 1.1]);title('Original');
[r3, r4] = pearsoncorrelation(FBE11to44,FBE22to44);
subplot(1,2,2),scatter(1:28,r3); axis([0 inf 0 1.1]);title('Fractal');

figure(11),
[r5, r6] = pearsoncorrelation(FBEoriWave_3,FBEoriWave_2);
subplot(1,2,1),scatter(1:28,r5); axis([0 inf 0 1.1]);title('Original');
[r7, r8] = pearsoncorrelation(FBE44to44,FBE22to44);
subplot(1,2,2),scatter(1:28,r7); axis([0 inf 0 1.1]);title('Fractal');