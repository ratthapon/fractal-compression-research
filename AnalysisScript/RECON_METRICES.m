%% missclassificaiton analysis for sphinx corpus
% mfccparams;
% 
% fileList  = importdata('F:\IFEFSR\ExpSphinx\etc\an4_test.fileids'); % test file list
% originDir = 'F:\IFEFSR\ExpSphinx\FC816_LOWPASS_001\';
% testDir = 'F:\IFEFSR\ExpSphinx\FC1616_LOWPASS_001\';
% clusterDir = 'misscluster';
% workingDir = ['F:\IFEFSR\ExpSphinx\caseA\Sphinx5Feat\cross\FC\A95\an4\'];

%% matrices extract
psnrValues = [];
specCorr = [];
fbeCorr = [];
mfccCorr = [];
framesSpecCorr = [];
framesFbeCorr = [];
framesMfccCorr = [];

for i = 1:size(fileList, 1)
    i
    sigOri = rawread([originDir 'wav\' fileList{i} '.raw']);
    sigRec = rawread([testDir 'wav\' fileList{i} '.raw']);
    
    [ psnrV, sc, fc, mc, fsc, ffc, fmc] = measure( sigOri, sigRec );
    
    psnrValues = [psnrValues sc];
    
    specCorr = [specCorr sc];
    fbeCorr = [fbeCorr fc];
    mfccCorr = [mfccCorr mc];
    
    framesSpecCorr = [framesSpecCorr fsc];
    framesFbeCorr = [framesFbeCorr ffc];
    framesMfccCorr = [framesMfccCorr fmc];
    
end
csvwrite([workingDir 'corr.csv'], [specCorr' fbeCorr' mfccCorr']);
csvwrite([workingDir 'corr_each_frame.csv'], [framesSpecCorr' framesFbeCorr' framesMfccCorr']);
csvwrite([workingDir 'psnr.csv'], psnrValues');


