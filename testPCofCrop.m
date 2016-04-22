mfccparams; % load mfcc params
HF = 6000;
sel = [5 17 41 43 48 65 66 75 78 79 83 88 92 94 95 97 99 100 102 108 109 ...
    110 111 113 114 116 117 118 119 120 128 129 134 136 ];

filesList1 = importdata('F:\IFEFSR\11k_TRAIN_MR.txt');
filesList2 = importdata('F:\IFEFSR\44k_TRAIN_MR.txt');
w1 = audioread(filesList1{sel(19)});
w2 = audioread(filesList2{sel(19)});

[ MFCCsx1, FBEx1 ] = ...
    mfcc( w1 , 11025,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCsx2, FBEx2 ] = ...
    mfcc( w2 , 44100,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
figure(2)
subplot(4,1,1),imagesc(FBEx1(:,35:65));
subplot(4,1,2),imagesc(FBEx2(:,35:65));
figure(3)
subplot(4,1,1),imagesc(MFCCsx1(:,35:65));
subplot(4,1,2),imagesc(MFCCsx2(:,35:65));

[~,PC_FBE_11] = pearsoncorrelation(FBEx1(:,35:65),FBEx2(:,35:65));
[~,PC_MFCC_11] = pearsoncorrelation(MFCCsx1(:,35:65),MFCCsx1(:,35:65));


filesList1 = importdata('F:\IFEFSR\22k_TRAIN_MR.txt');
filesList2 = importdata('F:\IFEFSR\44k_TRAIN_MR.txt');
w1 = audioread(filesList1{sel(19)});
w2 = audioread(filesList2{sel(19)});

[ MFCCsx1, FBEx1 ] = ...
    mfcc( w1 , 22050,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
[ MFCCsx2, FBEx2 ] = ...
    mfcc( w2 , 44100,...
    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );

figure(2)
subplot(4,1,3),imagesc(FBEx1(:,35:65));
subplot(4,1,4),imagesc(FBEx2(:,35:65));
figure(3)
subplot(4,1,3),imagesc(MFCCsx1(:,35:65));
subplot(4,1,4),imagesc(MFCCsx2(:,35:65));

[~,PC_FBE_22] = pearsoncorrelation(FBEx1(:,35:65),FBEx2(:,35:65));
[~,PC_MFCC_22] = pearsoncorrelation(MFCCsx1(:,35:65),MFCCsx1(:,35:65));

