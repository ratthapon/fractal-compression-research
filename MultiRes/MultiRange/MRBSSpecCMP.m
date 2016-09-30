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
sigOrigin16 = rawread(['F:\IFEFSR\SpeechData\an4\wav\' fileList{2} '.raw']);
[MFCCDataOrigin16, FBEOrigin16, specOrigin16_2] = mfcc( sigOrigin16, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% rbs-2 reconstructed signal 8->16k
sigRBS2816 = rawread(['F:\IFEFSR\SpeechData\RECAN48_FP_RBS2\' fileList{3} '.raw']);
[MFCCDataRBS2816, FBERBS2816, specRBS2816_3] = mfcc( sigRBS2816, 16000, ...
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
outDir = 'F:\IFEFSR\SpeechData\FCMATLABMRBS4T128FS816';
RBS = [{'128'}, {'64'}, {'32'}, {'16'}, {'8'}, {'4'}, {'2'}];
inFs = 8000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABMRBSDecode(  fileList(3), inDir, RBS, outDir, inFs, outFs, inExt, outExt  );
sigMRBS4T128816 = rawread(['F:\IFEFSR\SpeechData\FCMATLABMRBS4T128FS816\wav\' fileList{3} '.raw']);
[MFCCDataMRBS4T128816, FBEMRBS4T128816, specMRBS4T128816_3] = mfcc( sigMRBS4T128816, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% reconstruct MRBS 16T16k signals using MATLAB decode
infile = 'F:\IFEFSR\ExpSphinx\an4traintest_small.txt';
fileList = importdata(infile);
inDir = 'F:\IFEFSR\AudioFC\FC\TEST\AN416_FP_RBS';
outDir = 'F:\IFEFSR\SpeechData\FCMATLABMRBS4T128FS1616';
RBS = [{'128'}, {'64'}, {'32'}, {'16'}, {'8'}, {'4'}, {'2'}];
inFs = 16000;
outFs = 16000;
inExt = 'mat';
outExt = 'raw';
batchMATLABMRBSDecode(  fileList(1), inDir, RBS, outDir, inFs, outFs, inExt, outExt  );
sigMRBS4T1281616 = rawread('F:\IFEFSR\SpeechData\FCMATLABMRBS4T128FS1616\wav\an4_clstk\fash\an251-fash-b.raw');
[MFCCDataMRBS4T1281616, FBEMRBS4T1281616, specMRBS4T1281616] = mfcc( sigMRBS4T1281616, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% low-pass filter
%% rbs-2 reconstructed signal 8->16k
sigRBS2816 = rawread('F:\IFEFSR\SpeechData\RECAN48_FP_RBS4\an4_clstk\fash\an251-fash-b.raw');
mask = fir1(16, 0.9125);
sigRBS2816 = filtfilt(mask, 1, sigRBS2816);
% sigRBS2816 = filter( [1 -0.95], 1, sigRBS2816 );
% fvtool( [1 -0.95], 1 );
[~, ~, specRBS2LP816] = mfcc( sigRBS2816, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% rbs-2 reconstructed signal 16->16k
sigRBS21616 = rawread('F:\IFEFSR\SpeechData\RECAN416_FP_RBS4\an4_clstk\fash\an251-fash-b.raw');
mask = fir1(16, 0.9125);
sigRBS21616 = filtfilt(mask, 1, sigRBS21616);
[~, ~, specRBS2LP1616] = mfcc( sigRBS21616, 16000, ...
    Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );

%% accquire indices
[ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ] = lowHighIndices( specRBS2816, specOrigin16 );
t1 = fullfile('specRBS2816', num2str([ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ]));
[ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ] = lowHighIndices( specRBS21616, specOrigin16 );
t2 = fullfile('specRBS21616', num2str([ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ]));
[ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ] = lowHighIndices( specMRBS4T128816, specOrigin16 );
t3 = fullfile('specMRBS4T128816', num2str([ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ]));
[ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ] = lowHighIndices( specMRBS4T1281616, specOrigin16 );
t4 = fullfile('specMRBS4T1281616', num2str([ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ]));
%% plot the comparision
fig = 1;
plotCMPSpec(fig, ...
    specOrigin8, 'Original 8 kHz', ...
    specOrigin16, 'Original 16 kHz', ...
    specRBS2816, t1 , ...
    specMRBS4T128816, t3  ...
)
figure, 
surf(specOrigin16);

figure, 
surf(specRBS2816);

figure, 
surf(specMRBS4T128816);

%     specRBS21616, t2 , ...
%     specMRBS4T1281616, t4 
%     specRBS21616, 'RECAN416_FP_RBS2 16->16 kHz', ...
%     specRBS41616, 'RECAN416_FP_RBS4 16->16 kHz' ...
%     )

end

