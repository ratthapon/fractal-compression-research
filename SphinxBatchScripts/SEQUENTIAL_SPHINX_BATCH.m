%% mod sphinx(s) full batch
% sequential runner
%   - feat extractor config
%   - feat extractor
%   - asr trainner config
%   - asr trainner 

clc; clear all; close all;
% load params
FEAT_PARAMS;

% configs paths
featCFG = 'F:\IFEFSR\ExpSphinx\sphinx_train_2.cfg';
trainingCFG = 'F:\IFEFSR\ExpSphinx\sphinx_train.cfg';

% selected extractor
featExtractor = 'Sphinx5Feat';

% experiments root directory
outPrefix = 'F:/IFEFSR/ExpSphinx/';

% wave files location
trainDir = ['F:/IFEFSR/ExpSphinx/FC1616_LOWPASS_001/wav'];
subDir = ['F:/IFEFSR/ExpSphinx/FC816_LOWPASS_001/wav'];

t = tic;
for ds = 1:2
    dataSet = DATASETs{ds};
    for alpha = ALPHAs
        for C = Cs
            for M = Ms
                for a = As
                    for HF = HFs
                        %% make directory
                        if (C==30), expCase = 'caseA' ; elseif (C==13), expCase = 'caseB'; end;
                        if (a==1), dataCase = 'origin' ; elseif (a==2), dataCase = 'cross'; end;
                        alphaStr = num2str(alpha*100);
                        
                        SEQUENTIAL_SPHINX;
                        
                        fxxxxx = 1;
                    end
                end
            end
        end
    end
end
time = toc(t);




