mfccparams;
load('F:\IFEFSR\APFractalCode\lena_Thresh1E-3AA2\lena.mat')
y = decompressAPAA(f,16000,16000,15);
y = [y [0 0 0 0]];
rec = reshape(y,128,128);
ori = audioread('F:\IFEFSR\lena.wav');
reshape_ori = reshape(ori,128,128);
Fs = 16000;

figure(1),
subplot(2,1,1) , plot(uint8((reshape_ori(:)+1)/2*256));axis([ -inf inf 0 256])
subplot(2,1,2) , plot((rec(:)+1)/32768*256);axis([ -inf inf 0 256])

figure,subplot(1,2,1),imshow(uint8((reshape_ori+1)/2*256));title('Original')
subplot(1,2,2),imshow(uint8(rec/32768*256));title('FC')

[ CC,FBE, OUTMAG, MAG] = mfcc( ori, Fs,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

figure,
subplot(1,2,1),imagesc(MAG);
subplot(3,2,2),imagesc(OUTMAG);
subplot(3,2,4),imagesc(FBE);
subplot(3,2,6),imagesc(CC);
% saveas(gcf,[dir '\Feature_' num2str(i) '.jpg'],'jpg');

[ CC,FBE, OUTMAG, MAG] = mfcc( y, Fs,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

figure,
subplot(1,2,1),imagesc(MAG);
subplot(3,2,2),imagesc(OUTMAG);
subplot(3,2,4),imagesc(FBE);
subplot(3,2,6),imagesc(CC);
% saveas(gcf,[dir '\Feature_' num2str(i) '.jpg'],'jpg');
unique(f(:,5))
figure,hist(f(:,5),128)