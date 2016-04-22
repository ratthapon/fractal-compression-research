vectorsCorrelation = []; % zeros(size(filesList_low,1),4);
matrixCorrelation = zeros(size(filesList_low,1),4);
for fIdx = 1:size(filesList_low,1)
    if isFractalCode
        load(filesList_low{fIdx});
        f_low = f;
        fq1 = 11025;
        x1 = decompressPower1AP(f_low,fq1,fq1,[]);
        
        load(filesList_med{fIdx});
        f_med = f;
        fq2 = 22050;
        x2 = decompressPower1AP(f_med,fq2,fq2,[]);
        
        load(filesList_high{fIdx});
        f_high = f;
        fq3 = 44100;
        x3 = decompressPower1AP(f_high,fq3,fq3,[]);
        
    else
        [x1,fq1] = audioread(filesList_low{fIdx});
        [x2,fq2] = audioread(filesList_med{fIdx});
        [x3,fq3] = audioread(filesList_high{fIdx});
    end
    
    [ MFCCsx1, FBEx1 ] = ...
        mfcc( x1 , fq1,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    [ MFCCsx2, FBEx2 ] = ...
        mfcc( x2 , fq2,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    [ MFCCsx3, FBEx3 ] = ...
        mfcc( x3 , fq3,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    if var([size(MFCCsx1,2) size(MFCCsx2,2) size(MFCCsx3,2)]) ~= 0
        err = ['Mismatch ' num2str(fIdx)]
    end
    minLen = min([size(MFCCsx1,2) size(MFCCsx2,2) size(MFCCsx3,2)]);
    MFCCsx1 = MFCCsx1(:,1:minLen);
    MFCCsx2 = MFCCsx2(:,1:minLen);
    MFCCsx3 = MFCCsx3(:,1:minLen);
    minLen = min([size(FBEx1,2) size(FBEx2,2) size(FBEx3,2)]);
    FBEx1 = FBEx1(:,1:minLen);
    FBEx2 = FBEx2(:,1:minLen);
    FBEx3 = FBEx3(:,1:minLen);
    
    [R1_FBE_H2M, R2_FBE_H2M] = pearsoncorrelation(FBEx2,FBEx3);
    [R1_FBE_H2L, R2_FBE_H2L] = pearsoncorrelation(FBEx1,FBEx3);
    
    [R1_MFCC_H2M, R2_MFCC_H2M] = pearsoncorrelation(MFCCsx2,MFCCsx3);
    [R1_MFCC_H2L, R2_MFCC_H2L] = pearsoncorrelation(MFCCsx1,MFCCsx3);
    
    vectorsCorrelation = [vectorsCorrelation ; [{R1_FBE_H2M},{R1_FBE_H2L},{R1_MFCC_H2M},{R1_MFCC_H2L}]];
    matrixCorrelation(fIdx,:) = [R2_FBE_H2M, R2_FBE_H2L, R2_MFCC_H2M, R2_MFCC_H2L];
    
end
avgCorrelation = mean(matrixCorrelation);