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
batchMATLABResample( fileList, inDir, outDir, inFs, outFs, inExt, outExt )

%% prepare base 8k signals
inDir = 'F:\IFEFSR\SpeechData\an4\wav';
outDir = fullfile(expDirectory, 'BASE8', 'wav');
inFs = 16000;
outFs = 8000;
inExt = 'raw';
outExt = 'raw';
batchMATLABResample( fileList, inDir, outDir, inFs, outFs, inExt, outExt )

%% prepare reconstruct 16T16k signals
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\AN416_FP_RBS2';
outDir = fullfile(expDirectory, 'FCRBS2FS1616');
inFs = 16000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchJavaDecode( infile, inDir, outDir, inFs, outFs, inExt, outExt );

%% prepare reconstruct 8T16k signals
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\AN48_FP_RBS2';
outDir = fullfile(expDirectory, 'FCRBS2FS816');
inFs = 8000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchJavaDecode( infile, inDir, outDir, inFs, outFs, inExt, outExt );

%% prepare reconstruct 16T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\AN416_FP_RBS2';
outDir = fullfile(expDirectory, 'FCMATLABRBS2FS1616');
inFs = 16000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABDecode( fileList, inDir, outDir, inFs, outFs, inExt, outExt );

%% prepare reconstruct 8T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\AN48_FP_RBS2';
outDir = fullfile(expDirectory, 'FCMATLABRBS2FS816');
inFs = 8000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABDecode( fileList, inDir, outDir, inFs, outFs, inExt, outExt );

%% prepare reconstruct MRBS 16T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\AN416_FP_RBS';
outDir = fullfile(expDirectory, 'FCMATLABMRBS2T4FS1616');
RBS = [{'4'}, {'2'}];
inFs = 16000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABMRBSDecode(  fileList, inDir, RBS, outDir, inFs, outFs, inExt, outExt  );

%% prepare reconstruct MRBS 8T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest.txt';
inDir = 'F:\IFEFSR\AudioFC\FC\AN48_FP_RBS';
outDir = fullfile(expDirectory, 'FCMATLABMRBS2T4FS816');
RBS = [{'4'}, {'2'}];
inFs = 8000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABMRBSDecode(  fileList, inDir, RBS, outDir, inFs, outFs, inExt, outExt  );

end

