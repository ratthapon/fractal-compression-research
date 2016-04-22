close all;
dbName = 'an4_8k';
Fs = 16000;
fileIds = [importdata(['F:\IFEFSR\Sphinx\' dbName '\etc\an4_train.fileids']); ...
    importdata(['F:\IFEFSR\Sphinx\' dbName '\etc\an4_test.fileids'])];
mfccparams; % load mfcc params
HF = 7300;
LF = 130;
M = 30;
C = 30;
Tw = 32;
Ts = 16;
alpha = 0.97;
L = M;%22;                 % cepstral sine lifter parameter
for aIdx = 1:1 %size(fileIds,1)
    inFName = ['F:/IFEFSR/SpeechData/an4/wav/' fileIds{aIdx} '.raw'];
    fid = fopen(inFName, 'r');
    signal = fread(fid, 'int32');
    fclose(fid);
    [MFCCs,FBE] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    figure(1),subplot(3,2,1)
    OUT_MFCC = MFCCs(1:end,:);
    imagesc(OUT_MFCC);
    figure(1),subplot(3,2,2)
    imagesc(FBE);
    figure(2),subplot(2,1,1),plot(signal);
    
    inFName = ['F:/IFEFSR/Sphinx/an4_16k_base/feat/' fileIds{aIdx} '.mfc'];
    fid = fopen(inFName, 'r');
    header = fread(fid,1,'uint32');
    cc = fread(fid, 'float32');
    fclose(fid);
    c = C;
    cc_2 = reshape(cc,c,header/c);
    figure(1),subplot(3,2,3)
    imagesc(cc_2(2:end,:));
    
    inFName = ['F:/IFEFSR/Sphinx/an4_cross_fc/feat/' fileIds{aIdx} '.mfc'];
    fid = fopen(inFName, 'r');
    header = fread(fid,1,'uint32');
    cc = fread(fid, 'float32');
    fclose(fid);
    c = C;
    cc_2 = reshape(cc,c,header/c);
    figure(1),subplot(3,2,4)
    imagesc(cc_2(2:end,:));
    
    inFName = ['F:/IFEFSR/Sphinx5/an4_cross_fc/wav/' fileIds{aIdx} '.raw'];
    fid = fopen(inFName, 'r');
    signal = fread(fid, 'int32');
    fclose(fid);
    [MFCCs,FBE] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    figure(1),subplot(3,2,5)
    OUT_MFCC = MFCCs(1:end,:);
    imagesc(OUT_MFCC);
    figure(1),subplot(3,2,6)
    imagesc(FBE);
    figure(2),subplot(2,1,2),plot(signal);
    pause(1)
end
