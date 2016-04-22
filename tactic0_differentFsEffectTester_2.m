clear all; close all; clc;

%% load data model
dataDir = 'F:\IFEFSR\MData\tactic0_differentFsEffect_MFCCWithoutDCT_rawResampling\';
load([dataDir 'MODELSet']);
load([dataDir 'GMMSet']);
%% Define variables
% MFCC parameters
mfccparams; % load mfcc params

%% audio parameter
rFPS = [8000 16000 32000]; % resampling rate to frame per second
bFPS = [8000 16000 32000]; % base sampling rate frame per second
wordCount = 67;
fileCountPerWord = 1;
speakers = [1 2 3 4 5 6  8 9 10 11 12]; % from 7 feamale and 5 male
testFileIdx = [];
for i = speakers
    testFileIdx = [testFileIdx (i-1)*wordCount+1:i*wordCount];
end
nTest = size(testFileIdx,2);

% create result correction
resultLabel = zeros(1,nTest);
for spIdx=1:size(speakers,2) % each word class
    for wIdx = 1:wordCount % each speech sample in class
        resultLabel((spIdx-1)*wordCount+wIdx) = wIdx;
    end
end

%% acc result
% independent variable size
ivs = 1 * size(bFPS,2);
% dependent variable size
dvs = size(rFPS,2);
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
        for sIdx = 1
            %% each test decode set
            for tIdx = 1:size(rFPS,2)
                tic;
                % locate files list
                filesList = importdata(['F:\IFEFSR\' num2str(floor(rFPS(rIdx)/1000)) ...
            'k_NECTEC_matlabResampling.txt']);
        
                % alloc output log sequence probability buffer
                LOGPSEQBuffer = zeros(wordCount,nTest);
                % locate output dir
%                 plotDir = [dataDir 'signal_' set{sIdx} '_' num2str(rFPS(tIdx)) 'k\'];
%                 mkdir(plotDir);
%                 mfccDir = [dataDir 'MFCCs_' set{sIdx} '_' num2str(rFPS(tIdx)) 'k\'];
%                 mkdir(mfccDir);
                
                for fIdx = 1:nTest
                    %% load audio data and resample
                    signal = audioread(filesList{fIdx});
%                     signal = (signal - mean(signal)) / std(signal);
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