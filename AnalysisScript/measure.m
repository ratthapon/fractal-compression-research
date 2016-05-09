function [ psnrValues, specCorr, fbeCorr, mfccCorr, ...
    framesSpecCorr, framesFbeCorr, framesMfccCorr] = measure( sigOri, sigRec )
% This function measures all important indicator of two signal.
%   Detailed explanation goes here

    mfccparams;
    % using constant instead of unknown overriding inorder to avoid problem.
    constAlpha = 0.95; 
    
    [MFCCOri, FBEOri, SPECOri] = mfcc( sigOri, 16000, Tw, Ts, constAlpha, @hamming, [LF HF], M, C+1, L );
    [MFCCRec, FBERec, SPECRec] = mfcc( sigRec, 16000, Tw, Ts, constAlpha, @hamming, [LF HF], M, C+1, L );
    
    psnrValues = PSNR(sigOri, sigRec);
    
    specCorr = mean(framecorr(SPECOri, SPECRec));
    fbeCorr = mean(framecorr(FBEOri, FBERec));
    mfccCorr = mean(framecorr(MFCCOri, MFCCRec));
    
    framesSpecCorr = framecorr(SPECOri, SPECRec);
    framesFbeCorr = framecorr(FBEOri, FBERec);
    framesMfccCorr = framecorr(MFCCOri, MFCCRec);

end

