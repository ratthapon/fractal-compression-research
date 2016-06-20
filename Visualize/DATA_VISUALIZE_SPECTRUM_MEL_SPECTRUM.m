%% compare spectrum and feature
mfccparams;
C = 30;
HF = 7300;
fileList = importdata('F:\IFEFSR\AudioFC\an4fileids.txt');
fName = fileList{1}
dat = load(['F:\IFEFSR\AudioFC\FC\AN4_8_75_DECIMATE_INV_QR_GPU\' fName '.mat']);
f1 = dat.f;
dat = load(['F:\IFEFSR\AudioFC\FC\AN4_8_75_DECIMATE_INV_QR_GPU\' fName '.mat']);
f2 = dat.f;
dat = load(['F:\IFEFSR\AudioFC\FC\AN4_8_75_INV_QR_GPU\' fName '.mat']);
f3 = dat.f;
inFName = ['F:\IFEFSR\SpeechData\an4_fir1_8_75\wav\' fName '.raw'];
fid = fopen(inFName, 'r');
sig4 = fread(fid, 'int16');
fclose(fid);

sig1 = decompressAudioFC(f2,8000,16000,[]);
sig2 = decompressAudioFC(f2,8000,16000,[]);
sig3 = decompressAudioFC(f3,16000,16000,[]);
sigOri = sig4;
sigSub = sigOri(1:2:end);
alpha = 0.95;

zz = 0.1;

lpFilter = [1 zz-1];
% sig2 = filter( lpFilter, 1, sig2 );
% sig3 = filter( lpFilter, 1, sig3 );
% sig2 = filter( zz , lpFilter, sig2 );
% sig3 = filter( zz , lpFilter, sig3 );

f = [0 0.4 0.41 1];            % Frequency breakpoints
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
title('Original Signal 16 kHz')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
ax = gca;
set(ax,'XTickLabel',[1:6]*320);
set(ax,'YTick',[32:32:256]);
set(ax,'YTickLabel',[1:8]*1000);

subplot(1,4,2), imagesc(-SPEC2); set(gca,'YDir','normal')
title('Original Signal 8 kHz')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
ax = gca;
set(ax,'XTickLabel',[1:6]*320);
set(ax,'YTick',[32:32:256]);
set(ax,'YTickLabel',[1:8]*1000);

subplot(1,4,3), imagesc(-SPEC3); set(gca,'YDir','normal')
title('Reconstructed Signal 16 kHz')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
ax = gca;
set(ax,'XTickLabel',[1:6]*320);
set(ax,'YTick',[32:32:256]);
set(ax,'YTickLabel',[1:8]*1000);

subplot(1,4,4), imagesc(-SPEC4); set(gca,'YDir','normal')
title('Reconstructed Signal 8 kHz')
xlabel('Time (ms)')
ylabel('Frequency (Hz)')
ax = gca;
set(ax,'XTickLabel',[1:6]*320);
set(ax,'YTick',[32:32:256]);
set(ax,'YTickLabel',[1:8]*1000);

colormap(gray)



