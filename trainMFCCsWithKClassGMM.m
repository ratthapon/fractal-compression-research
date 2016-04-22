clear all; close all; clc;

%%
% Define variables
Tw = 25;                % analysis frame duration (ms)
Ts = 20;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)
stateSize = 32; % default
observerSize = 32;
workingDir = ['F:\IFEFSR\MData\Set_804_' num2str(observerSize) 'Component' num2str(stateSize) 'ContinuousStatesMultiGMM\'];
mkdir(workingDir);
load('F:\IFEFSR\listFileName1');
load('F:\IFEFSR\listClassLabel1');
label = cell2mat(listClassLabel);
wordCount = max(label);
mappingSheet = [];
catMFCCs = [];
trainTime = 0;

for modelIdx = 1:wordCount
    tic
    catMFCCs = [];
    fileIdx = find(label==modelIdx)';
    ObSegs = {};
    for fIdx = 1:size(fileIdx,2)
        % Read speech samples, sampling rate and precision from file
        [ speech, fs ] = audioread( listFileName{fileIdx(fIdx)} );
        speech = speech(:,1);
        % Feature extraction (feature vectors as columns)
        [ MFCCs, FBEs, frames ] = ...
            mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        MFCCs = MFCCs(2:end,:);
        ObSegs{fIdx} = MFCCs;
        catMFCCs = [catMFCCs MFCCs];
    end
    % cluster and label feature frames
    GMM = gmdistribution.fit(catMFCCs',observerSize,'SharedCov',true,'options',statset('maxiter',300));
    
    RandTR = rand(stateSize,stateSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
    ESTTR = RandTR./repmat(sum(RandTR,2),1,stateSize);
    pseudoTr = ESTTR;
    for i = 1:size(ObSegs,2)
        [~,logEmit] = pdf(GMM,ObSegs{i}');
        EMITGUESS = ones(stateSize,size(ObSegs{i},2));
        EMITGUESS = EMITGUESS/size(ObSegs{i}',2);
        pseudoEmit = EMITGUESS;
%         logEmit = repmat(logEmit',stateSize,1);
        %[ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
        [ESTTR,ESTEMIT] = mybaumwelchtrain(ObSegs{i},ESTTR,logEmit','algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
    end
    modelTime = toc;
    trainTime = trainTime + modelTime;
    MODEL{modelIdx} = [{ESTTR},{GMM},{modelTime}];
end
save([workingDir 'WS']);
'FE'
% save('F:\IFEFSR\MData\Set_804_32Component5StatesContinuousSigleCLassGMM\GMM','GMM');
save([workingDir 'MODEL'],'MODEL');





