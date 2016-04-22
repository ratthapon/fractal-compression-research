%% for debug feature
Tw = 32;                % analysis frame duration (ms)
Ts = 16;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 12;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 12;                 % cepstral sine lifter parameter
LF = 130;               % lower frequency limit (Hz)
HF = 5500;              % upper frequency limit (Hz)


% w11 = audioread('F:\IFEFSR\SpeechData\TestDAT_rawResampling\11k_speaker_1_sp_1-01.wav');
% w22 = audioread('F:\IFEFSR\SpeechData\TestDAT_rawResampling\22k_speaker_1_sp_1-01.wav');
w44 = audioread('F:\IFEFSR\SpeechData\TestDAT_rawResampling\44k_speaker_1_sp_1-01.wav');
% w44_2 = audioread('F:\IFEFSR\SpeechData\TestDAT_matlabResampling\44k_speaker_1_sp_1-02.wav');

% sampleIdx22 =1:(44100/22050):size(w44,1);
% sampleIdx11 =1:(44100/11025):size(w44,1);
% w22 = w44(sampleIdx22);
% w11 = w44(sampleIdx11);
w22 = resample(w44,22050,44100);
w11 = resample(w44,11025,44100);

% nw11 = (w11 - mean(w11)) / std(w11);
% nw11 = nw11 / norm(nw11);
% nw22 = (w22 - mean(w22)) / std(w22);
% nw22 = nw22 / norm(nw22);
% nw44 = (w44 - mean(w44)) / std(w44);
% nw44 = nw44 / norm(nw44);
% audiowrite('nw11.wav',nw11,11025)
% audiowrite('nw22.wav',nw22,22050)
% audiowrite('nw44.wav',nw44,44100)

w22to11 = resample(w22,11025,22050);
w44to11 = resample(w44,11025,44100);

load('F:\IFEFSR\FractalCode\11k_train_rawResampling_Fs8ds1\11k_speaker_1_sp_1-01.mat');
f11 = f;
load('F:\IFEFSR\FractalCode\22k_train_rawResampling_Fs16ds1\22k_speaker_1_sp_1-01.mat');
f22 = f;
load('F:\IFEFSR\FractalCode\44k_train_rawResampling_Fs32ds1\44k_speaker_1_sp_1-01.mat');
f44 = f;
denoiseLevel = 1;
denoiseMethod = 'db1';
de11to11 = fractalDecode(f11,11025,8,1,11025,[],[]);
de11to11 = (de11to11 - mean(de11to11)) / std(de11to11);
de11to11 = de11to11 / norm(de11to11);
de11to11 = cmddenoise(de11to11,denoiseMethod,denoiseLevel);
% noise_de11to11 = noiseLevel * rand(1, length(de11to11));
% de11to11 = de11to11 + noise_de11to11;

de11to22 = fractalDecode(f11,11025,8,1,22050,[],[]);
de11to22 = (de11to22 - mean(de11to22))  / std(de11to22);
de11to22 = de11to22 / norm(de11to22);
de11to22 = cmddenoise(de11to22,denoiseMethod,denoiseLevel);
% noise_de11to22 = noiseLevel * rand(1, length(de11to22));
% de11to22 = de11to22 + noise_de11to22;

de11to44 = fractalDecode(f11,11025,8,1,44100,[],[]);
de11to44 = (de11to44 - mean(de11to44)) / std(de11to44);
de11to44 = de11to44 / norm(de11to44);
de11to44 = cmddenoise(de11to44,denoiseMethod,denoiseLevel);
% noise_de11to44 = noiseLevel * rand(1, length(de11to44));
% de11to44 = de11to44 + noise_de11to44;

de22to44 = fractalDecode(f22,22050,16,1,44100,[],[]);
de22to44 = (de22to44 - mean(de22to44)) / std(de22to44);
de22to44 = de22to44 / norm(de22to44);
de22to44 = cmddenoise(de22to44,denoiseMethod,denoiseLevel);
% noise_de22to44 = noiseLevel * rand(1, length(de22to44));
% de22to44 = de22to44 + noise_de22to44;

de22to22 = fractalDecode(f22,22050,16,1,22050,[],[]);
de22to22 = (de22to22 - mean(de22to22,2)) / std(de22to22);
de22to22 = de22to22 / norm(de22to22);
de22to22 = cmddenoise(de22to22,denoiseMethod,denoiseLevel);

de22to11 = fractalDecode(f22,22050,16,1,11025,[],[]);
de22to11 = (de22to11 - mean(de22to11,2)) / std(de22to11);
de22to11 = de22to11 / norm(de22to11);
de22to11 = cmddenoise(de22to11,denoiseMethod,denoiseLevel);

