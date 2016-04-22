% tactic 0 prove resolution effect
load(['F:\IFEFSR\Recognition analysis\SampleIdx_' SUBBAND '_BAND.mat']);
load(['F:\IFEFSR\Recognition analysis\FIXED_MODEL_NECTEC_' SUBBAND]);
% trainClass = trainClass(trainIdx<=48);
% trainIdx = trainIdx(trainIdx<=48);
%% train model
%% feature extraction
% alloc data buffer
catMFCCs = [];
tic;
for fIdx = trainIdx(:)'
    %% load audio data and resample
    [signal,Fs] = audioread(filesList{fIdx});
%     figure(1),plot(signal);
    %             signal = (signal - mean(signal)) / std(signal);
    %% Feature extraction (feature vectors as columns)
    [MFCCs] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    catMFCCs = [catMFCCs MFCCs];
    
end
time = toc;
featureExtractionTimes = time

%% cluster and label feature
tic;
while 1 % run forever until success
    try
        GMM = gmdistribution.fit(catMFCCs',observerSize, ...
            'SharedCov',true,'options',statset('maxiter',300));
        break;
    catch ex
        ex
    end
end
time = toc;
clusterTimes = time

%% HMM Trainning
tic;
%% alloc buffer
% MODEL = repmat({},1,wordCount);

%% random initial model
% for mIdx = 1:wordCount
%     % suggest transition and emission
%     RandTR = rand(stateSize,stateSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
%     ESTTR = RandTR./repmat(sum(RandTR,2),1,stateSize);
%     RandEMIT = rand(stateSize,observerSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
%     ESTEMIT = RandEMIT./repmat(sum(RandEMIT,2),1,observerSize);
%     MODEL{mIdx} = [{ESTTR},{ESTEMIT}];
% end

%% train model
for idx = 1:size(trainIdx(:)',2) % for subband
    mIdx = trainClass(idx);
    
    % for idx = (mIdx-1)*fileCountPerWord+1:1:mIdx*fileCountPerWord % for own dataset
    %% load audio signal
    [signal,Fs] = audioread(filesList{trainIdx(idx)});
    
    %% Feature extraction (feature vectors as columns)
    [MFCCs] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    
    %% map features sequence to speech sequence
    seq = cluster(GMM,MFCCs');
    
    %% hmm training
    % load previous model
    ESTTR = MODEL{mIdx}{1};
    ESTEMIT = MODEL{mIdx}{2};
    % prevent zero divide
    pseudoEmit = ESTEMIT;
    pseudoTr = ESTTR;
    
    %% find new transition and emission
    [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,...
        'algorithm','viterbi',...
        'PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
    MODEL{mIdx} = [{ESTTR},{ESTEMIT}];
end

time = toc;
trainingTimes = time
