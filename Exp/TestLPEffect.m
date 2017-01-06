function TestLPEffect()
%DISPATCHBATCHLPFILTER MATLAB low pass filter batch dispatcher

expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'raw';
outExt = 'raw';

DATASET = [{'BASE'}];
% RBS = [{'2'}, {'4'}];
% CUTOFF = [{0.625}];
CUTOFF = num2cell((4000:500:7500) / 8000);
NFILT = [{16}, {32}];
FS = [{8}, {16}];

P = buildParamsMatrix( DATASET, CUTOFF, NFILT, FS );
for pIdx = 1:size(P, 1)
    dataSet = P{pIdx, 1};
    cutoff = P{pIdx, 2};
    nFilt = P{pIdx, 3};
    fs = P{pIdx, 4};
    
    %% MATLAB low pass filter
    %% apply low-pass filter to recon rbs n 16->16
    inDir = ['F:\IFEFSR\ExpSphinx\' dataSet num2str(fs) '' '\wav'];
    outDir = fullfile(expDirectory, [dataSet 'LP' num2str(cutoff*1000*fs) ...
        'N' num2str(nFilt) 'FS' num2str(fs)]);
    batchMATLABLPFilter( fileList, inDir, outDir, nFilt, cutoff, inExt, outExt );
    
end

