% hmm tester

clear all; close all; clc;

%%
% Define variables
dir = 'F:\IFEFSR\SpeechData\TestDAT\';
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)
directory = 'C:\Project\IFEFSR\MData\';
rate = [];
tic
for model_samp_rate = [11 22 44]
    clear MODEL GMM mappingSheet;
    load([directory 'MODEL' num2str(model_samp_rate)]);
    load([directory 'GMM' num2str(model_samp_rate)]);
    load([directory 'mappingSheet' num2str(model_samp_rate)]);
    
    for test_samp_rate = [11 22 44]
        output = [];
        wordCount = 18;
        solutionSheet = [];
        count = 0;
        
        for sp = 1:wordCount
            sp
            for spn=1:20
                count = count+1;
                solutionSheet(count) = sp;
                wav_file = [dir num2str(test_samp_rate) 'k_speaker_1_sp_' num2str(sp) '-' sprintf('%02d',spn) '.wav'];  % input audio filename
                % Read speech samples, sampling rate and precision from file
                [ speech, fs ] = audioread( wav_file );
                [ MFCCs, FBEs, frames ] = ...
                    mfcc( speech, fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                MFCCs = MFCCs(2:end,:);
                seq = cluster(GMM,MFCCs');
                
                outputEachSpeech = [];
                for m = 1:size(MODEL,2)
                    model = MODEL{m}; % gmdistribution.fit(MFCCs',observerSize);
                    ESTTR = model{1};
                    ESTEMIT = model{2};
                    % STATES = hmmviterbi(seq',ESTTR,ESTEMIT)
                    m
                    [PSTATES, LOGPSEQ] = hmmviterbi(seq',ESTTR,ESTEMIT);
                    % equivalence viteribi
                    % [PSTATES, LOGPSEQ] = hmmdecode(seq',ESTTR,ESTEMIT);
                    outputEachSpeech = [outputEachSpeech;LOGPSEQ];
                end
                output = [output outputEachSpeech];
            end
        end
        [maxVal resultIdx] = max(output);
        rate = [rate sum(resultIdx==solutionSheet)/count];
        result = zeros(wordCount,wordCount);
        for i=1:wordCount
            for j = 1:10
                idx=(i-1)*10+j;
                result(mappingSheet(idx),resultIdx(idx)) = result(mappingSheet(idx),resultIdx(idx)) + 1;
            end
        end
    end
end
rate = vec2mat(rate',3);
classtime = toc