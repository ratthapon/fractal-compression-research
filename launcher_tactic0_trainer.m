% clc; clear all; close all;
% Define variables
% mfccparams; % load mfcc params
% bandparams;
MFCC_PARAMS_STR = ['_MEL_' num2str(M) '_HF_' num2str(HF) '_CC_' num2str(C)];
%% audio parameter
DFPS_SET = [ 16000]; % resampling rate to frame per second
EFPS_SET = [ 16000]; % base sampling rate frame per second

% nectec
wordCount = 67;
fileCountPerWord = 1;
% speakers = [1 3 5 7 9 11]; % from 7 feamale and 5 male
% trainFileIdx = [];
% for i = speakers
%     trainFileIdx = [trainFileIdx (i-1)*wordCount+1:i*wordCount];
% end

% % nectec selected
% wordCount = 4;
% fileCountPerWord = 1;
% speakers = [1 3 5 7 9 11]; % from 7 feamale and 5 male
% trainFileIdx = [];
% for i = speakers
%     trainFileIdx = [trainFileIdx (i-1)*wordCount+1:i*wordCount];
% end

% % our dataset
% wordCount = 18;
% fileCountPerWord = 10;
% trainFileIdx = 1:wordCount * fileCountPerWord;

% nTrain = size(trainFileIdx,2);

%% HMM GMM parameters
stateSize = 31; % default
observerSize = 90;
% DATA_SET = 'k_NECTEC_MR';
% DATA_SET = 'k_ARMS_REC_INT';
for EFPS = EFPS_SET
    for DFPS = EFPS %DFPS_SET
        filesList = importdata(['F:\IFEFSR\' num2str(floor(EFPS/1000)) DATA_SET '.txt']);
        core_tactic0_trainer;
        save(['F:\IFEFSR\Recognition analysis\tactic0_GMM_' num2str(floor(EFPS/1000)) 'to' ...
            num2str(floor(EFPS/1000)) DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND'],'GMM');
        save(['F:\IFEFSR\Recognition analysis\tactic0_MODEL_' num2str(floor(EFPS/1000)) 'to' ...
            num2str(floor(EFPS/1000)) DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND'],'MODEL');
        save(['F:\IFEFSR\Recognition analysis\tactic0_TRAIN_WS_' num2str(floor(EFPS/1000)) 'to' ...
            num2str(floor(EFPS/1000)) DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND']);
    end
end

trainProfiler = profile('info');
