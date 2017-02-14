function batchSphinxUsingHar()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'97'}];
FEATEXTRACTOR = [{'Sphinx5FE'}];
FEATCASE = [ {'caseA'}, {'caseB'}];
NOTES = [{'Frequency harmonic'}, {'Half harmonic filter t7.0'}, {'Exponential mag filter'},...
    {'N harmonic filter'}, {'Fix pitches sorting'}, {'n-th oder harmonic'}, {'n-pitch'}];

%% build dataSet matrix
PREFIX = [{'FCMATLABRBS4FS'}];
HARTPYEPREFIX = [{'PITCH5'}];
NHAR = [{'NHAR10'}];
MINPD = [{'MINPD10'}];
TYPEVERSION = [{'T8'}];
HARTYPE = [];
HP = buildParamsMatrix( HARTPYEPREFIX, NHAR, MINPD, TYPEVERSION );
for hpIdx = 1:size(HP, 1)
    harType = HP{hpIdx, 1};
    nHar = HP{hpIdx, 2};
    minPD = HP{hpIdx, 3};
    typeVer = HP{hpIdx, 4};
    HARTYPE{hpIdx} = [harType nHar minPD typeVer];
end

% % build harmonic dataset
HAR_P = buildParamsMatrix(PREFIX, HARTYPE);
DATASET_WITH_HAR = cell(size(HAR_P, 1), 1);
for setIdx = 1:size(HAR_P, 1)
    DATASET_WITH_HAR{setIdx} = [HAR_P{setIdx, 1} HAR_P{setIdx, 2} 'HARFS'];
end

% build no harmonic dataset
BASE = [{'BASE'}; PREFIX];

% DATASET = [DATASET_NO_HAR; DATASET_WITH_HAR];
DATASET = [BASE; DATASET_WITH_HAR];

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
    if strcmpi(featExtractor, 'MATLAB')
        batchMATLABFeat( expDirPrefix, preemAlphaStr, featExtractor, ...
            featCase, dataSet, recogCase );
    elseif strcmpi(featExtractor, 'Sphinx5FE')
        extractFeat( expDirPrefix, preemAlphaStr, featExtractor, ...
            featCase, dataSet, recogCase );
    end
    
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

