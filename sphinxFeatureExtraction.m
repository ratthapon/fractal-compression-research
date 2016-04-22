% sphinxFeatureExtraction
close all;
dbName = 'an4_cross_fc';
Fs = 16000;
fileIds = [importdata(['F:\IFEFSR\Sphinx5\' dbName '\etc\an4_train.fileids']); ...
    importdata(['F:\IFEFSR\Sphinx5\' dbName '\etc\an4_test.fileids'])];
mfccparams; % load mfcc params
HF = 7300;
LF = 130;
M = 25;
C = 12;
Tw = 32;
Ts = 16;
alpha = 0.97;
L = 22;                 % cepstral sine lifter parameter
for aIdx = 1:size(fileIds,1)
        inFName = ['F:/IFEFSR/Sphinx5/' dbName '/wav/' fileIds{aIdx} '.raw'];
        fid = fopen(inFName, 'r');
        signal = fread(fid, 'int32');
        fclose(fid);
        figure(2),plot(signal);
        [MFCCs,FBE] = mfcc( signal, Fs,...
            Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        figure(3),imagesc(FBE);
        figure(1),subplot(3,1,1)
        OUT_MFCC = MFCCs(1:end,:);%/norm(MFCCs(1:end-1,:));
        imagesc(OUT_MFCC);
    
        subDir = regexp(fileIds{aIdx},'/','split');
        inDir = ['F:/IFEFSR/Sphinx/' dbName '/feat/' subDir{1} '/' subDir{2}];
        outFName = ['F:/IFEFSR/Sphinx/' dbName '/feat/' fileIds{aIdx} '.mfc'];
        mkdir(inDir);
        fid = fopen(outFName, 'w');
        feat = MFCCs(1:end,:);
        fwrite(fid,size(feat(:),1),'uint32');
        fwrite(fid,feat(:),'float32');
        fclose(fid);
        
%     inFName = ['F:/IFEFSR/Sphinx/an4_8k/feat/' fileIds{aIdx} '.mfc'];
%     fid = fopen(inFName, 'r');
%     header = fread(fid,1,'uint32');
%     cc = fread(fid, 'float32');
%     fclose(fid);
%     c = 13;
%     cc_2 = reshape(cc,c,header/c);
%     figure(1),subplot(3,1,2)
%     imagesc(cc_2(2:end,:));
%     
%     inFName = ['F:/IFEFSR/Sphinx/an4_16k/feat/' fileIds{aIdx} '.mfc'];
%     fid = fopen(inFName, 'r');
%     header = fread(fid,1,'uint32');
%     cc = fread(fid, 'float32');
%     fclose(fid);
%     c = 13;
%     cc_3 = reshape(cc,c,header/c);
%     figure(1),subplot(3,1,3)
%     imagesc(cc_3(2:end,:));
%     pause(1)
end
% 
% inFName = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\' ...
%     'ARMS_REC_UTEST\8k_speaker_1_sp_1-01.raw'];
% fid = fopen(inFName, 'r');
% sig1 = fread(fid, 'int16');
% fclose(fid);
% figure(1),subplot(2,1,1),plot(sig1)
% 
% inFName = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\' ...
%     '\ARMS_REC_UTEST_FRAME\8k_speaker_1_sp_1-01.raw'];
% fid = fopen(inFName, 'r');
% sig2 = fread(fid, 'int16');
% fclose(fid);
% figure(1),subplot(2,1,2),plot(sig2)
% 
% inFName = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\' ...
%     'ARMS_REC_UTEST_WAV_DECOMPRESS\8k_speaker_1_sp_1-01.wav'];
% sig3 = audioread(inFName);
% figure(2),
% subplot(3,1,1),plot(sig1)
% subplot(3,1,2),plot(sig2)
% subplot(3,1,3),plot(sig3)
% 
% 
% inFName = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\' ...
%     'AN4_16K_UTEST\an4_clstk\fash\an251-fash-b.raw'];
% fid = fopen(inFName, 'r');
% sig4 = fread(fid, 'int16');
% fclose(fid);
% figure(3),subplot(2,1,1),plot(sig4)
% 
% inFName = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\' ...
%     '\AN4_16K_UTEST_FRAME\an4_clstk\fash\an251-fash-b.raw'];
% fid = fopen(inFName, 'r');
% sig5 = fread(fid, 'int16');
% fclose(fid);
% figure(3),subplot(2,1,2),plot(sig5)
% 
% %% compare old and new
% 
% inFName = ['F:\IFEFSR\SpeechData\an4\wav\' ...
%     'an4_clstk\fash\an251-fash-b.raw'];
% fid = fopen(inFName, 'r');
% sig6 = fread(fid, 'int16');
% fclose(fid);
% figure(3),subplot(2,1,1),plot(sig6)
% 
% inFName = ['F:\IFEFSR\TestAudioCompressor\Decompress\FractalCode\AN4_8K_UTEST\' ...
%     'an4_clstk\fash\an251-fash-b.raw'];
% fid = fopen(inFName, 'r');
% sig7 = fread(fid, 'int16');
% fclose(fid);
% figure(3),subplot(2,1,2),plot(sig7)


