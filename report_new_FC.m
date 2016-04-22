mfccparams;
C = 30;
HF = 7300;
fileList = importdata('F:\IFEFSR\AudioFC\an4traintest.txt');
fName = fileList{1}
dat = load(['F:\IFEFSR\AudioFC\FC\AN4_8K_CURVEFIT_LM\' fName '.mat']);
f1 = dat.f;
dat = load(['F:\IFEFSR\AudioFC\FC\QR\AN4_8K\' fName '.mat']);
f2 = dat.f;
dat = load(['F:\IFEFSR\AudioFC\FC\QR\AN4_16K\' fName '.mat']);
f3 = dat.f;
inFName = ['F:\IFEFSR\SpeechData\an4\wav\' fName '.raw'];
fid = fopen(inFName, 'r');
sig4 = fread(fid, 'int16');
fclose(fid);

sig1 = decompressAudioFC(f2,8000,16000,[]);
sig2 = decompressAudioFCV2(f2,8000,16000,[]);
sig3 = decompressAudioFCV2(f3,16000,16000,[]);
% sig4 = decompressAudioFC(f_4,16000,16000,[]);
sigOri = sig4;
sig4_2 = sigOri(1:2:end);
% interp(sigOri,0.5);
% sig4_2 = sigOri;
% sig4_2(2:2:end) = 0;
% sig4_2 = interp(sig4_2, 2);
alpha = 0.95;

zz = 0.95;

sig2 = filter( zz, [1 zz - 1], sig2 ); 
sig3 = filter( zz, [1 zz - 1], sig3 ); 

[MFCC1, FBE1, SPEC1] = mfcc( sig1, 16000,...
Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[MFCC2, FBE2, SPEC2] = mfcc( sig2, 16000,...
Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[MFCC3, FBE3, SPEC3] = mfcc( sig3, 16000,...
Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[MFCC4, FBE4, SPEC4] = mfcc( sigOri, 16000,...
Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

figure(1);
subplot(4,1,1),plot(sig1); axis([5100 5700 -700 700]); title('Original 16k')
subplot(4,1,2),plot(sig2); axis([5100 5700 -700 700]); title('FC 8k')
subplot(4,1,3),plot(sig3); axis([5100 5700 -700 700]); title('FC 16k')
subplot(4,1,4),plot(sig4_2); axis([5100/2 5700/2 -700 700]); title('Original 8k')

alpha = 1;
sig1_filtered = filter( [1 0], 1, sig1 ); 
sig2_filtered = filter( 0.5, [1 0.5-1], sig2 ); 
sig3_filtered = filter( [1 0.5-1], 1, sig3 ); 
sig4_filtered = filter( [1 0.5-1], 1, sig4_2 ); 

alpha = 0.1;
fSig1 = filter( [1 -alpha], 1, sig1 ); % fvtool( [1 -alpha], 1 );
fSig2 = filter( [1 -alpha], 1, sig2 ); % fvtool( [1 -alpha], 1 );
fSig3 = filter( [1 -alpha], 1, sig3 ); % fvtool( [1 -alpha], 1 );

figure(2);
subplot(4,1,1),plot(sig1_filtered); axis([5100 5700 -700 700]); title('Original 16k')
subplot(4,1,2),plot(sig2_filtered); axis([5100 5700 -700 700]); title('FC 8k')
subplot(4,1,3),plot(sig3_filtered); axis([5100 5700 -700 700]); title('FC 16k')
subplot(4,1,4),plot(sig4_filtered); axis([5100/2 5700/2 -700 700]); title('Original 8k')

figure(3);
subplot(4,1,1),imagesc(MFCC1);
subplot(4,1,2),imagesc(MFCC2);
subplot(4,1,3),imagesc(MFCC3);
subplot(4,1,4),imagesc(MFCC4);

figure(4);
subplot(1,4,1),imagesc(FBE1);
subplot(1,4,2),imagesc([FBE2]);% zeros(128,size(FBE2,2))]);
subplot(1,4,3),imagesc(FBE3);
subplot(1,4,4),imagesc([FBE4]); %; zeros(128,size(FBE4,2))]);


figure(5);
subplot(1,4,1),imagesc(SPEC1);
subplot(1,4,2),imagesc([SPEC2]);% zeros(128,size(SPEC2,2))]);
subplot(1,4,3),imagesc(SPEC3);
subplot(1,4,4),imagesc([SPEC4]);% zeros(128,size(SPEC4,2))]);

figure(6);
subplot(1,4,1),imagesc(abs(FBE1 - FBE4));
subplot(1,4,2),imagesc(abs(FBE2 - FBE3));% zeros(128,size(FBE2,2))]);
subplot(1,4,3),imagesc(abs(SPEC1 - SPEC4));
subplot(1,4,4),imagesc(abs(SPEC2 - SPEC3)); %; zeros(128,size(FBE4,2))]);
max(FBE1 - FBE3)


corr(SPEC2(:),SPEC3(:))
corr(FBE2(:),FBE3(:))
corr(MFCC2(:),MFCC3(:))


% corr(sig1(1:11192),sig2(1:11192)')
% corr(sig1(1:11192),sig3(1:11192)')
% 
% 
% 
% corr(fSig1(1:11192),fSig2(1:11192)')
% corr(fSig1(1:11192),fSig3(1:11192)')
