function dispatchBatchResample( )
%DISPATCHBATCHRESAMPLE MATLAB resample batch dispatcher

% fixed paramters
expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'raw';
outExt = 'raw';
inDir = 'F:\IFEFSR\SpeechData\an4\wav';
inFs = 16000;

% permute paramters
FS = [{8}, {16}];
P = buildParamsMatrix( FS );

for pIdx = 1:length(P)
    fs = P{pIdx, 1};
    
    %% prepare baseline signals
    outFs = fs * 1000;
    outDir = fullfile(expDirectory, ['BASE' num2str(fs)], 'wav');
    batchMATLABResample( fileList, inDir, outDir, inFs, outFs, inExt, outExt );
    
end
