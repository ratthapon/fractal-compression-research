clc; clear all; close all;
vary_HF = 5000;
vary_M = [25];
var_DATASET = [{'_NECTEC_MR'}];
mfccparams; % load mfcc params
bandparams;
EXP_RESULTS = [];
for vHFIdx = 1:size(vary_HF,2)
    for vMIdx = 1:size(vary_M,2)
        for vDSIdx = 1%:size(var_DATASET)
            
            HF = vary_HF(vHFIdx);
            M = vary_M(vMIdx);
            
            DATA_SET = ['k' var_DATASET{vDSIdx}];
            launcher_tactic0_trainer;
            launcher_tactic0_tester;
            nResults = size(RESULTS,1);
            EXP_RESULTS = [EXP_RESULTS; ...
                repmat({'BASE'},nResults,1),...
                num2cell(RESULTS), ...
                repmat(var_DATASET(vDSIdx),nResults,1),...
                repmat({MFCC_PARAMS_STR},nResults,1)];
            
            DATA_SET = [var_DATASET{vDSIdx} '_4_128_INT_Thesh1E-4AA2'];
            launcher_tactic3_trainer;
            launcher_tactic3_tester;
            nResults = size(RESULTS,1);
            EXP_RESULTS = [EXP_RESULTS; ...
                repmat({'FC'},nResults,1),...
                num2cell(RESULTS), ...
                repmat(var_DATASET(vDSIdx),nResults,1),...
                repmat({MFCC_PARAMS_STR},nResults,1)];
            close all;
        end
    end
end
save('F:\IFEFSR\Recognition analysis\TEST_GMM','EXP_RESULTS');