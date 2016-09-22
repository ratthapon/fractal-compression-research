function dispatchBatchLPFilter()
%DISPATCHBATCHLPFILTER MATLAB low pass filter batch dispatcher

expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'raw';
outExt = 'raw';

DATASET = [{'FCRBS'}];
RBS = [{'2'}, {'4'}];
CUTOFF = [{0.6875}, {0.9125}];
NFILT = [{16}];
FS = [{'8'}, {'16'}];

P = buildParamsMatrix( DATASET, RBS, CUTOFF, NFILT, FS );
for pIdx = 1:length(P)
    dataSet = P{pIdx, 1};
    rbs = P{pIdx, 2};
    cutoff = P{pIdx, 3};
    nFilt = P{pIdx, 4};
    fs = P{pIdx, 5};
    
    %% MATLAB low pass filter
    %% apply low-pass filter to recon rbs n 16->16
    inDir = ['F:\IFEFSR\ExpSphinx\' dataSet rbs 'FS' fs '16\wav'];
    outDir = fullfile(expDirectory, [dataSet rbs 'LP' num2str(cutoff*10000) ...
        'N' num2str(nFilt) 'FS' fs '16']);
    batchMATLABLPFilter( fileList, inDir, outDir, nFilt, cutoff, inExt, outExt );
    
end

