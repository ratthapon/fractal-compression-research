
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
HF = 3000;              % upper frequency limit (Hz)
dFsSet = [ 11025 22050 44100];
eFs = [4 16 32];
aFs = [11025 22050 44100];%11025 22050 44100 audio Fs or sampling rate
stateSize = 5; % default
observerSize = 192;
wordCount = 18;
fileCountPerWord = 10;
nSample = wordCount * fileCountPerWord;
AllResultTactic3 = [];
setName = [{'train'} {'test'}];
dataDir = 'F:\IFEFSR\MData\tactic3_transcode\';
load([dataDir 'MODELSet']);
load([dataDir 'GMMSet']);
% create result correction
listClassLabel = zeros(1,nSample);
for i=1:18
    for j = 1:10
        listClassLabel((i-1)*10+j) = i;
    end
end

for dFsIDx = 1:size(dFsSet,2)
    dFs = dFsSet(dFsIDx);
    % test params
    tic
    
    for trainSetIdx = 1:size(dFsSet,2)
        for setIdx = 1:2
            for testSetIdx = 1:size(aFs,2)
                ['test' num2str(aFs(testSetIdx)/1000) 'k' setName{setIdx} ' with ' ...
                    num2str(floor(dFsSet(trainSetIdx)/1000)) 'k de to' num2str(floor(dFs/1000)) 'k']
            end
        end
        time = toc
    end
end