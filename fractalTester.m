
clear all; close all; clc;

%%
% Define variables
stateSize = 5; % default
observerSize = 192;
workingDir = ['F:\IFEFSR\MData\Set_f11k_13579_trainfs8dstep1_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
mkdir(workingDir);
load([workingDir 'MODEL']);
load([workingDir 'GMM']);
load('F:\IFEFSR\MData\sampling11k_trainfs8dstep1\fData');
outputLog = [];
rate = [];

tic
for idx = 1:2:180 %size(ZMfData,1)
    idx
    % Read speech samples, sampling rate and precision from file
    f = fData{idx}(:,1:2);
    %     fdZM = [f(:,1:2) (f(:,3) - (ones(size(f,1),1)*mean(f(:,3))))./ ...
    %         (ones(size(f,1),1)*std(f(:,3)))];
    fdZM = (f - (ones(size(f,1),1)*mean(f)))./ ...
        (ones(size(f,1),1)*std(f));
    
    seq = cluster(GMM,f);
    logEachSpeech = [];
    for m = 1:size(MODEL,2)
        model = MODEL{m}; % gmdistribution.fit(MFCCs',observerSize);
        ESTTR = model{1};
        ESTEMIT = model{2};
        [PSTATES, LOGPSEQ] = hmmviterbi(seq',ESTTR,ESTEMIT);
        % equivalence viteribi
        % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
        logEachSpeech = [logEachSpeech;LOGPSEQ];
    end
    outputLog = [outputLog logEachSpeech];
end
[maxVal resultIdx] = max(outputLog);
% rate = [rate sum(resultIdx==listClassLabel')/size(resultIdx,2)];
% result = zeros(wordCount,wordCount);
% for i=1:wordCount
%     for j = 1:10
%         idx=(i-1)*10+j;
%         result(listClassLabel(idx),resultIdx(idx)) = result(listClassLabel(idx),resultIdx(idx)) + 1;
%     end
% end


% label generator for sampling rate set datas
classLabelMatrix = vec2mat(1:2:180,5);
for i=1:size(classLabelMatrix,1)
    classLabelMatrix(i,:) = i;
end
correct = vec2mat(resultIdx,5)==classLabelMatrix;
caseNum = prod(size(classLabelMatrix));
rate = sum(sum(correct))/caseNum;

time = toc