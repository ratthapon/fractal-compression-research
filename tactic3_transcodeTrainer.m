%
%%
% clear all; close all; clc;
%%
% Define variables
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 12;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 12;                 % cepstral sine lifter parameter
LF = 10;               % lower frequency limit (Hz)
HF = 5000;              % upper frequency limit (Hz)

%% fractal code parameter
dFPS = [11025 22050 44100  ]; % decode to frame per second
dFPC = [16 32 64]; % code parameter, frame per code
cFPS = [11025 22050 44100  ]; % stored code, frame per second
cFPC = [16 32 64];

%% HMM GMM parameters
stateSize = 31; % default
observerSize = 90;
wordCount = 18;
fileCountPerWord = 10;
nSample = wordCount * fileCountPerWord;
%% set workspace directoy
dataDir = ['F:\IFEFSR\MData\tactic3_transcode_MFCCWithoutDCT_rawResampling_' ...
    num2str(stateSize) 's' ...
    num2str(observerSize) 'k' '\'];
mkdir(dataDir);
%% output buffer
MFCCsSet = repmat({},size(cFPS,2),size(dFPS,2));
MODELSet = repmat({},size(cFPS,2),size(dFPS,2));
GMMSet = repmat({},size(cFPS,2),size(dFPS,2));
% independent variable size
ivs = size(dFPS,2) * size(cFPS,2);
% dependent variable size
dvs = size(dFPS,2);
featureExtractionTimes = zeros(ivs,dvs);
clusterTimes = zeros(ivs,dvs);
trainingTimes = zeros(ivs,dvs);

%% train model
% each stored code
for cIdx = 1:size(cFPS,2)
    % locate code directory
    codeFileList = importdata(['F:\IFEFSR\' num2str(floor(cFPS(cIdx)/1000)) ...
        'k_train_rawResampling_fs' num2str(cFPC(cIdx)) '_code.txt']);
    
    %% feature extraction
    % each model to decode
    for dIdx = cIdx %1:size(dFPS,2)
        tic;
        % alloc data buffer
        catMFCCs = [];
        for fIdx = 1:nSample
            %% load code and reconstruct signal
            load(codeFileList{fIdx}); % load f data
            signal = fractalDecode(f,cFPS(cIdx),cFPC(cIdx),1,dFPS(dIdx),[],[]);
            signal = ((signal - mean(signal)) / std(signal));
            signal = signal / norm(signal);
            signal = signal * 0.15;
            signal = cmddenoise(signal,denoiseMethod,denoiseLevel);
            clear f;
            
            %% Feature extraction (feature vectors as columns)
            [ MFCCs ] = ...
                mfcc( signal, dFPS(dIdx),...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            %             MFCCs = MFCCs(2:end,:);
            catMFCCs = [catMFCCs MFCCs];

        end
        MFCCsSet(cIdx,dIdx) = {catMFCCs};
        time = toc;
        featureExtractionTimes(cIdx,dIdx) = time;
        save([dataDir 'featureExtractionTimes'],'featureExtractionTimes');
        save([dataDir 'FeatureExtractWS']);
    end
    
    %% cluster and label feature
    for dIdx = cIdx %1:size(dFPS,2) % + 1
        tic;
        while 1 % run forever until success
            try
                GMM = gmdistribution.fit(MFCCsSet{cIdx,dIdx}',observerSize,'SharedCov',true,'options',statset('maxiter',500));
                break;
            catch ex
                ex
            end
        end
        GMMSet(cIdx,dIdx) = {GMM};
        time = toc;
        clusterTimes(cIdx,dIdx) = time;
        save([dataDir 'clusterTimes'],'clusterTimes');
        save([dataDir 'GMMSet'],'GMMSet');
        save([dataDir 'ClusteringWS']);
    end
    
    %% HMM Trainning
    for dIdx = cIdx % 1:size(dFPS,2)
        tic;
        %% load gmm
        GMM = GMMSet{cIdx,dIdx};
        %% alloc buffer
        MODEL = repmat({},1,wordCount);
        
%         %% random initial model
%         for sIdx = 1:wordCount
%             % suggest transition and emission
%             RandTR = rand(stateSize,stateSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
%             ESTTR = RandTR./repmat(sum(RandTR,2),1,stateSize);
%             RandEMIT = rand(stateSize,observerSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
%             ESTEMIT = RandEMIT./repmat(sum(RandEMIT,2),1,observerSize);
%             MODEL{sIdx} = [{ESTTR},{ESTEMIT}];
%         end
        load('F:\IFEFSR\MData\MODEL_initTransition');
        
        %% train model
        for sIdx = 1:wordCount
            for idx = 1:fileCountPerWord
                %% load code and reconstruct signal
                cfIdx = (sIdx-1)*10+idx;
                load(codeFileList{cfIdx}); % get f
                signal = fractalDecode(f,cFPS(cIdx),cFPC(cIdx),1,dFPS(dIdx),[],[]);
                signal = ((signal - mean(signal)) / std(signal));
                signal = signal / norm(signal);
                signal = signal * 0.15;
                signal = cmddenoise(signal,denoiseMethod,denoiseLevel);
                clear f;
                
                %% Feature extraction (feature vectors as columns)
                [ MFCCs ] = ...
                    mfcc( signal, dFPS(dIdx),...
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
        MODELSet(cIdx,dIdx) = {MODEL};
        time = toc;
        trainingTimes(cIdx,dIdx) = time;
        save([dataDir 'trainingTimes'],'trainingTimes');
        save([dataDir 'MODELSet'],'MODELSet');
        save([dataDir 'ModelingWs']);
    end
end