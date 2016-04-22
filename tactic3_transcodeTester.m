% clear all; close all; clc;

%% load data model
stateSize = 31; % default
observerSize = 90;
dataDir = ['F:\IFEFSR\MData\tactic3_transcode_MFCCWithoutDCT_rawResampling_' ...
    num2str(stateSize) 's' ...
    num2str(observerSize) 'k' '\'];
load([dataDir 'MODELSet']);
load([dataDir 'GMMSet']);

%% Define variables
% MFCC parameters
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 12;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 12;                 % cepstral sine lifter parameter
LF = 10;               % lower frequency limit (Hz)
HF = 5000;              % upper frequency limit (Hz)

%% fractal code parameter
dFPS = [11025 22050 44100]; % decode to frame per second
dFPC = [16 32 64]; % code parameter, frame per code
cFPS = [11025 22050 44100]; % stored code, frame per second
cFPC = [16 32 64];
set = [{'test'}];

%% HMM GMM parameters
wordCount = 18;
fileCountPerWord = 10;
nSample = wordCount * fileCountPerWord;

% create result correction
resultLabel = zeros(1,nSample);
for wIdx=1:18 % each word class
    for spIdx = 1:10 % each speech sample in class
        resultLabel((wIdx-1)*10+spIdx) = wIdx;
    end
end

%% acc result
% independent variable size
ivs = 1 * size(cFPS,2);
% dependent variable size
dvs = size(dFPS,2) * size(set,2);
results = zeros(ivs,dvs); % alloc result buffer
testTimes = zeros(ivs,dvs);

%% test model
% for each stored code
for cIdx = 1:size(cFPS,2)
    % for each trained model
    for dIdx = cIdx %1:size(dFPS,2)
        %% load test model
        MODELS = MODELSet{cIdx,dIdx};
        GMMS = GMMSet{cIdx,dIdx};
        
        % each samples set
        for sIdx = 1:size(set,2)
            %% each test decode set
            for tIdx = 1:size(cFPS,2)
                tic;
                %% locate code directory
                codeFileList = importdata(['F:\IFEFSR\' ...
                    num2str(floor(cFPS(tIdx)/1000)) ...
                    'k_' set{sIdx} '_rawResampling_fs' ...
                    num2str(cFPC(tIdx)) '_code.txt']);
                % alloc output log sequence probability buffer
                LOGPSEQBuffer = zeros(wordCount,nSample);
                % locate output dir
                %                 plotDir = [dataDir 'signal_' set{sIdx} '_code' ...
                %                     num2str(cFPS(tIdx)) 'kFs'...
                %                     num2str(cFPC(tIdx)) '_decodeTo' num2str(dFPS(dIdx)) 'k\'];
                %                 mkdir(plotDir);
                %                 mfccDir = [dataDir 'MFCCs_' set{sIdx} '_code' ...
                %                     num2str(cFPS(tIdx)) 'kFs'...
                %                     num2str(cFPC(tIdx)) '_decodeTo' num2str(dFPS(dIdx)) 'k\'];
                %                 mkdir(mfccDir);
                %
                for fIdx = 1:nSample
                    %% load code and reconstruct signal
                    load(codeFileList{fIdx}); % get f
                    signal = fractalDecode(f,cFPS(tIdx),cFPC(tIdx),1,cFPS(tIdx),[],[]);
                    signal = ((signal - mean(signal)) / std(signal));
                    signal = signal / norm(signal);
                    signal = signal * 0.15;
                    signal = cmddenoise(signal,denoiseMethod,denoiseLevel);
                    clear f;
                    
                    %% Feature extraction (feature vectors as columns)
                    [ MFCCs ] = mfcc( signal, cFPS(tIdx),...
                        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                    %                     MFCCs = MFCCs(2:end,:);
                    %                     figure('Visible','off');
                    %                     plot(signal);
                    %                     saveas(gcf,[plotDir num2str(fIdx) '.jpg'],'jpg');
                    %                     figure('Visible','off');
                    %                     imagesc(MFCCs);
                    %                     colormap gray;
                    %                     saveas(gcf,[mfccDir num2str(fIdx) '.jpg'],'jpg');
                    %                     close all;
                    %% map features sequence to speech sequence
                    seq = cluster(GMMS,MFCCs');
                    
                    %% test sample by each model
                    for mIdx = 1:size(MODELS,2)
                        model = MODELS{mIdx}; % point to model
                        ESTTR = model{1};
                        ESTEMIT = model{2};
                        % find probability of single sequence
                        [~,LOGPSEQ] = hmmviterbi(seq',ESTTR,ESTEMIT);
                        LOGPSEQBuffer(mIdx,fIdx) = LOGPSEQ;
                    end
                end
                %% find max probability of sequences
                [~,outClass] = max(LOGPSEQBuffer);
                %% calculate accuracy rate
                accRate = sum(outClass == resultLabel)/size(outClass,2);
                %% store result in results buffer
                ivIdx = cIdx;% + (size(dFPS,2)*(cIdx-1)); % independent var index
                dvIdx = tIdx + (size(cFPS,2)*(sIdx-1)); % dependent var index
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