function prepareGlobalSphinx()
%PREPAREGLOBALSPHINX Prepare the global file of ExpSphinx
%   each section will create the corpus for sphinxtrain/test
%   each section must change the exp parameters
expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );

%% prepare base 16k signals
inDir = 'F:\IFEFSR\SpeechData\an4\wav';
outDir = fullfile(expDirectory, 'BASE16', 'wav');
inFs = 16000;
outFs = 16000;
inExt = 'raw';
outExt = 'raw';
batchMATLABResample( fileList(1:10), inDir, outDir, inFs, outFs, inExt, outExt )

%% prepare base 8k signals
inDir = 'F:\IFEFSR\SpeechData\an4\wav';
outDir = fullfile(expDirectory, 'BASE8', 'wav');
inFs = 16000;
outFs = 8000;
inExt = 'raw';
outExt = 'raw';
batchMATLABResample( fileList(1:10), inDir, outDir, inFs, outFs, inExt, outExt )

%% prepare reconstruct 16T16k signals
infile = 'F:\IFEFSR\ExpSphinx\an4traintest_small.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\QR\AN4_FIXED_PARTITION_RBS2';
outDir = fullfile(expDirectory, 'FC1616');
inFs = 16000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchJavaDecode( infile, inDir, outDir, inFs, outFs, inExt, outExt );

%% prepare reconstruct 8T16k signals
infile = 'F:\IFEFSR\ExpSphinx\an4traintest_small.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\QR\AN4_FIXED_PARTITION_RBS2';
outDir = fullfile(expDirectory, 'FC816');
inFs = 8000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchJavaDecode( infile, inDir, outDir, inFs, outFs, inExt, outExt );

end

