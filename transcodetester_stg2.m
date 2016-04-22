
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
dFs = 16000; % decode to sampling rate
eFs = [8 16 32];
aFs = [11025 22050 44100];%11025 22050 44100 audio Fs or sampling rate
stateSize = 5; % default
observerSize = 192;
AllResultsSTG2 = [];
% test params
for dFs = dFsSet
    workingDir = ['F:\IFEFSR\MData\stg2_transcode_to' num2str(floor(dFs/1000)) ...
        'k_' num2str(observerSize) 'Component' num2str(stateSize) 'StatesDiscrete\'];
    mkdir(workingDir);
    wordCount = 18;
    fileCountPerWord = 10;
    load([workingDir 'MODELSet']);
    load([workingDir 'GMMSet']);
    setName = [{'Train'} {'Test'}];
    results = zeros(size(aFs,2),size(aFs,2)*2);
    tic
    for setIdx = 1:2
        for trainSetIdx = 1:size(aFs,2)
            for testSetIdx = 1:size(aFs,2)
                load(['F:\IFEFSR\MData\' num2str(floor(aFs(testSetIdx)/1000)) ...
                    'k_frames_fractal_' num2str(eFs(testSetIdx)) 'fs\' ...
                    setName{setIdx} 'FFCDatas']);
                MODEL = MODELSet{trainSetIdx};
                GMM = GMMSet{trainSetIdx};
                outputLog = [];
                for idx = 1:wordCount*10
                    % Read speech samples, sampling rate and precision from file
                    codes = FFCDatas{idx}(1,:);
                    frames = [];
                    for i = 1:size(codes,2)
                        signal = fractalDecode(codes{i},aFs(testSetIdx),eFs(testSetIdx),1,dFs,[],[]);
                        frames = [frames signal];
                    end
                    % Feature extraction (feature vectors as columns)
                    [ MFCCs, FBEs, frames ] = ...
                        frames_mfcc( frames, dFs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
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
    AllResultsSTG2 = [AllResultsSTG2 ; results];
end
save('F:\IFEFSR\MData\ALLResultSTG2','AllResultsSTG2');