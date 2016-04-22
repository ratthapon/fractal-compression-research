
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
dFsSet = [11025 22050 44100];
dFs = 22000; % decode to sampling rate
eFs = [8 16 32];
aFs = [11025 22050 44100];%11025 22050 44100 audio Fs or sampling rate
stateSize = 5; % default
observerSize = 192;
wordCount = 18;
fileCountPerWord = 10;
AllResultsSTG4 = [];
setName = [{'train'} {'test'}];
for dFsIDx = size(dFsSet,2)
    dFs = dFsSet(dFsIDx);
    workingDir = ['F:\IFEFSR\MData\stg4_transcode_to' num2str(floor(dFs/1000)) ...
        'k_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
    mkdir(workingDir);
    load([workingDir 'MODELSet']);
    load([workingDir 'GMMSet']);
    results = zeros(size(aFs,2),size(aFs,2)*2);
    % test params
    tic
    for setIdx = 1:2
        for trainSetIdx = 1:size(aFs,2)
            for testSetIdx = 1:size(aFs,2)
                MODEL = MODELSet{trainSetIdx};
                GMM = GMMSet{trainSetIdx};
                outputLog = [];
                for idx = 1:wordCount*10
                    % Read speech samples, sampling rate and precision from file
                    load(['F:\IFEFSR\Output\sampling' num2str(floor(aFs(testSetIdx)/1000)) ...
                        'k_' setName{setIdx} 'fs' num2str(eFs(testSetIdx)) 'dstep1\' num2str(idx)]);
                    signal = fractalDecode(f,aFs(testSetIdx),eFs(testSetIdx),1,dFs,[],[]);
                    % Feature extraction (feature vectors as columns)
                    [ MFCCs ] = ...
                        mfcc( signal, dFs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                    MFCCs = MFCCs(2:end,:);
                    seq = cluster(GMM,MFCCs');
                    
                    logEachSpeech = [];
                    for m = 1:size(MODEL,2)
                        model = MODEL{m}; % gmdistribution.fit(MFCCs',observerSize);
                        ESTTR = model{1};
                        ESTEMIT = model{2};
                        [PSTATES,LOGPSEQ] = hmmviterbi(seq',ESTTR,ESTEMIT);
                        % equivalence viteribi
                        % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
                        logEachSpeech = [logEachSpeech;LOGPSEQ];
                    end
                    outputLog = [outputLog logEachSpeech];
                end
                [maxVal,resultIdx] = max(outputLog);
                listClassLabel = [];
                for i=1:18
                    for j = 1:10
                        listClassLabel((i-1)*10+j) = i;
                    end
                end
                rate = sum(resultIdx==listClassLabel)/size(resultIdx,2);
                results(trainSetIdx,testSetIdx+(3*(setIdx-1))) = rate;
            end
        end
    end
    time = toc
    save([workingDir 'TestWS']);
    AllResultsSTG4 = [AllResultsSTG4 ; results];
end
save('F:\IFEFSR\MData\ALLResultSTG4','AllResultsSTG4');