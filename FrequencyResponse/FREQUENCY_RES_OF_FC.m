%% generate signal and other information
close all
sig = createComplexSignal(8000);
rbs = 4;
nScale = 2;
scaleOrder = [4 2];
lambda = 0e4;

%% original 
plotSigVsFreqRes( sig, 'Original signal', 8000 );

%% interpolate
plotSigVsFreqRes( interp(sig, 2), 'Original signal', 16000 );

%% Fix R,D original coding section 
try
    rangePartition = rbs*ones(size(sig, 1)/rbs, 1);
    FC_QR = FixAFCEncoder( sig, rangePartition, 1, 2, lambda );
    REC_SIG_1 = decompressAudioFC(FC_QR, 8000, 16000, 15);
catch
end
plotSigVsFreqRes( REC_SIG_1, 'Fix R,D scale FC', 16000 );

%% Multi R coding section
REC_SIG_2 = MultiScaleFC( sig, scaleOrder, lambda );
plotSigVsFreqRes( REC_SIG_2, 'Multi R scales FC', 16000 );

%% Multi D coding section 
REC_SIG_3 = MultiVarFC( sig, nScale, rbs, lambda );
plotSigVsFreqRes( REC_SIG_3, 'Multi D scales FC', 16000 );


