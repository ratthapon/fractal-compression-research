function dispatchBatchJDecode( )
%DISPATCHBATCHJDECODE Java decode batch dispatcher

% fixed paramters
expDirectory = 'F:\IFEFSR\ExpSphinx';
inExt = 'mat';
outExt = 'raw';
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
outFs = 16000;

% permute paramters
DATASET = [{'FCRBS'}];
RBS = [{'2'}, {'4'}];
FS = [{8}, {16}];
P = buildParamsMatrix( DATASET, RBS, FS );

for pIdx = 1:length(P)
    dataSet = P{pIdx, 1};
    rbs = P{pIdx, 2};
    fs = P{pIdx, 3};
    
    %% prepare reconstruct signals
    inFs = fs * 1000;
    inDir = ['F:\IFEFSR\AudioFC\FC\AN4' num2str(fs) '_FP_RBS' rbs];
    outDir = fullfile(expDirectory, [ dataSet rbs 'FS' num2str(fs) '16']);
    batchJavaDecode( infile, inDir, outDir, inFs, outFs, inExt, outExt );
    
end