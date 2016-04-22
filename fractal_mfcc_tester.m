
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
rate = [];
stateSize = 5; % default
observerSize = 128;
eFs = [8 16 32];
aFs = [11025 22050 44100];%11025 22050 44100 audio Fs or sampling rate
AllResultsSTG1 = [];
for sIdx = 1:size(aFs,2)
    outputLogS = [];
    
    outputLogO = [];
    outputLogD = [];
    outputLogA = [];
    workingDir = ['F:\IFEFSR\MData\' num2str(floor(aFs/1000)) 'k_fractal_' num2str(eFs) ...
        'fs1_mfcc_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
    mkdir(workingDir);
    load([workingDir 'MODELs']);
    load([workingDir 'MODELo']);
    load([workingDir 'MODELd']);
    load([workingDir 'MODELa']);
    load([workingDir 'GMMs']);
    load([workingDir 'GMMo']);
    load([workingDir 'GMMd']);
    load([workingDir 'GMMa']);
    setName = [{'train'} {'test'}];
    results = zeros(1,size(aFs,2)*2);
    for setIdx = 1:2
        
        tic
        for idx = 1:180
            % Read speech samples, sampling rate and precision from file
            load(['F:\IFEFSR\Output\sampling' num2str(floor(aFs(sIdx)/1000)) ...
                'k_' setName{setIdx} 'fs' num2str(eFs(sIdx)) 'dstep1\' num2str(idx)]);
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
            
            logEachSpeechS = [];
            logEachSpeechO = [];
            logEachSpeechD = [];
            logEachSpeechA = [];
            
            for m = 1:size(MODELs,2)
                model = MODELs{m}; % gmdistribution.fit(MFCCs',observerSize);
                ESTTR = model{1};
                ESTEMIT = model{2};
                [PSTATES,LOGPSEQ] = hmmviterbi(seqS',ESTTR,ESTEMIT);
                % equivalence viteribi
                % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
                logEachSpeechS = [logEachSpeechS;LOGPSEQ];
                
                model = MODELo{m}; % gmdistribution.fit(MFCCs',observerSize);
                ESTTR = model{1};
                ESTEMIT = model{2};
                [PSTATES,LOGPSEQ] = hmmviterbi(seqO',ESTTR,ESTEMIT);
                % equivalence viteribi
                % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
                logEachSpeechO = [logEachSpeechO;LOGPSEQ];
                
                model = MODELd{m}; % gmdistribution.fit(MFCCs',observerSize);
                ESTTR = model{1};
                ESTEMIT = model{2};
                [PSTATES,LOGPSEQ] = hmmviterbi(seqD',ESTTR,ESTEMIT);
                % equivalence viteribi
                % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
                logEachSpeechD = [logEachSpeechD;LOGPSEQ];
                
                model = MODELa{m}; % gmdistribution.fit(MFCCs',observerSize);
                ESTTR = model{1};
                ESTEMIT = model{2};
                [PSTATES,LOGPSEQ] = hmmviterbi(seqA',ESTTR,ESTEMIT);
                % equivalence viteribi
                % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
                logEachSpeechA = [logEachSpeechA;LOGPSEQ];
            end
            outputLogS = [outputLogS logEachSpeechS];
            outputLogO = [outputLogO logEachSpeechO];
            outputLogD = [outputLogD logEachSpeechD];
            outputLogA = [outputLogA logEachSpeechA];
        end
        [maxVal resultIdxS] = max(outputLogS);
        [maxVal resultIdxO] = max(outputLogO);
        [maxVal resultIdxD] = max(outputLogD);
        [maxVal resultIdxA] = max(outputLogA);
        listClassLabel = [];
        for i=1:18
            for j = 1:10
                listClassLabel((i-1)*10+j) = i;
            end
        end
        rateS = [sum(resultIdxS==listClassLabel)/size(resultIdxS,2)];
        rateO = [sum(resultIdxO==listClassLabel)/size(resultIdxO,2)];
        rateD = [sum(resultIdxD==listClassLabel)/size(resultIdxD,2)];
        rateA = [sum(resultIdxA==listClassLabel)/size(resultIdxA,2)];
        rate = [rateS rateO rateD rateA];
        % result = zeros(wordCount,wordCount);
        % for i=1:wordCount
        %     for j = 1:10
        %         idx=(i-1)*10+j;
        %         result(listClassLabel(idx),resultIdx(idx)) = result(listClassLabel(idx),resultIdx(idx)) + 1;
        %     end
        % end
        time = toc
        save([workingDir 'TestWS']);
        results = [results rate];
        
    end
    AllResultsSTG1 = [AllResultsSTG1 ; results];
    save('F:\IFEFSR\MData\AllResultsSTG1','AllResultsSTG1');
end
