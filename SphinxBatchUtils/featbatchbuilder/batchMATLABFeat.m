function batchMATLABFeat( expDirPrefix, preemAlphaStr, featExtractor, ...
    featCase, dataSet, recogCase )
%BATCHMATLABFEAT Batch feature extraction using MATLAB MFCC
%   expDir - sphinx's experiment directory

expDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4');
[ cfg ] = parseSphinxCfg( fullfile(expDir, 'etc', 'sphinx_train.cfg') ); % read exp config

trainFileList = importdata(fullfile(expDir, 'etc\an4_train.fileids'));
testFileList = importdata(fullfile(expDir, 'etc\an4_test.fileids'));
fsTrain = str2double(getSphinxCfg(cfg, 'CFG_WAVFILE_SRATE'));
fsTest = str2double(getSphinxCfg(cfg, 'T_CFG_WAVFILE_SRATE'));
trainWavDir = getSphinxCfg(cfg, 'CFG_WAVFILES_DIR');
testWavDir = getSphinxCfg(cfg, 'CFG_TEST_WAVFILES_DIR');
inExt = getSphinxCfg(cfg, 'CFG_WAVFILE_EXTENSION');
outExt = getSphinxCfg(cfg, 'CFG_FEATFILE_EXTENSION');

% extract train features
n = length(trainFileList);
for i = 1:n
    % read input wave
    inWave = [];
    if strcmpi('raw', inExt)
        inWavePath = normpath(char(strcat(trainWavDir, '/', trainFileList{i}, '.raw')));
        inWave = rawread(inWavePath);
    end
    
    % extract ffeat
    CC = mfcc2( inWave, fsTrain);
    
    % write output feat
    outFeatName = normpath(char(strcat(expDir, '/feat/', trainFileList{i}, '.', outExt)));
    outDir = fileparts(outFeatName);
    mkdir(outDir);
    featwrite( outFeatName , CC);
end

% extract test features
n = length(testFileList);
for i = 1:n
    % read input wave
    inWave = [];
    if strcmpi('raw', inExt)
        inWavePath = normpath(char(strcat(testWavDir, '/', testFileList{i}, '.raw')));
        inWave = rawread(inWavePath);
    end
    
    % extract ffeat
    CC = mfcc2( inWave, fsTest);
    
    % write output feat
    outFeatName = normpath(char(strcat(expDir, '/feat/', testFileList{i}, '.', outExt)));
    outDir = fileparts(outFeatName);
    mkdir(outDir);
    featwrite( outFeatName , CC);
end
