function batchSphinxUsingHar()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'95'}];
FEATEXTRACTOR = [{'Sphinx5FE'}, ];
FEATCASE = [{'caseA'}, {'caseB'}];
NOTES = [{'Harmonic test'}];

%% build dataSet matrix
PREFIX = [{'BASE'}];
HARTYPE = [ {'ODDEVEN'}];

% % build harmonic dataset
HAR_P = buildParamsMatrix(PREFIX, HARTYPE);
DATASET_WITH_HAR = cell(size(HAR_P, 1), 1);
for setIdx = 1:size(HAR_P, 1)
    DATASET_WITH_HAR{setIdx} = [HAR_P{setIdx, 1} HAR_P{setIdx, 2} 'HARFS'];
end

% build no harmonic dataset
DATASET_NO_HAR = cell(size(PREFIX, 1), 1);
for setIdx = 1:size(PREFIX, 1)
    DATASET_NO_HAR{setIdx} = [PREFIX{setIdx, 1} ''];
end

% DATASET = [DATASET_NO_HAR; DATASET_WITH_HAR];
DATASET = [ DATASET_WITH_HAR];

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

