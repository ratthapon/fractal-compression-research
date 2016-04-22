% clc; clear all; close all;
% Define variables
% mfccparams; % load mfcc params
% bandparams;
MFCC_PARAMS_STR = ['_MEL_' num2str(M) '_HF_' num2str(HF) '_CC_' num2str(C)];
tactic = 3;
upsample_on = false;

%% audio parameter
DFPS_SET = [ 16000]; % resampling rate to frame per second
EFPS_SET = [8000 16000]; % base sampling rate frame per second
MFPS_SET = [ 16000];

% % nectec
% wordCount = 67;
% fileCountPerWord = 1;
% speakers = [2 4 6 8 10 12]; % from 7 feamale and 5 male
% testFileIdx = [];
% for i = speakers
%     testFileIdx = [testFileIdx (i-1)*wordCount+1:i*wordCount];
% end

% % nectec selected
% wordCount = 4;
% fileCountPerWord = 1;
% speakers = [2 4 6 8 10 12]; % from 7 feamale and 5 male
% trainFileIdx = [];
% for i = speakers
%     trainFileIdx = [trainFileIdx (i-1)*wordCount+1:i*wordCount];
% end

% % our dataset
% wordCount = 18;
% fileCountPerWord = 10;
% nTest = wordCount * fileCountPerWord * size(speakers,2);
RESULTS = [];

% % create result correction
% resultLabel = zeros(1,nTest);
% for speakerIdx = 0:wordCount:nTest-1
%     for spIdx=1:wordCount % each word class
%         for wIdx = 1:fileCountPerWord % each speech sample in class
%             resultLabel((spIdx-1)*fileCountPerWord+wIdx + speakerIdx) = spIdx;
%         end
%     end
% end
tic;
% DATA_SET = '_NECTEC_MR_4_128_INT_Thesh1E-4AA2';
% DATA_SET = '_ARMS_REC_INT_Thesh1E-4AA2';
for MFPS = MFPS_SET % model for test
    for EFPS = EFPS_SET
        for DFPS = DFPS_SET
            filesList = importdata(['F:\IFEFSR\' num2str(floor(EFPS/1000)) 'to' ...
                num2str(floor(DFPS/1000)) DATA_SET '.txt']);
            load(['F:\IFEFSR\Recognition analysis\tactic3_GMM_' num2str(floor(MFPS/1000)) 'to' ...
                num2str(floor(MFPS/1000)) DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND']);
            load(['F:\IFEFSR\Recognition analysis\tactic3_MODEL_' num2str(floor(MFPS/1000)) 'to' ...
                num2str(floor(MFPS/1000)) DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND']);
            core_tester;
            % accrate of model xx test by input yy resample to zz emit acc
            RESULTS = [RESULTS; [MFPS EFPS DFPS HF accRate]];
%             save(['F:\IFEFSR\Recognition analysis\tactic3_RESULTS_' num2str(floor(EFPS/1000)) 'to' ...
%                 num2str(floor(DFPS/1000)) '_vsMODEL_' num2str(floor(MFPS/1000)) ...
%                 DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND']);
        end
    end
end
mean(RESULTS)
allTime = toc