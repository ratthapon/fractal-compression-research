
%% define variable
warning off
speech  = rawread( 'F:\IFEFSR\an4\wav\an4_clstk\fash\an251-fash-b.raw' );
speech = speech(6001:6400);
rbs = 16;
RBS = [32 16 8 4];
nScale = length(RBS);
lambda = 0e4;
Fs_inout = [16000 16000];

ticEncode = tic;
rangePartition = rbs*ones(size(speech, 1)/rbs, 1);
multiVarFC = MultiVarFixAFCEncoder( speech, rangePartition, ...
    1, lambda, nScale, rbs );
encodeTime = toc(ticEncode)

ticDecode = tic;
REC_SIG = MultiVarFixAFCDecoder(multiVarFC, Fs_inout(1), Fs_inout(2), 15);
decodeTime = toc(ticDecode)

[ qiLow, qiHigh ] = lowHighQI( REC_SIG, speech )

rbs4 = 4;
rangePartition = rbs4*ones(size(speech, 1)/rbs4, 1);
fixedFC =    FixAFCEncoder( speech, rangePartition, 1, 2, lambda );
recFixedSig = AFCDecode(fixedFC, Fs_inout(1), Fs_inout(2), 15);
[ qiLow_MRBS, qiHigh_MRBS ] = lowHighQI( recFixedSig, speech )

figure(1),
subplot(2,1,1), plot(speech)
subplot(2,1,2), plot(REC_SIG)

figure(2),
hold on
plot(speech, 'b')
plot(REC_SIG, 'r')

mkdir('F:/IFEFSR/MDBS/')
save('F:/IFEFSR/MDBS/ws.mat')



