%% generate signal and other information
close all
sig = createComplexSignal(8000);
speech  = rawread( 'F:\IFEFSR\an4\wav\an4_clstk\fash\an251-fash-b.raw' );
sig = speech(5500:6500);
% sig16 = createComplexSignal(16000);
% alpha = 0.97;
% sig = filter( [1 -alpha], 1, sig );
rbs = 4;
rbs_2 = 2;
nScale = 4;
scaleOrder = [ 64 32 16 8 4 2];
lambda = 0e4;
Fs_inout = [16000 16000];

%% original
plotSigVsFreqRes( sig, 'Original signal', 8000 );

%% interpolate
plotSigVsFreqRes( interp(sig, 2), 'Interpolate signal', 16000 );

%% Fix R,D original coding section
rangePartition = rbs*ones(size(sig, 1)/rbs, 1);
FC_QR = FixAFCEncoder( sig, rangePartition, 1, 2, lambda );
REC_SIG_1 = decompressAudioFC(FC_QR, Fs_inout(1), Fs_inout(2), 15);
caption = ['Fix R,D scale FC' ' psnr = ' num2str(PSNR(sig, REC_SIG_1))];
plotSigVsFreqRes( REC_SIG_1, caption, Fs_inout(2) );

% Fix R,D original coding section
rangePartition = rbs_2*ones(size(sig, 1)/rbs_2, 1);
FC_QR = FixAFCEncoder( sig, rangePartition, 1, 2, lambda );
REC_SIG_1_2 = decompressAudioFC(FC_QR, Fs_inout(1), Fs_inout(2), 15);
caption = ['Fix R,D scale FC 2' ' psnr = ' num2str(PSNR(sig, REC_SIG_1_2))];
plotSigVsFreqRes( REC_SIG_1_2, caption, Fs_inout(2) );

%% Multi R coding section
REC_SIG_2 = MultiScaleFC( sig, scaleOrder, Fs_inout, lambda );
caption = ['Multi R scales FC' ' psnr = ' num2str(PSNR(sig, REC_SIG_2))];
plotSigVsFreqRes( REC_SIG_2, caption, Fs_inout(2) );

%% Multi D coding section
REC_SIG_3 = MultiVarFC( sig, nScale, rbs_2, Fs_inout, lambda );
caption = ['Multi D scales FC' ' psnr = ' num2str(PSNR(sig, REC_SIG_3))];
plotSigVsFreqRes( REC_SIG_3, caption, Fs_inout(2) );

%%
 
% parts = ADP(speech, [4 8 16 32 64 128], 1e-6);
% caption = 'Speech signal 16 kHz';
% plotSigVsFreqRes( speech, caption, Fs_inout(2) );



