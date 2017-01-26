function batchSphinxUsingHar()
%BATCHINITSPHINXWS Launch batch operations that initialize Sphinx workspace
%directory

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'97'}];
FEATEXTRACTOR = [{'Sphinx5FE'}];
FEATCASE = [ {'caseA'}, {'caseB'}];
NOTES = [{'Spatial harmonic'}, {'Half harmonic filter t1'}, {'Exponential mag filter'},...
    {'N harmonic filter'}];

%% build dataSet matrix
PREFIX = [{'FCMATLABRBS4FS'}];
% HARTYPE = [{'ODD1'}, {'ODD2'}, {'ODD3'}, {'EVEN'}, {'ODDEVEN'}, {'PITCH'}];
% HARTYPE = [ {'PITCH6'}];
HARTYPE = [{'ODD1'}, {'ODD2'}, {'ODD3'}, {'EVEN'}, {'ODDEVEN'}, {'PITCH'}, ...
    {'PITCH2'}, {'PITCH3'}, {'PITCH4'}, {'PITCH5'}, {'PITCH6'}, {'PITCH7'}, ...
    {'PITCH8'}, {'PITCH9'}];
% HARTYPE = [{'ODD1'}, {'ODD2'}, {'ODD3'}, {'EVEN'}, {'ODDEVEN'}, {'PITCHT2'}, ...
%     {'PITCH2T2'}, {'PITCH3T2'}, {'PITCH4T2'}, {'PITCH5T2'}, {'PITCH6T2'}, {'PITCH7T2'}, ...
%     {'PITCH8T2'}, {'PITCH9T2'}];

% % build harmonic dataset
HAR_P = buildParamsMatrix(PREFIX, HARTYPE);
DATASET_WITH_HAR = cell(size(HAR_P, 1), 1);
for setIdx = 1:size(HAR_P, 1)
    DATASET_WITH_HAR{setIdx} = [HAR_P{setIdx, 1} HAR_P{setIdx, 2} 'HARFS'];
end

% build no harmonic dataset
BASE = [{'BASE'}; {'FCMATLABRBS4FS'}];

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
%     elseif strcmpi(featExtractor, 'Sphinx5FE') && ~isempty(regexpi(dataSet, 'pitchhar'))
%         batchMATLABFeat( expDirPrefix, preemAlphaStr, featExtractor, ...
%             featCase, dataSet, recogCase );
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

