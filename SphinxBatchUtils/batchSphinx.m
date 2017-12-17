function batchSphinx()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'95'}];
FEATEXTRACTOR = [{'Sphinx5FE'}, ];
FEATCASE = [{'caseA'}, {'caseB'}];
NOTES = [{'lifter 22'}, {'30 Mel Ch.'} , {'Varry LP Type 0'}];
HIFILT = {[{'CFG_HI_FILT'}, {'4000'}]; ...
    [{'CFG_HI_FILT'}, {'4500'}]; ...
    [{'CFG_HI_FILT'}, {'5000'}]; ...
    [{'CFG_HI_FILT'}, {'5500'}]; ...
    [{'CFG_HI_FILT'}, {'6000'}]; ...
    [{'CFG_HI_FILT'}, {'6500'}]; ...
    [{'CFG_HI_FILT'}, {'7000'}]; ...
    };

%% build dataSet matrix
PREFIX = [{'BASE'}];
TYPE = [{'T2'}, {'T3'}];
DATASET_WITH_CUTOFF = [];
DATASET_NO_CUTOFF = [];

% % build cutoff dataset
CUTOFF = num2cell((4000:500:7500));
CUTOFF_P = buildParamsMatrix(PREFIX, TYPE, CUTOFF);
DATASET_WITH_CUTOFF = cell(size(CUTOFF_P, 1), 1);
for setIdx = 1:size(CUTOFF_P, 1)
    DATASET_WITH_CUTOFF{setIdx} = [CUTOFF_P{setIdx, 1} CUTOFF_P{setIdx, 2} 'LP' num2str(CUTOFF_P{setIdx, 3}) 'N16FS'];
end

% build no cutoff dataset
DATASET_NO_CUTOFF = cell(size(PREFIX, 1), 1);
for setIdx = 1:size(PREFIX, 1)
    DATASET_NO_CUTOFF{setIdx} = [PREFIX{setIdx, 1} ''];
end

DATASET = [DATASET_NO_CUTOFF; DATASET_WITH_CUTOFF];

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
%     parameters = P{expIdx, 7};
    parameters = [];
    
    %% initial each workspace
    initSphinxWS(expDirPrefix, preemAlphaStr, featExtractor, ...
        featCase, dataSet, recogCase, parameters, NOTES );
    
    %% launch feature extraction
%     batchMATLABFeat( expDirPrefix, preemAlphaStr, featExtractor, ...
%         featCase, dataSet, recogCase );
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
        featCase, dataSet, recogCase, parameters, NOTES )
    
end

