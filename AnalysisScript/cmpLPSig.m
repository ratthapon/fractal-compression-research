function cmpLPSig( )
%CMPLPSIG Summary of this function goes here
%   Detailed explanation goes here

expDirectory = 'F:\IFEFSR\ExpSphinx';
sigName = 'an4_clstk\fash\an251-fash-b.raw';
fs = 8;
CUTOFF = [{0.625}, {0.6875}, {0.75}, {0.8125}, {0.875}, {0.9125}, {0.9375}];

for lp = 1:size(CUTOFF, 1)
    cutoff = CUTOFF{lp};
    adpInSigPath = fullfile(expDirectory, ['ADPv2RBS4T64LP' num2str(cutoff*10000) ...
        'N16FS' fs '16\wav\' sigName]);
    adpSig = rawread(adpInSigPath);
    
    mrbsInSigPath = fullfile(expDirectory, ['FCMATLABMRBS4T64LP' num2str(cutoff*10000) ...
        'N16FS' fs '16\wav\' sigName]);
    mrbsSig = rawread(mrbsInSigPath);
    
    figure(1), 
    subplot(1,2,1), plot(adpSig);
    subplot(1,2,2), plot(mrbsSig);
end

