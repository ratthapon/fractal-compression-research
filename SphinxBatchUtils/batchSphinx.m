function batchSphinx()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'95'}];
FEATEXTRACTOR = [{'Sphinx5FE'}, ];
FEATCASE = [{'caseA'}, {'caseB'}];
% DATASET = [ {'FCRBS2FS'}, {'FCRBS2LP6875N16FS'}, {'FCRBS2LP9125N16FS'}, ...
%     {'FCRBS4FS'}, {'FCRBS4LP6875N16FS'}, {'FCRBS4LP9125N16FS'}];
DATASET = [ {'FCMATLABRBS2FS'}, {'FCMATLABRBS2LP6250N16FS'}, {'FCMATLABRBS2LP6875N16FS'}, {'FCMATLABRBS2LP9125N16FS'}, ...
    {'FCMATLABRBS4FS'}, {'FCMATLABRBS2LP6250N16FS'}, {'FCMATLABRBS4LP6875N16FS'}, {'FCMATLABRBS4LP9125N16FS'}];
% DATASET = [ {'FCMATLABMRBS2T4FS'}, {'FCMATLABMRBS2T4LP6250N16FS'}, ...
%     {'FCMATLABMRBS2T4LP6875N16FS'}, {'FCMATLABMRBS2T4LP9125N16FS'},];
RECOGCASE = [{'origin'}, {'cross'}];
P = buildParamsMatrix( EXP, PREEMP, FEATEXTRACTOR, ...
    FEATCASE, DATASET, RECOGCASE);

%% iterate for each parameters combination
for expIdx = 1:size(P, 1);
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

