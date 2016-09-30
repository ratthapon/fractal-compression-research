function batchSphinx()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'95'}];
FEATEXTRACTOR = [{'Sphinx5FE'}, ];
FEATCASE = [{'caseA'}, {'caseB'}];

% build dataSet matrix
PREFIX = [{'FCRBS2'}, {'FCRBS4'}, {'FCMATLABRBS2'}, {'FCMATLABRBS4'}, ...
    {'FCMATLABMRBS2T4'}];
CUTOFF = [{'LP6250'}, {'LP6875'}, {'LP7500'}, {'LP8125'}, ...
    {'LP8750'}, {'LP9125'}, {'LP9375'}];
DATASET_CHK = buildParamsMatrix(PREFIX, CUTOFF);
DATASET = cell(size(DATASET_CHK, 1), 1);
for setIdx = 1:size(DATASET_CHK, 1)
    DATASET{setIdx} = [DATASET_CHK{setIdx, 1} DATASET_CHK{setIdx, 2} 'N16FS'];
end
DATASET_NO_CUTOFF = cell(size(PREFIX, 1), 1);
for setIdx = 1:size(PREFIX, 1)
    DATASET_NO_CUTOFF{setIdx} = [PREFIX{setIdx, 1} 'FS'];
end
DATASET = [DATASET_NO_CUTOFF; DATASET; {'BASE'}];

RECOGCASE = [{'origin'}, {'cross'}];
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
    %% initial each workspace
    initSphinxWS(expDirPrefix, preemAlphaStr, featExtractor, ...
        featCase, dataSet, recogCase );
    
    %% launch feature extraction
    extractFeat( expDirPrefix, preemAlphaStr, featExtractor, ...
        featCase, dataSet, recogCase );
    
    %% launch Sphinxtrain
    trainSphinx( expDirPrefix, preemAlphaStr, featExtractor, ...
        featCase, dataSet, recogCase );
    
    %% lauch Sphinxdecode
    testSphinx( expDirPrefix, preemAlphaStr, featExtractor, ...
        featCase, dataSet, recogCase );
    
    %% accumulate results
    logSphinxExp(expDirPrefix, preemAlphaStr, featExtractor, ...
        featCase, dataSet, recogCase )
    
end

