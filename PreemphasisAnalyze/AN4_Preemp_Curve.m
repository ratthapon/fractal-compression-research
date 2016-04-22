mfccparams;
warning off;
Cs = [ 30]; % n ceps
Ms = [30]; % m filter
HFs = [ 7300]; % highest freq
As = [1 2]; %  alpha
alpha = 0.6;
h3 = figure(99);
set(h3, 'Visible', 'off');
fromto = [1 10];
outFs = [8000 16000];
% outFs = [16000 16000];
fileList = importdata('F:\IFEFSR\AudioFC\an4traintest.txt');
inDirS = [{'F:\IFEFSR\SpeechData\an4_8k\wav\'}, ...
    {'F:\IFEFSR\SpeechData\an4\wav\'}];
% inDirS = [{'F:\IFEFSR\AudioFC\FC\AN4_8K_CURVEFIT_LM\'}, ...
%     {'F:\IFEFSR\AudioFC\FC\QR\AN4_16K\'}];
outDirS = [{'F:/IFEFSR/AudioFC/DAudio_Preemp/AN4_8K'}, ...
    {'F:/IFEFSR/AudioFC/DAudio_Preemp/AN4_16K'}];
% outDirS = [{'F:/IFEFSR/AudioFC/DAudio_Preemp/AN4_8K216K_QR'}, ...
%     {'F:/IFEFSR/AudioFC/DAudio_Preemp/AN4_16K_QR'}];

t = tic;
C = Cs;
M = Ms;
HF = HFs;
for alphaIdx = 1:11
    alpha = (alphaIdx-1)/10;
    outDir = [outDirS{a} '_A' num2str(alpha*10) ...
        '_C' num2str(C) ...
        '_M' num2str(M) ...
        '_HF' num2str(HF)
        ];
    mkdir(outDir);
    mkdir([outDir '/fig/']);
    for i = fromto(1):fromto(2)
        MFCCs = [];
        FBEs = [];
        SPECs = [];
        for a = As
            inDir = inDirS{a};
            inFName = [inDir fileList{i} '.raw'];
            fid = fopen(inFName, 'r');
            sig = fread(fid, 'int16');
            fclose(fid);
            
%             load([inDir fileList{i}]);
%             sig = decompressAudioFC(f, a, 2, []);
            
            [MFCC1, FBE1, SPEC] = mfcc_pp4( sig, outFs(a),...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs{a} = MFCC1;
            FBEs{a} = FBE1;
            if a == 1
                SPEC = [SPEC; zeros(128, size(SPEC, 2))];
            end
            SPECs{a} = SPEC;
            SIGs{a} = sig;
            subDir = regexp(fileList{i},'/','split');
            featDir = [outDir '/feat/' subDir{1} '/' subDir{2}];
            outFName = [outDir '/feat/' fileList{i} '.mfc'];
            mkdir(featDir);
            fid = fopen(outFName, 'w');
            fwrite(fid, size(MFCC1(:),1), 'uint32');
            fwrite(fid, MFCC1(:), 'float32');
            fclose(fid);
            
            
            subplot(1,3,1),imagesc(SPEC);
            subplot(1,3,2),imagesc(FBE1);
            subplot(1,3,3),imagesc(MFCC1);
            saveas(3, [outDir '/fig/' subDir{3}], 'png')
            
        end
        MFCCCurve(alphaIdx, i) = corr(MFCCs{1}(:), MFCCs{2}(:));
        FBECurve(alphaIdx, i) = corr(FBEs{1}(:), FBEs{2}(:));
        SPECCurve(alphaIdx, i) = corr(SPECs{1}(:), SPECs{2}(:));
        PSNRCurve{alphaIdx, i} = {SIGs(1), SIGs(2)};
        
    end
end
time = toc(t)


figure(1), plot(0:0.1:1,mean(MFCCCurve,2)); title('Correlation of MFCC');
xlabel('Preemphasis'), ylabel('Correlation');
figure(2), plot(0:0.1:1,mean(FBECurve,2)); title('Correlation of FBE');
xlabel('Preemphasis'), ylabel('Correlation');
figure(3), plot(0:0.1:1,mean(SPECCurve,2)); title('Correlation of Spectrum');
xlabel('Preemphasis'), ylabel('Correlation');

figure(9)
subplot(2,3,1)
plot(0.1:0.1:1,mean(SPECCurve,2)); title('Correlation of Spectrum');
xlabel('Preemphasis'), ylabel('Correlation'); axis([0 1 0 1]);
subplot(2,3,2)
plot(0.1:0.1:1,mean(FBECurve,2)); title('Correlation of FBE');
xlabel('Preemphasis'), ylabel('Correlation'); axis([0 1 0 1]);
subplot(2,3,3)
plot(0.1:0.1:1,mean(MFCCCurve,2)); title('Correlation of MFCC');
xlabel('Preemphasis'), ylabel('Correlation'); axis([0 1 0 1]);

subplot(2,3,4)
plot(0:0.1:1,mean(SPECCurve,2)); title('Correlation of Spectrum');
xlabel('Preemphasis'), ylabel('Correlation'); axis([0 1 0 1]);
subplot(2,3,5)
plot(0:0.1:1,mean(FBECurve,2)); title('Correlation of FBE');
xlabel('Preemphasis'), ylabel('Correlation'); axis([0 1 0 1]);
subplot(2,3,6)
plot(0:0.1:1,mean(MFCCCurve,2)); title('Correlation of MFCC');
xlabel('Preemphasis'), ylabel('Correlation'); axis([0 1 0 1]);

