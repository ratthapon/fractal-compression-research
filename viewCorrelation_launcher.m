mfccparams;
M = 12;                 % number of filterbank channels
LF = 130;               % lower frequency limit (Hz)
HF = 8500;              % upper frequency limit (Hz)
MAX_HF = 44100;
warning off

% original MFCC
isFractalCode = false;
filesList_low = importdata(['F:\IFEFSR\11'  ...
    'k_TRAIN_MR.txt']);
filesList_med = importdata(['F:\IFEFSR\22' ...
    'k_TRAIN_MR.txt']);
filesList_high = importdata(['F:\IFEFSR\44' ...
    'k_TRAIN_MR.txt']);
allAvgCorr = [];
for F0 = 4000:100:MAX_HF
    HF = F0;
    vectorsCorrelation = []; % zeros(size(filesList_low,1),4);
    matrixCorrelation = zeros(size(filesList_low,1),4);
    viewCorrelation_core;
    allAvgCorr = [allAvgCorr; avgCorrelation];
end
figure(1),plot(4000:100:MAX_HF,allAvgCorr,'o-');
title('Averagge Pearson correlation')
xlabel('Max filterbank frequency'),ylabel('Pearson Correlation')
legend('FBE M','FBE L','MFCC M','MFCC L')

% 
% %% fractal code MFCC
% isFractalCode = true;
% filesList_low = importdata(['F:\IFEFSR\11'  ...
%     'k_TRAIN_MR_Thesh1E-4_code.txt']);
% filesList_med = importdata(['F:\IFEFSR\22' ...
%     'k_TRAIN_MR_Thesh1E-4_code.txt']);
% filesList_high = importdata(['F:\IFEFSR\44' ...
%     'k_TRAIN_MR_Thesh1E-4_code.txt']);
% allAvgCorr = [];
% for F0 = 3000:200:8000
%     HF = F0;
%     vectorsCorrelation = []; % zeros(size(filesList_low,1),4);
%     matrixCorrelation = zeros(size(filesList_low,1),4);
%     viewCorrelation_core;
%     allAvgCorr = [allAvgCorr; avgCorrelation];
% end
% figure(1),plot(3000:200:8000,allAvgCorr,'o-');
% title('Averagge Pearson correlation')
% xlabel('Max filterbank frequency'),ylabel('Pearson Correlation')
% legend('FBE M','FBE L','MFCC M','MFCC L')
