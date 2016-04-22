load(['F:\IFEFSR\Recognition analysis\SampleIdx_' SUBBAND '_BAND.mat']);
% label = trainClass(trainIdx<=48);
% testIdx = trainIdx(trainIdx<=48);
nTest = size(testIdx(:)',2);
% alloc output log sequence probability buffer
LOGPSEQBuffer = zeros(size(MODEL,2),nTest);
for fIdx = 1:nTest
    %% load audio data and resample
    [signal,Fs] = audioread(filesList{testIdx(fIdx)});
%     if (tactic==0) && upsample_on && (Fs==8000)
%         signal = upsample(signal,2);
%         Fs = 16000;
%     end
    
    %% Feature extraction (feature vectors as columns)
    [MFCCs] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
%     figure(1),imagesc(MFCCs);
    
    %% map features sequence to speech sequence
    seq = cluster(GMM,MFCCs');

    %% test sample by each model
    for mIdx = 1:size(MODEL,2)
        model = MODEL{mIdx}; % point to model
        ESTTR = model{1};
        ESTEMIT = model{2};
        % find probability of single sequence
        [~,LOGPSEQ] = hmmviterbi(seq',ESTTR,ESTEMIT);
        LOGPSEQBuffer(mIdx,fIdx) = LOGPSEQ;
    end
end
%% find max probability of sequences
[~,outClass] = max(LOGPSEQBuffer);
%% calculate accuracy rate
accRate = sum(outClass == label')/size(label',2);
report_viewClassAcc;
%% timing
time = toc;