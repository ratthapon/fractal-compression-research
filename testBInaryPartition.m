close all
mfccparams; % load mfcc params

load('F:\IFEFSR\APFractalCode\11k_train_rawResampling_Thresh2E-5ds1\11k_speaker_1_sp_1-01.mat');
deADF11 = apFractalDecode(f,11025,11025,[]);
adf11 = f;

load('F:\IFEFSR\APFractalCode\22k_train_rawResampling_Thresh2E-5ds1\22k_speaker_1_sp_1-01.mat');
deADF22 = apFractalDecode(f,22050,22050,[]);
adf22 = f;

load('F:\IFEFSR\APFractalCode\44k_train_rawResampling_Thresh2E-5ds1\44k_speaker_1_sp_1-01.mat');
deADF44 = apFractalDecode(f,44100,44100,[]);
adf44 = f;

load('F:\IFEFSR\FixSizeFractalCode\44k_train_rawResampling_Fs16ds1\44k_speaker_1_sp_1-01.mat');
denoiseLevel = 1;
denoiseMethod = 'db1';
deFSF = fractalDecode(f,44100,16,1,44100,[],[]);
deFSF = (deFSF - mean(deFSF)) / std(deFSF);
deFSF = (deFSF / norm(deFSF))*0.15;
fsf = f;

[ MFCCs11 ] =  mfcc( deADF11, 11025, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs22 ] =  mfcc( deADF22, 22050, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCs44 ] =  mfcc( deADF44, 44100, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
figure,
subplot(3,1,1),imagesc(MFCCs11);
subplot(3,1,2),imagesc(MFCCs22);
subplot(3,1,3),imagesc(MFCCs44);

wORI = audioread('F:\IFEFSR\SpeechData\TestDAT_rawResampling\44k_speaker_1_sp_1-01.wav');
% wORI = (wORI - mean(wORI)) / std(wORI);
% wORI = (wORI / norm(wORI))*0.15;

snr(deADF',wORI)
snr(deFSF',wORI)
figure,
subplot(3,1,1),plot(wORI);
subplot(3,1,2),plot(deFSF);
subplot(3,1,3),plot(deADF);

close all;
n = [4 8 16 32 64 128 256 512 1024];
for s=n
    v = [];
    for i=1:s:size(wORI,1)-s
        v = [v var(wORI(i:i+s,1))];
    end
    figure,bar(v);axis([0 inf 0 0.0001]);
end