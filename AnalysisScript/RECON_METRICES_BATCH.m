%% sphinx train cfg batch
FEAT_PARAMS;

fileList  = importdata('F:\IFEFSR\ExpSphinx\etc\an4_test.fileids'); % test file list
originDir = 'F:\IFEFSR\ExpSphinx\FC816_LOWPASS_001\';
testDir = 'F:\IFEFSR\ExpSphinx\FC1616_LOWPASS_001\';
featExtractor = 'Sphinx5Feat';

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
                        
                        workingDir = ['F:/IFEFSR/ExpSphinx/' expCase '/'  ...
                            featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/'];
                        
                        RECON_METRICES;
                    end
                end
            end
        end
    end
end
time = toc(t);
