function batchInitSphinxWS()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'95'}, ];
FEATEXTRACTOR = [{'Sphinx5FE'}, ];
FEATCASE = [{'caseA'}, {'caseB'}];
DATASET = [{'BASE'}, {'FCRBS2FS'}];
RECOGCASE = [{'origin'}, {'cross'}];
P = buildParamsMatrix( EXP, PREEMP, FEATEXTRACTOR, ...
    FEATCASE, DATASET, RECOGCASE);

%% iterate for each parameters combination
for expIdx = 1:1 %size(P, 1);
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
    
    %% lauch Sphinxdecode
    
    %% accumulate results
end