de44to44 = fractalDecode(f44,44100,32,1,44100,[],15);
de44to44 = (de44to44 - mean(de44to44)) / std(de44to44);
de44to44 = de44to44 / norm(de44to44);
de44to44 = cmddenoise(de44to44,denoiseMethod,denoiseLevel);

de44to22 = fractalDecode(f44,44100,32,1,22050,[],[]);
de44to22 = (de44to22 - mean(de44to22,2)) / std(de44to22);
de44to22 = de44to22 / norm(de44to22);
de44to22 = cmddenoise(de44to22,denoiseMethod,denoiseLevel);

de44to11 = fractalDecode(f44,44100,32,1,11025,[],[]);
de44to11 = (de44to11 - mean(de44to11)) / std(de44to11);
de44to11 = de44to11 / norm(de44to11);
de44to11 = cmddenoise(de44to11,denoiseMethod,denoiseLevel);

%% original
[ MFCCs,FBE11,MAG11 ] = ...
    mfcc( w11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsw11 = MFCCs(2:end,:);
[ MFCCs,FBE22,MAG22 ] = ...
    mfcc( w22, 22050, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsw22 = MFCCs(2:end,:);
[ MFCCs,FBE44,MAG44 ] = ...
    mfcc( w44, 44100, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsw44 = MFCCs(2:end,:);

%% resampling
[ MFCCs,FBE11r22,MAG11r22 ] = ...
    mfcc( w22to11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsw11r22 = MFCCs(2:end,:);
[ MFCCs,FBE11r44,MAG11r44 ] = ...
    mfcc( w44to11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsw11r44 = MFCCs(2:end,:);

%% de 11k
[ MFCCs,FBE11to11,MAG11to11 ] = ...
    mfcc( de11to11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd11to11 = MFCCs(2:end,:);
[ MFCCs,FBE11to22,MAG11to22 ] = ...
    mfcc( de11to22, 22050, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd11to22 = MFCCs(2:end,:);
[ MFCCs,FBE11to44,MAG11to44 ] = ...
    mfcc( de11to44, 44100, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd11to44 = MFCCs(2:end,:);

%% de 22k
[ MFCCs,FBE22to11,MAG22to11 ] = ...
    mfcc( de22to11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd22to11 = MFCCs(2:end,:);
[ MFCCs,FBE22to22,MAG22to22 ] = ...
    mfcc( de22to22, 22050, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd22to22 = MFCCs(2:end,:);
[ MFCCs,FBE22to44,MAG22to44 ] = ...
    mfcc( de22to44, 44100, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd22to44 = MFCCs(2:end,:);

%% de 44k
[ MFCCs,FBE44to11,MAG44to11 ] = ...
    mfcc( de44to11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd44to11 = MFCCs(2:end,:);
[ MFCCs,FBE44to22,MAG44to22 ] = ...
    mfcc( de44to22, 22050, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd44to22 = MFCCs(2:end,:);
[ MFCCs,FBE44to44,MAG44to44 ] = ...
    mfcc( de44to44, 44100, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
MFCCsd44to44 = MFCCs(2:end,:);

%% normalize feature
% FBE11to11 = FBE11to11 - repmat(mean(FBE11to11,2),1,size(FBE11to11,2));
% FBE11to11(FBE11to11<0) = 0;
% FBE11to22 = FBE11to22 - repmat(mean(FBE11to22,2),1,size(FBE11to22,2));
% FBE11to22(FBE11to22<0) = 0;
% FBE11to44 = FBE11to44 - repmat(mean(FBE11to44,2),1,size(FBE11to44,2));
% FBE11to44(FBE11to44<0) = 0;
% 
% FBE22to11 = FBE22to11 - repmat(mean(FBE22to11,2),1,size(FBE22to11,2));
% FBE22to11(FBE22to11<0) = 0;
% FBE22to22 = FBE22to22 - repmat(mean(FBE22to22,2),1,size(FBE22to22,2));
% FBE22to22(FBE22to22<0) = 0;
% FBE22to44 = FBE22to44 - repmat(mean(FBE22to44,2),1,size(FBE22to44,2));
% FBE22to44(FBE22to44<0) = 0;
% 
% FBE44to11 = FBE44to11 - repmat(mean(FBE44to11,2),1,size(FBE44to11,2));
% FBE44to11(FBE44to11<0) = 0;
% FBE44to22 = FBE44to22 - repmat(mean(FBE44to22,2),1,size(FBE44to22,2));
% FBE44to22(FBE44to22<0) = 0;
% FBE44to44 = FBE44to44 - repmat(mean(FBE44to44,2),1,size(FBE44to44,2));
% FBE44to44(FBE44to44<0) = 0;
%% show figuure
% figure(1),
% figure(1),
% subplot(3,1,1);plot(w11);title('Wave 11k')
% subplot(3,1,2);plot(w22);title('Wave 22 resample to 11')
% subplot(3,1,3);plot(w44);title('Wave 44 resample to 11')
% 
figure(2),
subplot(4,1,1);plot([de11to11']);title('Fractal code 11k decode to wave 44k')
subplot(4,1,2);plot([de11to22']);title('Fractal code 22k decode to wave 44k')
subplot(4,1,3);plot([de11to44']);title('Fractal code 44k decode to wave 44k')
subplot(4,1,4);plot([w11]);title('wave 11')
% 
% figure(2),
% subplot(2,1,1);plot(de11to11)
% subplot(2,1,2);image(MFCCsd11to11)
% 
% figure(3),
% subplot(2,1,1);plot(de11to22)
% subplot(2,1,2);image(MFCCsd11to22)
% 
% figure(4),
% subplot(2,1,1);plot(de44to44)
% subplot(2,1,2);image(MFCCsd44to44)

figure(3),
% subplot(3,3,1);imagesc(log(FBE11));title('Filterbank enery of wave 11k')
% subplot(3,3,2);imagesc(log(FBE11r22));title('Filterbank enery of wave 11k resample from 22k')
% subplot(3,3,3);imagesc(log(FBE11r44));title('Filterbank enery of wave 11k resample from 44k')
subplot(3,3,2);imagesc(MFCCsw11)
subplot(3,3,5);imagesc(MFCCsw22)
subplot(3,3,8);imagesc(MFCCsw44)
subplot(3,3,1);imagesc(log(FBE11));title('Filterbank enery of wave 11k')
subplot(3,3,4);imagesc(log(FBE22));title('Filterbank enery of wave 22k')
subplot(3,3,7);imagesc(log(FBE44));title('Filterbank enery of wave 44k')

subplot(3,3,3);imagesc(MAG11);title('MAG 11k')
subplot(3,3,6);imagesc(MAG22);title('MAG 22k')
subplot(3,3,9);imagesc(MAG44);title('MAG 44k')

figure(6),
subplot(3,3,1);imagesc(log(FBE11to11));title('Filterbank enery of code 11k decode to 11k')
subplot(3,3,4);imagesc(log(FBE11to22));title('Filterbank enery of code 11k decode to 22k')
subplot(3,3,7);imagesc(log(FBE11to44));title('Filterbank enery of code 11k decode to 44k')
subplot(3,3,2);imagesc(log(FBE22to11));title('Filterbank enery of code 22k decode to 11k')
subplot(3,3,5);imagesc(log(FBE22to22));title('Filterbank enery of code 22k decode to 22k')
subplot(3,3,8);imagesc(log(FBE22to44));title('Filterbank enery of code 22k decode to 44k')
subplot(3,3,3);imagesc(log(FBE44to11));title('Filterbank enery of code 44k decode to 11k')
subplot(3,3,6);imagesc(log(FBE44to22));title('Filterbank enery of code 44k decode to 22k')
subplot(3,3,9);imagesc(log(FBE44to44));title('Filterbank enery of code 44k decode to 44k')
% sumMag1 = [sum(log(FBE11)) ;sum(log(FBE22)) ;sum(log(FBE44))];
% sumMag2 = [sum(log(FBE11to44)) ;sum(log(FBE22to44)) ;sum(log(FBE44to44))];
% cmpMag = [sumMag1;sumMag2];

figure(7),
subplot(3,3,1);imagesc(MAG11to11)
subplot(3,3,4);imagesc(MAG11to22)
subplot(3,3,7);imagesc(MAG11to44)
subplot(3,3,2);imagesc(MAG22to11)
subplot(3,3,5);imagesc(MAG22to22)
subplot(3,3,8);imagesc(MAG22to44)
subplot(3,3,3);imagesc(MAG44to11)
subplot(3,3,6);imagesc(MAG44to22)
subplot(3,3,9);imagesc(MAG44to44)
% 
% figure(8),
% subplot(3,3,1);imagesc(MFCCsd11to11)
% subplot(3,3,2);imagesc(MFCCsd11to22)
% subplot(3,3,3);imagesc(MFCCsd11to44)
% subplot(3,3,4);imagesc(MFCCsd22to11)
% subplot(3,3,5);imagesc(MFCCsd22to22)
% subplot(3,3,6);imagesc(MFCCsd22to44)
% subplot(3,3,7);imagesc(MFCCsd44to11)
% subplot(3,3,8);imagesc(MFCCsd44to22)
% subplot(3,3,9);imagesc(MFCCsd44to44)



