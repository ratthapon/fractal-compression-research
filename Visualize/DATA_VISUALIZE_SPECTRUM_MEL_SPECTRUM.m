%% compare spectrum and feature
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
sigOri = sig4;
sigSub = sigOri(1:2:end);
alpha = 0.95;

zz = 0.01;

lpFilter = [1 zz-1];
% sig2 = filter( lpFilter, 1, sig2 );
% sig3 = filter( lpFilter, 1, sig3 );
% sig2 = filter( 1 , lpFilter, sig2 );
% sig3 = filter( 1 , lpFilter, sig3 );

f = [0 0.3 0.3 1];            % Frequency breakpoints
m = [1 1 1 0 ];                  % Magnitude breakpoints
b = fir2(60,f,m);               % FIR filter design
b1 = fir1(8,0.75);
% freqz(b,1,512);                 % Frequency response of filter
sig2 = filtfilt(b1,1,sig2);       % Zero-phase digital filtering
sig3 = filtfilt(b1,1,sig3);       % Zero-phase digital filtering



[MFCC1, FBE1, SPEC1] = mfcc( sigOri, 16000,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[MFCC2, FBE2, SPEC2] = mfcc( sigSub, 8000,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
SPEC2 = [SPEC2; zeros(128, size(SPEC2,2))];
[MFCC3, FBE3, SPEC3] = mfcc( sig3, 16000,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[MFCC4, FBE4, SPEC4] = mfcc( sig2, 16000,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

f1 = figure(1),
subplot(1,4,1), imagesc(-SPEC1); set(gca,'YDir','normal')
title('16 kHz signal')
xlabel('Frame index')
ylabel('Frequency index')
subplot(1,4,2), imagesc(-SPEC2); set(gca,'YDir','normal')
title('8 kHz signal')
xlabel('Frame index')
ylabel('Frequency index')
subplot(1,4,3), imagesc(-SPEC3); set(gca,'YDir','normal')
title('reconstructed 16 kHz signal')
xlabel('Frame index')
ylabel('Frequency index')
subplot(1,4,4), imagesc(-SPEC4); set(gca,'YDir','normal')
title('reconstructed 8 kHz signal')
xlabel('Frame index')
ylabel('Frequency index')
colormap(gray)



