clear all; close all; clc;

%% Define variables
% MFCC parameters
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 12;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 12;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)

%% audio parameter
FPS = [11025 22050 44100]; % sampling rate to frame per second
FPC = [16 32 64]; % frame per code
set = [{'test'}];

%% HMM GMM parameters
stateSize = 31; % default
observerSize = 90;
wordCount = 18;
fileCountPerWord = 10;
nSample = wordCount * fileCountPerWord;
%% set workspace directoy
dataDir = ['F:\IFEFSR\MData\tactic3_transcode_MFCCWithoutDCT_rawResampling_' ...
    num2str(stateSize) 's' ...
    num2str(observerSize) 'k' '\'];
load([dataDir 'MODELSet']);
load([dataDir 'GMMSet']);
% create result correction
resultLabel = zeros(1,nSample);
for wIdx=1:18 % each word class
    for spIdx = 1:10 % each speech sample in class
        resultLabel((wIdx-1)*fileCountPerWord+spIdx) = wIdx;
    end
end

%% acc result
% independent variable size
ivs = size(FPS,2);
% dependent variable size
dvs = size(FPS,2) * size(set,2);
results = zeros(ivs,dvs); % alloc result buffer
testTimes = zeros(ivs,dvs);

%% test model
% each base Fs code
for cIdx = 3
    % for each trained model
    for mIdx = cIdx %1:size(bFPS,2)
        %% load test model
        MODELS = MODELSet{cIdx,mIdx};
        GMMS = GMMSet{cIdx,mIdx};
        
        % each samples set
        for setIdx = 1:size(set,2)
            %% each test decode set
            for tIdx = 1:size(FPS,2)
                tic;
                % locate files list
                filesList = importdata(['F:\IFEFSR\' num2str(floor(FPS(mIdx)/1000)) ...
                    'k_test_decoded_' num2str(floor(FPS(tIdx)/1000)) ...
                    'k_fs' num2str(FPC(tIdx)) '_rawResampling.txt']);
                % alloc output log sequence probability buffer
                LOGPSEQBuffer = zeros(wordCount,nSample);
                % locate output dir
                %                 plotDir = [dataDir 'signal_' set{sIdx} '_' num2str(rFPS(tIdx)) 'k\'];
                %                 mkdir(plotDir);
                %                 mfccDir = [dataDir 'MFCCs_' set{sIdx} '_' num2str(rFPS(tIdx)) 'k\'];
                %                 mkdir(mfccDir);
                
                for fIdx = 1:nSample
                    %% load audio data and resample
                    signal = audioread(filesList{tIdx});
                    %% Feature extraction (feature vectors as columns)
                    [ MFCCs ] = mfcc( signal, FPS(mIdx),...
                        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                    %                     MFCCs = MFCCs(2:end,:);
                    
                    %% map features sequence to speech sequence
                    seq = cluster(GMMS,MFCCs');
                    %                     figure('Visible','off');
                    %                     plot(signal);
                    %                     saveas(gcf,[plotDir num2str(fIdx) '.jpg'],'jpg');
                    %                     figure('Visible','off');
                    %                     imagesc(MFCCs);
                    %                     colormap gray;
                    %                     saveas(gcf,[mfccDir num2str(fIdx) '.jpg'],'jpg');
                    %                     close all;
                    %% test sample by each model
                    for sIdx = 1:size(MODELS,2)
                        model = MODELS{sIdx}; % point to model
                        ESTTR = model{1};
                        ESTEMIT = model{2};
                        % find probability of single sequence
                        [~,LOGPSEQ] = hmmviterbi(seq',ESTTR,ESTEMIT);
                        LOGPSEQBuffer(sIdx,fIdx) = LOGPSEQ;
                    end
                end
                %% find max probability of sequences
                [~,outClass] = max(LOGPSEQBuffer);
                %% calculate accuracy rate
                accRate = sum(outClass == resultLabel)/size(outClass,2);
                %% store result in results buffer
                ivIdx = cIdx; % independent var index
                dvIdx = tIdx; % dependent var index
                results(ivIdx,dvIdx) = accRate;
                
                %% timing
                time = toc;
                testTimes(ivIdx,dvIdx) = time;
                %% save current progress
                save([dataDir 'TestWS']);
                save([dataDir 'results'],'results');
                save([dataDir 'testTimes'],'testTimes');
            end
        end
    end
end
testProfiler = profile('info');
save([dataDir 'testProfiler'],'testProfiler');