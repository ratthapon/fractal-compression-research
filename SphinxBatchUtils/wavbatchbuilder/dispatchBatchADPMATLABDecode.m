function dispatchBatchADPMATLABDecode()
%DISPATCHBATCHADPMATLABDECODE MATLAB decode batch dispatcher

% fixed paramters
expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'mat';
outExt = 'raw';
outFs = 16000;
RBS = [{'4'}, {'64'}];
minRBS = RBS{1};
maxRBS = RBS{end};

% permute paramters
DATASET = [{'ADPv2RBS'}];
FS = [{8}, {16}];
P = buildParamsMatrix( DATASET, FS );

for pIdx = 1:length(P)
    dataSet = P{pIdx, 1};
    fs = P{pIdx, 2};
    
    %% prepare reconstruct MRBS signals using MATLAB decode
    inFs = fs * 1000;
    inDir = ['F:\IFEFSR\AudioFC\FC\AN4' num2str(fs) '_ADPv2_RBS' minRBS 'T' maxRBS];
    outDir = fullfile(expDirectory, [ dataSet minRBS 'T' maxRBS 'FS' num2str(fs) '16']);
    batchMATLABDecode(  fileList, inDir, outDir, inFs, outFs, inExt, outExt  );
    
end

