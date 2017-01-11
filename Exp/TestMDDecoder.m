load('F:\IFEFSR\AudioFC\FC\EXP\EXP_MD\AN48_FP_RBS4\test_rScale\an4_clstk\fash\an251-fash-b.mat');
max(abs(f(:, 2:(size(f, 2)-3))))
% [wav2] = AFCDecode(f,8000,16000,inIter);
%
% [wav2] = AFCDecode(f,FsIn,FsOut,inIter);
% % figure(3), plot(wav2);
% [ CC, FBE, OUTMAG2, MAG, H, DCT] = mfcc2( wav2, 16000);
% figure(4), imagesc(OUTMAG2)

dScale = 2;
rScale = 1;
expansion = 1;
cenAlign = true;
[wav] = MDDecode(f, FsIn, FsOut, dScale, rScale, expansion, cenAlign, inIter);
mask = fir1( 16, 55/80);
wav = filtfilt(mask, 1, wav);
figure(5), plot(wav);
[ CC, FBE, OUTMAG, MAG, H, DCT] = mfcc2( wav, 16000);
figure(6), imagesc(OUTMAG)


PSNR(wav, wav2)
img_qi(OUTMAG, OUTMAG2)
PSNR(wav, wave)
img_qi(OUTMAG, OUTMAG0)

% figure(1), plot(wave);
% [ CC, FBE, OUTMAG0, MAG, H, DCT] = mfcc2( wave, 16000);
% figure(2), imagesc(OUTMAG0)

[ CC, FBE, OUTMAG, MAG, H, DCT] = mfcc2( wave, 16000);
frames = vec2frames( wav, Nw, Ns, 'cols', @hamming, false );

figure(2), subplot(3,1,1), plot(frames(:, 10));
figure(2), subplot(3,1,2), plot(OUTMAG(:, 10));
figure(2), subplot(3,1,3), plot(CC(:, 10));

figure(3), subplot(3,1,1), plot(frames(:, 40));
figure(3), subplot(3,1,2), plot(OUTMAG(:, 40));
figure(3), subplot(3,1,3), plot(CC(:, 40));


