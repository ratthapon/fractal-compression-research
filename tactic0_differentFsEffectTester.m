clear all; close all; clc;

%% load data model
dataDir = 'F:\IFEFSR\MData\tactic0_differentFsEffect_MFCCWithoutDCT_rawResampling\';
load([dataDir 'MODELSet']);
load([dataDir 'GMMSet']);
%% Define variables
% MFCC parameters
Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 12;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 10;               % lower frequency limit (Hz)
HF = 6000;              % upper frequency limit (Hz)

%% audio parameter
rFPS = [11025 22050 44100]; % resampling rate to frame per second
bFPS = [11025 22050 44100]; % base sampling rate frame per second
set = [{'test'}];
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
ivs = 1 * size(bFPS,2);
% dependent variable size
dvs = size(rFPS,2) * size(set,2);
results = zeros(ivs,dvs); % alloc result buffer
testTimes = zeros(ivs,dvs);

%% test model
% each base Fs code
for bIdx = 1
    % for each trained model
    for rIdx = 1:size(bFPS,2)
        %% load test model
        MODELS = MODELSet{bIdx,rIdx};
        GMMS = GMMSet{bIdx,rIdx};
        
        % each samples set
        for sIdx = 1:size(set,2)
            %% each test decode set
            for tIdx = 1:size(rFPS,2)
                tic;
                % locate files list
                filesList = importdata(['F:\IFEFSR\' num2str(floor(rFPS(tIdx)/1000)) ...
                    'k_' set{sIdx} '_rawResampling.txt']);
                % alloc output log sequence probability buffer
                LOGPSEQBuffer = zeros(wordCount,nSample);
                % locate output dir
%                 plotDir = [dataDir 'signal_' set{sIdx} '_' num2str(rFPS(tIdx)) 'k\'];
%                 mkdir(plotDir);
%                 mfccDir = [dataDir 'MFCCs_' set{sIdx} '_' num2str(rFPS(tIdx)) 'k\'];
%                 mkdir(mfccDir);
                
                for fIdx = 1:nSample
                    %% load audio data and resample
                    signal = audioread(filesList{fIdx});
                    signal = (signal - mean(signal)) / std(signal);
                    %% Feature extraction (feature vectors as columns)
                    [ MFCCs ] = mfcc( signal, rFPS(tIdx),...
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
                ivIdx = rIdx + (size(bFPS,2)*(bIdx-1)); % independent var index
                dvIdx = tIdx + (size(rFPS,2)*(sIdx-1)); % dependent var index
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