%% sphinx train cfg batch
FEAT_PARAMS;
globalCFG = 'F:\IFEFSR\ExpSphinx\sphinx_train.cfg';
featExtractor = 'Sphinx5Feat';
outPrefix = 'F:/IFEFSR/ExpSphinx/';
trainDir = ['F:\IFEFSR\ExpSphinx\FC1616_LOWPASS_001\wav'];
subDir = ['F:\IFEFSR\ExpSphinx\FC816_LOWPASS_001\wav'];

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
                        
                        SPHINX_TRAIN_CFG;
                    end
                end
            end
        end
    end
end
time = toc(t);




