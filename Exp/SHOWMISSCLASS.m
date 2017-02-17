
%% missclass functions
thresh = 0;
accRate = @(result) result(2) / result(1);
readResult = @(record) sscanf(record, 'Words: %d Correct: %d Errors: %d');
isMissClass = @(record) thresh >= accRate(readResult(record)); % test function
isCorrectClass = @(record) 1-thresh <= accRate(readResult(record)); % test function

expDir = 'F:\IFEFSR\ExpSphinx\';
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);
% errorRelation = @union;
% errorRelation = @intersect;
errorRelation = @setdiff;
% errorRelation = @(expError, baseError) expError;

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'97'}];
FEATEXTRACTOR = [{'Sphinx5FE'}];
FEATCASE = [ {'caseA'}, {'caseB'}];
NOTES = [{'Frequency harmonic'}, {'Half harmonic filter t7.0'}, {'Exponential mag filter'},...
    {'N harmonic filter'}, {'Fix pitches sorting'}, {'n-th oder harmonic'}, {'n-pitch'}];

%% build dataSet matrix
PREFIX = [{'FCMATLABRBS4FS'}];
HARTPYEPREFIX = [{'PITCH3'}];
NHAR = [{'NHAR20'}];
MINCD = [{'MINCD1'}];
MINHD = [{'MINHD10'}];
EXCLUDEORIGIN = [{'EXCLUDEORIGIN'}];
TYPEVERSION = [{'T9'}];
HARTYPE = [];
HP = buildParamsMatrix( EXCLUDEORIGIN, HARTPYEPREFIX, NHAR, MINCD, MINHD, TYPEVERSION );
for hpIdx = 1:size(HP, 1)
    excludeOrigin = HP{hpIdx, 1};
    harType = HP{hpIdx, 2};
    nHar = HP{hpIdx, 3};
    minCD = HP{hpIdx, 4};
    minHD = HP{hpIdx, 5};
    typeVer = HP{hpIdx, 6};
    HARTYPE{hpIdx} = [harType nHar minCD minHD excludeOrigin typeVer];
end

% % build harmonic dataset
HAR_P = buildParamsMatrix(PREFIX, HARTYPE);
DATASET_WITH_HAR = cell(size(HAR_P, 1), 1);
for setIdx = 1:size(HAR_P, 1)
    DATASET_WITH_HAR{setIdx} = [HAR_P{setIdx, 1} HAR_P{setIdx, 2} 'HARFS'];
end

% build no harmonic dataset
BASE = [PREFIX];

% DATASET = [DATASET_NO_HAR; DATASET_WITH_HAR];
DATASET = [BASE; DATASET_WITH_HAR];

RECOGCASE = [{'origin'}];
P = buildParamsMatrix( EXP, PREEMP, FEATEXTRACTOR, ...
    FEATCASE, DATASET, RECOGCASE);

%% iterate for each parameters combination
for expIdx = 1:size(P, 1)
    expDirPrefix = P{expIdx, 1};
    preemAlphaStr = P{expIdx, 2};
    featExtractor = P{expIdx, 3};
    featCase = P{expIdx, 4};
    dataSet = P{expIdx, 5};
    recogCase = P{expIdx, 6};
    
    %% read result record
    baseDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, 'BASE', 'origin', 'an4\');
    alignFile = 'result\an4.align';
    fileList  = importdata('F:\IFEFSR\ExpSphinx\etc\an4_test.fileids'); % test file list
    
    % baseline record
    fid = fopen([baseDir alignFile],'r');
    baseRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    baseRecord = baseRecord{1}(4:4:end-1);
    
    % inspecting record
    expDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, dataSet, recogCase, 'an4\');
    fid = fopen([expDir alignFile],'r');
    reconRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    reconRecord = reconRecord{1}(4:4:end-1);
    
    % expecting record
    originDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, PREFIX{1}, recogCase, 'an4\');
    fid = fopen([originDir alignFile],'r');
    originRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    originRecord = originRecord{1}(4:4:end-1);
    
    % error list
    missBase = [];
    missRecon = [];
    missOrigin = [];
    
    for sampleIdx = 1:size(fileList, 1)
        % error information information
        baseError(sampleIdx, :) = readResult(baseRecord{sampleIdx})';
        reconError(sampleIdx, :) = readResult(reconRecord{sampleIdx})';
        originError(sampleIdx, :) = readResult(originRecord{sampleIdx})';
        
        % check if sample is miss class
        if isMissClass(baseRecord{sampleIdx})
            missBase = [missBase sampleIdx];
        end
        if isMissClass(reconRecord{sampleIdx})
            missRecon = [missRecon sampleIdx];
        end
        if isMissClass(originRecord{sampleIdx})
            missOrigin = [missOrigin sampleIdx];
        end
    end
    
    %% exclude baseline missing, extract error relation
    realMissRecon = setdiff(...
        errorRelation(missOrigin, missRecon), ...
        missBase);
    
    %% set input wave prefix/suffix
    expDir = 'F:\IFEFSR\ExpSphinx\';
    expSuffix = '';
    baseSuffix = '1616';
    if regexp(recogCase, 'cross')
        expSuffix = '816';
    elseif regexp(recogCase, 'origin')
        expSuffix = '1616';
    end
    
    %% iterate over co-miss class
    for i = 1:size(realMissRecon, 2)
        %% read speech signals
        baseSpeech = rawread(normpath(fullfile(expDir, ...
            'BASE16', 'wav', [fileList{realMissRecon(i)} '.raw'])));
        [ CC00, FBE00, OUTMAG00, MAG00, H00, DCT00] = mfcc2( baseSpeech, 16000);
        
        originSpeech = rawread(normpath(fullfile(expDir, ...
            [dataSet baseSuffix], 'wav', [fileList{realMissRecon(i)} '.raw'])));
        [ CC0, FBE0, OUTMAG0, MAG0, H0, DCT0] = mfcc2( originSpeech, 16000);
        
        reconSpeech = rawread(normpath(fullfile(expDir, ...
            [dataSet expSuffix], 'wav', [fileList{realMissRecon(i)} '.raw'])));
        [ CC1, FBE1, OUTMAG1, MAG1, H1, DCT1] = mfcc2( reconSpeech, 16000);
        
        %% visualize spectrum
        figure(1),
        plotCMPSpec(1, ...
            -OUTMAG00, 'BASE', ...
            -OUTMAG0, [dataSet ' 16->16'], ...
            -OUTMAG1, [dataSet ' ' expSuffix] ...
            );
        colormap default
        
        % my 1st screen
        set(gcf, 'position', [0 0 900 400])
        
        % my 2nd screen
        %     set(gcf, 'position', [0 0 900 400])
        
        % lab 2nd screen
        %     set(gcf, 'position', [-1600 0 1600 1280])
    end
end



