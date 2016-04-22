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
stateSize = 5; % default
observerSize = 192;
workingDir = ['F:\IFEFSR\MData\Set_804_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
mkdir(workingDir);
load('F:\IFEFSR\listFileName1');
load('F:\IFEFSR\listClassLabel1');
wordCount = max(cell2mat(listClassLabel));
mappingSheet = [];
catMFCCs = [];

tic
for fIdx = 1:size(listFileName,1)
    % Read speech samples, sampling rate and precision from file
    [ speech, fs ] = audioread( listFileName{fIdx} );
    speech = speech(:,1);
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
        mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    MFCCs = MFCCs(2:end,:);
    
    catMFCCs = [catMFCCs MFCCs];
end
%observerPerSpeech*wordCount +1;
save finishFE1
timeReadSpeech = toc
'FE'
% cluster and label feature frames
tic
GMM = gmdistribution.fit(catMFCCs',observerSize,'SharedCov',true,'options',statset('maxiter',500));
save([workingDir 'WSFinishGMM']);
timeGMM = toc
'GMM'
tic
for sp = 1:wordCount
    sp
    %% suggest transition and emission
    TRGUESS = [];
    EMITGUESS = [];
    for j = 1:stateSize-1
        TRGUESS = [TRGUESS ; [zeros(1,j-1) 1 1 zeros(1,stateSize-j-1)]];
    end
    TRGUESS = TRGUESS/2;  % /2 ,bc just transition to it self and next state
    TRGUESS = [TRGUESS; [zeros(1,stateSize-1) ones(1,1)]];
    %         TRGUESS = ones(stateSize,stateSize)/stateSize;
    
    EMITGUESS = ones(stateSize,observerSize);
    EMITGUESS = EMITGUESS/observerSize;
    ESTTR = TRGUESS;
    ESTEMIT = EMITGUESS;

%     RandTR = rand(stateSize,stateSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
%     ESTTR = RandTR./repmat(sum(RandTR,2),1,stateSize);
%     RandEMIT = rand(stateSize,observerSize); % it is stochastic model % ones(stateSize,stateSize)/stateSize;
%     ESTEMIT = RandEMIT./repmat(sum(RandEMIT,2),1,observerSize);
    MODEL{sp} = [{ESTTR},{ESTEMIT}];
end

for idx = 1:size(listFileName,1)
    % Read speech samples, sampling rate and precision from file
    [ speech, fs ] = audioread( listFileName{idx} );
    speech = speech(:,1);
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
        mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    MFCCs = MFCCs(2:end,:);
    seq = cluster(GMM,MFCCs');
    
    %% hmm training
    ESTTR = MODEL{listClassLabel{idx}}{1};
    ESTEMIT = MODEL{listClassLabel{idx}}{2};
    %     ESTEMIT = pdf(GMM,MFCCs);
    pseudoEmit = ESTEMIT;
    pseudoTr = ESTTR;
    [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
    %     [ESTTR,ESTEMIT] = mybaumwelchtrain(MFCCs,ESTTR,logEmit,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
    MODEL{listClassLabel{idx}} = [{ESTTR},{ESTEMIT}];
end
timeHMM = toc
'HMM'
time = timeReadSpeech + timeGMM + timeHMM
save([workingDir 'WSFinishHMM']);
save([workingDir 'GMM'],'GMM');
save([workingDir 'MODEL'],'MODEL');





