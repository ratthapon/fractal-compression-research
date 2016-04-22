

mfccparams; % load mfcc params
NfIdx = [{'001'};{'002'};{'013'};{'015'};{'016'}; ...
    {'022'};{'025'};{'031'};{'039'};{'041'};];
for fileIdx = 1:10
    close all
    fs = [16000 32000 48000];
    thresh = '1E-6';
    load(['F:\IFEFSR\APFractalCode\16k_NECTEC_matlabResampling_Thresh' '1E-5' 'ds1\CF001_Va001_' NfIdx{fileIdx} '.mat']);
    deADF_low2low = apFractalDecode(f,fs(1),fs(1),[]);
    deADF_low2med = apFractalDecode(f,fs(1),fs(2),[]);
    deADF_low2high = apFractalDecode(f,fs(1),fs(3),[]);
    adf11 = f;
    
    load(['F:\IFEFSR\APFractalCode\32k_NECTEC_matlabResampling_Thresh' '1E-5' 'ds1\CF001_Va001_' NfIdx{fileIdx} '.mat']);
    deADF_med2low = apFractalDecode(f,fs(2),fs(1),[]);
    deADF_med2med = apFractalDecode(f,fs(2),fs(2),[]);
    deADF_med2high = apFractalDecode(f,fs(2),fs(3),[]);
    adf22 = f;
    
    load(['F:\IFEFSR\APFractalCode\48k_NECTEC_matlabResampling_Thresh' '1E-5' 'ds1\CF001_Va001_' NfIdx{fileIdx} '.mat']);
    deADF_high2low = apFractalDecode(f,fs(3),fs(1),[]);
    deADF_high2med = apFractalDecode(f,fs(3),fs(2),[]);
    deADF_high2high = apFractalDecode(f,fs(3),fs(3),[]);
    adf44 = f;
    
    oriWave_1 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
        '\16\CF001_Va001\CF001_Va001_' NfIdx{fileIdx} '.wav']);
    oriWave_1 = oriWave_1(:,1);
    [ MFCCsoriWave_1,FBEoriWave_1,OUTMAG_1,~, H_low ] =  mfcc( oriWave_1, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    oriWave_2 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
        '\32\CF001_Va001\CF001_Va001_' NfIdx{fileIdx} '.wav']);
    oriWave_2 = oriWave_2(:,1);
    [ MFCCsoriWave_2,FBEoriWave_2,OUTMAG_2,~, H_med  ] =  mfcc( oriWave_2, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    oriWave_3 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
        '\48\CF001_Va001\CF001_Va001_' NfIdx{fileIdx} '.wav']);
    oriWave_3 = oriWave_3(:,1);
    [ MFCCsoriWave_3,FBEoriWave_3,OUTMAG_3,~, H_high ] =  mfcc( oriWave_3, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    [ MFCCs_low2low,FBE_low2low,OUTMAG_low2low] =  mfcc( deADF_low2low, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [ MFCCs_low2med,FBE_low2med,OUTMAG_low2med ] =  mfcc( deADF_low2med, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [ MFCCs_low2high,FBE_low2high,OUTMAG_low2high] =  mfcc( deADF_low2high, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    [ MFCCs_med2low,FBE_med2low,OUTMAG_med2low ] =  mfcc( deADF_med2low, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [ MFCCs_med2med,FBE_med2med,OUTMAG_med2med] =  mfcc( deADF_med2med, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [ MFCCs_med2high,FBE_med2high,OUTMAG_med2high ] =  mfcc( deADF_med2high, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    [ MFCCs_high2low,FBE_high2low,OUTMAG_high2low] =  mfcc( deADF_high2low, fs(1), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [ MFCCs_high2med,FBE_high2med,OUTMAG_high2med] =  mfcc( deADF_high2med, fs(2), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    [ MFCCs_high2high,FBE_high2high,OUTMAG_high2high] =  mfcc( deADF_high2high, fs(3), Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    figure,
    subplot(1,3,1),imagesc(OUTMAG_1);axis([1 inf 1 800]);
    subplot(1,3,2),imagesc(OUTMAG_2);axis([1 inf 1 800]);title('Original');
    subplot(1,3,3),imagesc(OUTMAG_3);axis([1 inf 1 800]);
    
    figure,
    subplot(3,1,1),imagesc(H_low);axis([0 inf 1 M]);
    subplot(3,1,2),imagesc(H_med);axis([0 inf 1 M]);
    subplot(3,1,3),imagesc(H_high);axis([0 inf 1 M]);
    
    figure,
    subplot(1,3,1),imagesc(OUTMAG_1);axis([1 inf 1 100]);
    subplot(1,3,2),imagesc(OUTMAG_2);axis([1 inf 1 100]);title('Original');
    subplot(1,3,3),imagesc(OUTMAG_3);axis([1 inf 1 100]);
    
    figure,
    subplot(1,3,1),imagesc(FBEoriWave_1);
    subplot(1,3,2),imagesc(FBEoriWave_2);title('Original FBE');
    subplot(1,3,3),imagesc(FBEoriWave_3);
    [r1OF_lowVSmed, r2OF_lowVSmed] = pearsoncorrelation(FBEoriWave_1,FBEoriWave_2);
    [r1OF_lowVShigh, r2OF_lowVShigh] = pearsoncorrelation(FBEoriWave_1,FBEoriWave_3);
    
    figure,
    subplot(1,3,1),imagesc(MFCCsoriWave_1);
    subplot(1,3,2),imagesc(MFCCsoriWave_2);title('Original MFCCs');
    subplot(1,3,3),imagesc(MFCCsoriWave_3);
    [r1OM_lowVSmed, r2OM_lowVSmed] = pearsoncorrelation(MFCCsoriWave_1,MFCCsoriWave_2);
    [r1OM_lowVShigh, r2OM_lowVShigh] = pearsoncorrelation(MFCCsoriWave_1,MFCCsoriWave_3);
    
    figure,
    subplot(1,3,1),imagesc(FBE_low2low);
    subplot(1,3,2),imagesc(FBE_med2med);title('Recon FBE');
    subplot(1,3,3),imagesc(FBE_high2high);
    [r1RF_lowVSmed, r2RF_lowVSmed] = pearsoncorrelation(FBE_low2low,FBE_med2med);
    [r1RF_lowVShigh, r2RF_lowVShigh] = pearsoncorrelation(FBE_low2low,FBE_high2high);
    
    figure,
    subplot(1,3,1),imagesc(MFCCs_low2low);
    subplot(1,3,2),imagesc(MFCCs_med2med);title('Recon MFCCs');
    subplot(1,3,3),imagesc(MFCCs_high2high);
    [r1RM_lowVSmed, r2RM_lowVSmed] = pearsoncorrelation(MFCCs_low2low,MFCCs_med2med);
    [r1RM_lowVShigh, r2RM_lowVShigh] = pearsoncorrelation(MFCCs_low2low,MFCCs_high2high);
    
    figure,
    subplot(1,3,1),imagesc(OUTMAG_low2low);
    subplot(1,3,2),imagesc(OUTMAG_med2med);title('Recon to its Fs');
    subplot(1,3,3),imagesc(OUTMAG_high2high);
    
    figure,
    subplot(1,3,1),imagesc(OUTMAG_low2low);
    subplot(1,3,2),imagesc(OUTMAG_med2low);title('Recon to low Fs');
    subplot(1,3,3),imagesc(OUTMAG_high2low);
    
    figure,
    subplot(1,3,1),imagesc(OUTMAG_low2med);
    subplot(1,3,2),imagesc(OUTMAG_med2med);title('Recon to low Fs');
    subplot(1,3,3),imagesc(OUTMAG_high2med);
    
    figure,
    subplot(1,3,1),imagesc(OUTMAG_low2high);
    subplot(1,3,2),imagesc(OUTMAG_med2high);title('Recon to high Fs');
    subplot(1,3,3),imagesc(OUTMAG_high2high);
    
    partitions = [];
    
    
    figure,
    subplot(3,1,1),plot(oriWave_1);title('Original');
    cumulative = 1;
    for i=1:size(adf11(:,5),1)
        cumulative = cumulative + adf11(i,5);
        linesX = [cumulative cumulative];
        linesY = [-1 1];
        line(linesX,linesY);
    end
    axis([1000 1600 -0.5 0.5]);
    
    subplot(3,1,2),plot(deADF_low2low);title('Recon to its Fs');
        cumulative = 1;
    for i=1:size(adf11(:,5),1)
        cumulative = cumulative + adf11(i,5);
        linesX = [cumulative cumulative];
        linesY = [-1 1];
        line(linesX,linesY);
    end
    axis([1000 1600 -0.5 0.5]);
    
    subplot(3,1,3),plot(deADF_low2high);title('Recon to high Fs');
        cumulative = 1;
    for i=1:size(adf11(:,5),1)
        cumulative = cumulative + adf11(i,5)*3;
        linesX = [cumulative cumulative];
        linesY = [-1 1];
        line(linesX,linesY);
    end
    axis([3000 4800 -0.5 0.5]);
    
end