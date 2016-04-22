% fractal trainer
clear all; close all; clc;

%%
% Define variables
stateSize = 5; % default
observerSize = 128;
workingDir = ['F:\IFEFSR\MData\Set_f11k_with_raw_step_13579_trainfs8dstep1_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
mkdir(workingDir);
load('C:\Project\IFEFSR\MData\listFileName1');
load('C:\Project\IFEFSR\MData\listClassLabel1');
load('F:\IFEFSR\MData\sampling11k_trainfs8dstep1\fData');
wordCount = 18 %max(cell2mat(listClassLabel));
catFractal = [];

tic
for fIdx = 1:2:180%size(listFileName,1)
    f = fData{fIdx}(:,1:3);
    %     fdZM = [f(:,1:2) (f(:,3) - (ones(size(f,1),1)*mean(f(:,3))))./ ...
    %         (ones(size(f,1),1)*std(f(:,3)))];
%     fdZM = (f - (ones(size(f,1),1)*mean(f)))./ ...
%         (ones(size(f,1),1)*std(f));
    fdZM = f;
    catFractal = [catFractal fdZM'];
end
catFractal = (catFractal - (ones(size(catFractal,1),1)*mean(catFractal)))./ ...
        (ones(size(catFractal,1),1)*std(catFractal));
% catFractal = catFractal(:,1:300000);
timeReadSpeech = toc

% cluster and label feature frames
tic
GMM = gmdistribution.fit(catFractal',observerSize,'options',statset('maxiter',300));
save([workingDir 'finishGMMf1']);
timeGMM = toc

tic
for sp = 1:wordCount
    sp
    %% suggest transition and emission
    TRGUESS = [];
    EMITGUESS = [];
    for j = 1:stateSize-1
        TRGUESS = [TRGUESS ; [zeros(1,j-1) rand(1,2) zeros(1,stateSize-j-1)]];
    end
    TRGUESS = rand(stateSize,stateSize);%[TRGUESS; [zeros(1,stateSize-1) rand(1,1)]];
    TRGUESS = TRGUESS./repmat(sum(TRGUESS,2),1,stateSize);
    %         TRGUESS = ones(stateSize,stateSize)/stateSize;
    
    EMITGUESS = rand(stateSize,observerSize);
    EMITGUESS = EMITGUESS./repmat(sum(EMITGUESS,2),1,observerSize);
    ESTTR = TRGUESS;
    ESTEMIT = EMITGUESS;
    
    MODEL{sp} = [{ESTTR},{ESTEMIT}];
end

for idx = 1:2:10 %size(listFileName,1)
    classNum = idx;%listClassLabel{idx};
    % Read speech samples, sampling rate and precision from file
    for i=0:17
        fIdx = i*10 + idx;
        f = fData{fIdx}(:,1:3);
        %         fdZM = [f(:,1:2) (f(:,3) - (ones(size(f,1),1)*mean(f(:,3))))./ ...
        %         (ones(size(f,1),1)*std(f(:,3)))];
%         fdZM = [(f - (ones(size(f,1),1)*mean(f)))./ ...
%             (ones(size(f,1),1)*std(f))];
        fdZM = f;
        seq = cluster(GMM,fdZM);
        
        %% hmm training
        ESTTR = MODEL{classNum}{1};
        ESTEMIT = MODEL{classNum}{2};
        pseudoEmit = ESTEMIT;
        pseudoTr = ESTTR;
        [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
        MODEL{classNum} = [{ESTTR},{ESTEMIT}];
    end
end
save([workingDir 'finishHMMf1']);
timeHMM = toc
time = timeReadSpeech + timeGMM + timeHMM
save([workingDir 'GMM'],'GMM');
save([workingDir 'MODEL'],'MODEL');