function cmpLPSig( )
%CMPLPSIG 

[ Tw, Ts, preemAlpha, M, C, L, LF, HF ] = getMFCCSphinxParams();
expDirectory = 'F:\IFEFSR\ExpSphinx';
sigName = 'an4_clstk\fash\an251-fash-b.raw';
fs = 8;
CUTOFF = [{0.625}, {0.6875}, {0.75}, {0.8125}, {0.875}, {0.9125}, {0.9375}];

for lp = 1:size(CUTOFF, 2)
    cutoff = CUTOFF{lp};
    adpInSigPath = fullfile(expDirectory, ['ADPv2RBS4T64LP' num2str(cutoff*10000) ...
        'N16FS' num2str(fs) '16\wav\' sigName]);
    adpSig = rawread(adpInSigPath);
    [adpMFCC, adpFBE, adpSpec] = mfcc( adpSig, 16000, ...
        Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );
    
    mrbsInSigPath = fullfile(expDirectory, ['FCMATLABMRBS4T64LP' num2str(cutoff*10000) ...
        'N16FS' num2str(fs) '16\wav\' sigName]);
    mrbsSig = rawread(mrbsInSigPath);
    [mrbsMFCC, mrbsFBE, mrbsSpec] = mfcc( mrbsSig, 16000, ...
        Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );
    
    figure(1),
    subplot(2,1,1), plot(adpSig);
    subplot(2,1,2), plot(mrbsSig);
    
    surfSpec(2, ...
        adpSpec, ['ADPv2RBS4T64LP' num2str(cutoff*10000)], ...
        mrbsSpec, ['FCMATLABMRBS4T64LP' num2str(cutoff*10000)] );
end

