function  MRBSSpecCMP()
%MRBSSPECCMP Summary of this function goes here
%   Detailed explanation goes here

[ Tw, Ts, preemAlpha, M, C, L, LF, HF ] = getMFCCSphinxParams();

%% original signal 8k
sigOrigin8 = rawread('F:\IFEFSR\SpeechData\an4_8k\wav\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataOrigin8, FBEOrigin8, specOrigin8] = mfcc( sigOrigin8, 8000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );
specOrigin8 = [specOrigin8; zeros(size(specOrigin8))];

%% original signal 16k
sigOrigin16 = rawread('F:\IFEFSR\SpeechData\an4\wav\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataOrigin16, FBEOrigin16, specOrigin16] = mfcc( sigOrigin16, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% rbs-2 reconstructed signal 8->16k
sigRBS2816 = rawread('F:\IFEFSR\SpeechData\RECAN48_FP_RBS2\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataRBS2816, FBERBS2816, specRBS2816] = mfcc( sigRBS2816, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% rbs-2 reconstructed signal 16->16k
sigRBS21616 = rawread('F:\IFEFSR\SpeechData\RECAN416_FP_RBS2\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataRBS21616, FBERBS21616, specRBS21616] = mfcc( sigRBS21616, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% rbs-4 reconstructed signal 8->16k
sigRBS4816 = rawread('F:\IFEFSR\SpeechData\RECAN48_FP_RBS4\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataRBS4816, FBERBS4816, specRBS4816] = mfcc( sigRBS4816, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% rbs-4 reconstructed signal 16->16k
sigRBS41616 = rawread('F:\IFEFSR\SpeechData\RECAN416_FP_RBS4\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataRBS41616, FBERBS41616, specRBS41616] = mfcc( sigRBS41616, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% reconstruct MRBS 8T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest_small.txt';
fileList = importdata(infile);
inDir = 'F:\IFEFSR\AudioFC\FC\TEST\AN48_FP_RBS';
outDir = 'F:\IFEFSR\SpeechData\FCMATLABMRBS2T4FS816';
RBS = [{'4'}, {'2'}];
inFs = 8000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABMRBSDecode(  fileList, inDir, RBS, outDir, inFs, outFs, inExt, outExt  );
sigMRBS2T4816 = rawread('F:\IFEFSR\SpeechData\FCMATLABMRBS2T4FS816\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataMRBS2T4816, FBEMRBS2T4816, specMRBS2T4816] = mfcc( sigMRBS2T4816, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% reconstruct MRBS 16T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest_small.txt';
fileList = importdata(infile);
inDir = 'F:\IFEFSR\AudioFC\FC\TEST\AN416_FP_RBS';
outDir = 'F:\IFEFSR\SpeechData\FCMATLABMRBS2T4FS1616';
RBS = [{'4'}, {'2'}];
inFs = 16000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABMRBSDecode(  fileList, inDir, RBS, outDir, inFs, outFs, inExt, outExt  );
sigMRBS2T41616 = rawread('F:\IFEFSR\SpeechData\FCMATLABMRBS2T4FS1616\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataMRBS2T41616, FBEMRBS2T41616, specMRBS2T41616] = mfcc( sigMRBS2T41616, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% plot the comparision
fig = 1;
plotCMPSpec(fig, ...
    specOrigin8, 'Original 8 kHz', ...
    specOrigin16, 'Original 16 kHz', ...
    specRBS2816, 'RECAN48_FP_RBS2 8->16 kHz', ...
    specRBS4816, 'RECAN48_FP_RBS4 8->16 kHz', ...
    specMRBS2T4816, 'RECAN48_MRBS2T4 8->16 kHz', ...
    specMRBS2T41616, 'RECAN48_MRBS2T4 16->16 kHz')

%     specRBS21616, 'RECAN416_FP_RBS2 16->16 kHz', ...
%     specRBS41616, 'RECAN416_FP_RBS4 16->16 kHz' ...
%     )

end

