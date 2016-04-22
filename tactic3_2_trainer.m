% tactic 0 prove resolution effect
%%
% clear all; close all; clc;
%% set workspace directoy
dataDir = 'F:\IFEFSR\MData\tactic3_NECTEC_MR\';
mkdir(dataDir);
mkdir([dataDir 'signal\']);
mkdir([dataDir 'MFCCs\']);
%%
% Define variables
mfccparams; % load mfcc params

%% audio parameter
modelFPS = [8000 16000 32000 ]; % resampling rate to frame per second
dataSetFPS = [16000]; % base sampling rate frame per second
wordCount = 67;
fileCountPerWord = 1;
speakers = [1 2 3 4 5 6 8 9 10 11]; % from 7 feamale and 5 male
trainFileIdx = [];
for i = speakers
    trainFileIdx = [trainFileIdx (i-1)*wordCount+1:i*wordCount];
end
nTrain = size(trainFileIdx,2);

%% HMM GMM parameters
stateSize = 31; % default
observerSize = 90;

%% output buffer
MFCCsSet = repmat({},size(dataSetFPS,2),size(modelFPS,2));
MODELSet = repmat({},size(dataSetFPS,2),size(modelFPS,2));
GMMSet = repmat({},size(dataSetFPS,2),size(modelFPS,2));
% independent variable size
ivs = size(modelFPS,2);
% dependent variable size
dvs = size(dataSetFPS,2);
featureExtractionTimes = zeros(ivs,dvs);
clusterTimes = zeros(ivs,dvs);
trainingTimes = zeros(ivs,dvs);

%% train model
% each base Fs code
for dataSetFreqIdx = 1:size(dataSetFPS,2)
    %% feature extraction
    % each model to decode
    for modelIdx = 1:size(modelFPS,2)
        tic;
        % locate files list
        filesList = importdata(['F:\IFEFSR\' num2str(floor(modelFPS(modelIdx)/1000)) ...
            'k_NECTEC_matlabResampling.txt']);
        % alloc data buffer
        catMFCCs = [];
        for fIdx = trainFileIdx
            %% load audio data and resample
            signal = audioread(filesList{fIdx});
%             signal = (signal - mean(signal)) / std(signal);
            %% Feature extraction (feature vectors as columns)
            [ MFCCs ] = ...
                mfcc( signal, modelFPS(modelIdx),...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
%             MFCCs = MFCCs(2:end,:);
            catMFCCs = [catMFCCs MFCCs];

        end
        MFCCsSet(dataSetFreqIdx,modelIdx) = {catMFCCs};
        time = toc;
        featureExtractionTimes(dataSetFreqIdx,modelIdx) = time;
        save([dataDir 'featureExtractionTimes'],'featureExtractionTimes');
        save([dataDir 'FeatureExtractWS']);
    end
    
    %% cluster and label feature
    for modelIdx = 1:size(modelFPS,2) % + 1
        tic;
        while 1 % run forever until success
            try
                GMM = gmdistribution.fit(MFCCsSet{dataSetFreqIdx,modelIdx}',observerSize,'SharedCov',true,'options',statset('maxiter',500));
                break;
            catch ex
                ex;
            end
        end
        GMMSet(dataSetFreqIdx,modelIdx) = {GMM};
        time = toc;
        clusterTimes(dataSetFreqIdx,modelIdx) = time;
        save([dataDir 'clusterTimes'],'clusterTimes');
        save([dataDir 'GMMSet'],'GMMSet');
        save([dataDir 'ClusteringWS']);
    end
    
    %% HMM Trainning
    for modelIdx = 1:size(modelFPS,2)
        tic;
        % locate files list
        filesList = importdata(['F:\IFEFSR\' num2str(floor(modelFPS(modelIdx)/1000)) ...
            'k_NECTEC_matlabResampling.txt']);
        %% load gmm
        GMM = GMMSet{dataSetFreqIdx,modelIdx};
        %% alloc buffer
        MODEL = repmat({},1,wordCount);
        
        %% random initial model
        for sIdx = 1:wordCount
            % suggest transition and emission
            RandTR = rand(stateSize,stateSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
            ESTTR = RandTR./repmat(sum(RandTR,2),1,stateSize);
            RandEMIT = rand(stateSize,observerSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
            ESTEMIT = RandEMIT./repmat(sum(RandEMIT,2),1,observerSize);
            MODEL{sIdx} = [{ESTTR},{ESTEMIT}];
        end
        
        %% train model
        for sIdx = 1:wordCount
            for idx = sIdx:wordCount:nTrain
                %% load audio signal
                signal = audioread(filesList{trainFileIdx(idx)});
%                 signal = (signal - mean(signal)) / std(signal);
                %% Feature extraction (feature vectors as columns)
                [ MFCCs ] = ...
                    mfcc( signal, modelFPS(modelIdx),...
                    Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
%                 MFCCs = MFCCs(2:end,:);
                
                %% map features sequence to speech sequence
                seq = cluster(GMM,MFCCs');
                
                %% hmm training
                % load previous model
                ESTTR = MODEL{sIdx}{1};
                ESTEMIT = MODEL{sIdx}{2};
                % prevent zero divide
                pseudoEmit = ESTEMIT;
                pseudoTr = ESTTR;
                
                %% find new transition and emission
                [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,...
                    'algorithm','viterbi',...
                    'PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
                MODEL{sIdx} = [{ESTTR},{ESTEMIT}];
            end
        end
        MODELSet(dataSetFreqIdx,modelIdx) = {MODEL};
        time = toc;
        trainingTimes(dataSetFreqIdx,modelIdx) = time;
        save([dataDir 'trainingTimes'],'trainingTimes');
        save([dataDir 'MODELSet'],'MODELSet');
        save([dataDir 'ModelingWs']);
    end
end
trainProfiler = profile('info');
save([dataDir 'trainProfiler'],'trainProfiler');