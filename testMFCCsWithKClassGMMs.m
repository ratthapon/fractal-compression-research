
clear all; close all; clc;

%%
% Define variables
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)
outputLog = [];
rate = [];
load('F:\IFEFSR\listFileName1');
load('F:\IFEFSR\listClassLabel1');
stateSize = 32; % default
observerSize = 32;
workingDir = ['F:\IFEFSR\MData\Set_804_' num2str(observerSize) 'Component' num2str(stateSize) 'ContinuousStatesMultiGMM\'];
mkdir(workingDir);
load([workingDir 'MODEL']);
listClassLabel = cell2mat(listClassLabel);
wordCount = max(listClassLabel);
tic
for idx = 1:50% size(listFileName,1)
    % Read speech samples, sampling rate and precision from file
    [ speech, fs ] = audioread( listFileName{idx} );
    speech = speech(:,1);
    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
        mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    MFCCs = MFCCs(2:end,:);
    
    logEachSpeech = [];
    for m = 1:size(MODEL,2)
        model = MODEL{m}; % gmdistribution.fit(MFCCs',observerSize);
        ESTTR = model{1};
        GMM = model{2};
        ESTEMIT = pdf(GMM,MFCCs');
        logEmit = repmat(ESTEMIT',size(ESTTR,1),1);
        [LOGPSEQ] = myviterbi(MFCCs,ESTTR,logEmit);
        % equivalence viteribi
        % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
        logEachSpeech = [logEachSpeech;LOGPSEQ];
    end
    outputLog = [outputLog logEachSpeech];
end
[maxVal resultIdx] = max(outputLog);
rate = [rate sum(resultIdx==listClassLabel')/size(resultIdx,2)];
% result = zeros(wordCount,wordCount);
% for i=1:wordCount
%     for j = 1:10
%         idx=(i-1)*10+j;
%         result(listClassLabel(idx),resultIdx(idx)) = result(listClassLabel(idx),resultIdx(idx)) + 1;
%     end
% end
time = toc