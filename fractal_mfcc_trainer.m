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
observerSize = 128;
wordCount = 18;
eFs = [8 16 32];
aFs = [11025 22050 44100];%11025 22050 44100 audio Fs or sampling rate

for sIdx = 1:size(aFs,2)
    workingDir = ['F:\IFEFSR\MData\' num2str(floor(aFs(sIdx)/1000)) 'k_fractal_' num2str(eFs(sIdx)) ...
        'fs1_mfcc_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
    mkdir(workingDir);
    catS = [];
    catO = [];
    catD = [];
    catA = [];
    tic
    for fIdx = 1:180
        % Read speech samples, sampling rate and precision from file
        load(['F:\IFEFSR\Output\sampling' num2str(floor(aFs(sIdx)/1000)) ...
            'k_trainfs' num2str(eFs(sIdx)) 'dstep1\' num2str(fIdx)]);
        s = f(:,1)';
        o = f(:,2)';
        dIdx = f(:,3)';
        fs = aFs / eFs;
        % Feature extraction (feature vectors as columns)
        [ MFCCs, FBEs, frames ] = ...
            mfcc_nofilter( s, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        MFCCs = MFCCs(2:end,:);
        catS = [catS MFCCs];
        
        [ MFCCs, FBEs, frames ] = ...
            mfcc_nofilter( o, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        MFCCs = MFCCs(2:end,:);
        catO = [catO MFCCs];
        
        [ MFCCs, FBEs, frames ] = ...
            mfcc_nofilter( dIdx, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        MFCCs = MFCCs(2:end,:);
        catD = [catD MFCCs];
        
        x = [s;o;dIdx];
        allZM = (x - (ones(size(x,1),1)*mean(x)))./(ones(size(x,1),1)*std(x));
        allZM = allZM(:)';
        [ MFCCs, FBEs, frames ] = ...
            mfcc_nofilter( allZM, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        MFCCs = MFCCs(2:end,:);
        catA = [catA MFCCs];
    end
    %observerPerSpeech*wordCount +1;
    save finishFE1
    timeReadSpeech = toc
    'FE'
    % cluster and label feature frames
    tic
    while 1
        try
            GMMs = gmdistribution.fit(catS',observerSize,'SharedCov',true,'options',statset('maxiter',500));
            break;
        catch ex
        end
    end
    while 1
        try
            GMMo = gmdistribution.fit(catO',observerSize,'SharedCov',true,'options',statset('maxiter',500));
            break;
        catch ex
        end
    end
    while 1
        try
            GMMd = gmdistribution.fit(catD',observerSize,'SharedCov',true,'options',statset('maxiter',500));
            break;
        catch ex
        end
    end
    while 1
        try
            GMMa = gmdistribution.fit(catA',observerSize,'SharedCov',true,'options',statset('maxiter',500));
            break;
        catch ex
        end
    end
    save([workingDir 'WSFinishGMM']);
    timeGMM = toc
    'GMM'
    tic
    for sp = 1:18
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
    
    for sp = 1:18
        for idx = 1:10
            load(['F:\IFEFSR\Output\sampling' num2str(floor(aFs(sIdx)/1000)) ...
                'k_trainfs' num2str(eFs(sIdx)) 'dstep1\' num2str((sp-1)*10+idx)]);
            
            s = f(:,1)';
            o = f(:,2)';
            dIdx = f(:,3)';
            x = [s;o;dIdx];
            allZM = (x - (ones(size(x,1),1)*mean(x)))./(ones(size(x,1),1)*std(x));
            allZM = allZM(:)';
            fs = aFs / eFs;
            % Feature extraction (feature vectors as columns)
            [ MFCCs, FBEs, frames ] = ...
                mfcc_nofilter( s, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            seqS = cluster(GMMs,MFCCs');
            [ MFCCs, FBEs, frames ] = ...
                mfcc_nofilter( o, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            seqO = cluster(GMMo,MFCCs');
            [ MFCCs, FBEs, frames ] = ...
                mfcc_nofilter( dIdx, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            seqD = cluster(GMMd,MFCCs');
            [ MFCCs, FBEs, frames ] = ...
                mfcc_nofilter( allZM, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            MFCCs = MFCCs(2:end,:);
            seqA = cluster(GMMa,MFCCs');
            
            %% hmm training
            ESTTR = MODEL{sp}{1};
            ESTEMIT = MODEL{sp}{2};
            %     ESTEMIT = pdf(GMM,MFCCs);
            pseudoEmit = ESTEMIT;
            pseudoTr = ESTTR;
            [ESTTR,ESTEMIT] = hmmtrain(seqS',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            %     [ESTTR,ESTEMIT] = mybaumwelchtrain(MFCCs,ESTTR,logEmit,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            MODELs{sp} = [{ESTTR},{ESTEMIT}];
            
            %% hmm training
            ESTTR = MODEL{sp}{1};
            ESTEMIT = MODEL{sp}{2};
            %     ESTEMIT = pdf(GMM,MFCCs);
            pseudoEmit = ESTEMIT;
            pseudoTr = ESTTR;
            [ESTTR,ESTEMIT] = hmmtrain(seqO',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            %     [ESTTR,ESTEMIT] = mybaumwelchtrain(MFCCs,ESTTR,logEmit,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            MODELo{sp} = [{ESTTR},{ESTEMIT}];
            
            %% hmm training
            ESTTR = MODEL{sp}{1};
            ESTEMIT = MODEL{sp}{2};
            %     ESTEMIT = pdf(GMM,MFCCs);
            pseudoEmit = ESTEMIT;
            pseudoTr = ESTTR;
            [ESTTR,ESTEMIT] = hmmtrain(seqD',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            %     [ESTTR,ESTEMIT] = mybaumwelchtrain(MFCCs,ESTTR,logEmit,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            MODELd{sp} = [{ESTTR},{ESTEMIT}];
            
            %% hmm training
            ESTTR = MODEL{sp}{1};
            ESTEMIT = MODEL{sp}{2};
            %     ESTEMIT = pdf(GMM,MFCCs);
            pseudoEmit = ESTEMIT;
            pseudoTr = ESTTR;
            [ESTTR,ESTEMIT] = hmmtrain(seqA',ESTTR,ESTEMIT,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            %     [ESTTR,ESTEMIT] = mybaumwelchtrain(MFCCs,ESTTR,logEmit,'algorithm','viterbi','PSEUDOTRANSITIONS',pseudoTr,'PSEUDOEMISSIONS',pseudoEmit);
            MODELa{sp} = [{ESTTR},{ESTEMIT}];
        end
    end
    timeHMM = toc
    'HMM'
    time = timeReadSpeech + timeGMM + timeHMM
    save([workingDir 'WSFinishHMM']);
    save([workingDir 'GMMs'],'GMMs');
    save([workingDir 'GMMo'],'GMMo');
    save([workingDir 'GMMd'],'GMMd');
    save([workingDir 'GMMa'],'GMMa');
    save([workingDir 'MODELs'],'MODELs');
    save([workingDir 'MODELo'],'MODELo');
    save([workingDir 'MODELd'],'MODELd');
    save([workingDir 'MODELa'],'MODELa');
end



