%% generate signal and other information
close all
sig = createComplexSignal(8000);
% sig16 = createComplexSignal(16000);
% alpha = 0.97;
% sig = filter( [1 -alpha], 1, sig );
rbs = 4;
rbs_2 = 2;
nScale = 2;
scaleOrder = [ 4 2];
lambda = 0e4;
Fin_out = [8000 8000];

%% original
plotSigVsFreqRes( sig, 'Original signal', 8000 );

%% interpolate
plotSigVsFreqRes( interp(sig, 2), 'Interpolate signal', 16000 );

%% Fix R,D original coding section
rangePartition = rbs*ones(size(sig, 1)/rbs, 1);
FC_QR = FixAFCEncoder( sig, rangePartition, 1, 2, lambda );
REC_SIG_1 = decompressAudioFC(FC_QR, Fin_out(1), Fin_out(2), 15);
caption = ['Fix R,D scale FC' ' psnr = ' num2str(PSNR(sig, REC_SIG_1))];
plotSigVsFreqRes( REC_SIG_1, caption, Fin_out(2) );

% Fix R,D original coding section
rangePartition = rbs_2*ones(size(sig, 1)/rbs_2, 1);
FC_QR = FixAFCEncoder( sig, rangePartition, 1, 2, lambda );
REC_SIG_1_2 = decompressAudioFC(FC_QR, Fin_out(1), Fin_out(2), 15);
caption = ['Fix R,D scale FC 2' ' psnr = ' num2str(PSNR(sig, REC_SIG_1_2))];
plotSigVsFreqRes( REC_SIG_1_2, caption, Fin_out(2) );

%% Multi R coding section
REC_SIG_2 = MultiScaleFC( sig, scaleOrder, Fin_out, lambda );
caption = ['Multi R scales FC' ' psnr = ' num2str(PSNR(sig, REC_SIG_2))];
plotSigVsFreqRes( REC_SIG_2, caption, Fin_out(2) );

%% Multi D coding section
REC_SIG_3 = MultiVarFC( sig, nScale, rbs, Fin_out, lambda );
caption = ['Multi D scales FC' ' psnr = ' num2str(PSNR(sig, REC_SIG_3))];
plotSigVsFreqRes( REC_SIG_3, caption, Fin_out(2) );


