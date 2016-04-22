%%
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
dFsSet = [11025];
eFs = [8];
aFs = [11025];%11025 22050 44100 audio Fs or sampling rate
stateSize = 5; % default
observerSize = 192;
wordCount = 18;
fileCountPerWord = 10;
for dFs = dFsSet
    allMFCCs = [];
    MFCCsSet = [];
    MODELSet = [];
    GMMSet = [];
    
    tic
    for sIdx = 1:size(aFs,2)
        workingDir = ['F:\IFEFSR\MData\tactic3_transcode_' num2str(floor(aFs(sIdx)/1000)) 'to' num2str(floor(dFs/1000)) ...
        'k_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
        mkdir(workingDir);
        catMFCCs = [];
        for fIdx = 1:wordCount*fileCountPerWord
            % Read speech samples, sampling rate and precision from file
            load(['F:\IFEFSR\Output\sampling' num2str(floor(aFs(sIdx)/1000)) ...
                'k_trainfs' num2str(eFs(sIdx)) 'dstep1\' num2str(fIdx)]);
            signal = fractalDecode(f,aFs(sIdx),eFs(sIdx),1,dFs,[],[]);
            % Feature extraction (feature vectors as columns)
            [ MFCCs ] = ...
                mfcc( signal, dFs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            
            catMFCCs = [catMFCCs MFCCs];
        end
        allMFCCs = [allMFCCs catMFCCs];
        MFCCsSet = [MFCCsSet {catMFCCs}];
    end
    MFCCsSet = [MFCCsSet {allMFCCs}];
    save([workingDir 'WS_FE']);
    timeReadSpeech = toc
    'FE'
    % cluster and label feature frames
    tic
    for sIdx = 1:size(aFs,2) % + 1
        while 1 % run forever
            try
                GMM = gmdistribution.fit(MFCCsSet{sIdx}',observerSize,'SharedCov',true,'options',statset('maxiter',500));
                break;
            catch ex
                ex
            end
        end
        GMMSet = [GMMSet {GMM}];
    end
    save([workingDir 'WS_CLUSTER']);
    timeGMM = toc
    'GMM'
    tic
    for sIdx = 1:size(aFs,2)
        MODEL = [];
        for sp = 1:wordCount
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
        
        for sp = 1:wordCount
            for idx = 1:fileCountPerWord
                % Read speech samples, sampling rate and precision from file
                load(['F:\IFEFSR\Output\sampling' num2str(floor(aFs(sIdx)/1000)) ...
                    'k_trainfs' num2str(eFs(sIdx)) 'dstep1\' num2str((sp-1)*10+idx)]);
                signal = fractalDecode(f,aFs(sIdx),eFs(sIdx),1,dFs,[],[]);
                % Feature extraction (feature vectors as columns)
                [ MFCCs ] = ...
                    mfcc( signal, dFs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                MFCCs = MFCCs(2:end,:);
                seq = cluster(GMM,MFCCs');
                
                %% hmm training
                ESTTR = MODEL{sp}{1};
                ESTEMIT = MODEL{sp}{2};
                %     ESTEMIT = pdf(GMM,MFCCs);
                pseudoEmit = ESTEMIT;
                pseudoTr = ESTTR;
                [ESTTR,ESTEMIT] = hmmtrain(seq',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
                %     [ESTTR,ESTEMIT] = mybaumwelchtrain(MFCCs,ESTTR,logEmit,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
                MODEL{sp} = [{ESTTR},{ESTEMIT}];
            end
        end
        MODELSet = [MODELSet {MODEL}];
    end
    timeHMM = toc
    'HMM'
    time = timeReadSpeech + timeGMM + timeHMM
    save([workingDir 'WS_HMM']);
    save([workingDir 'MODELSet'],'MODELSet');
    save([workingDir 'GMMSet'],'GMMSet');
    
end


