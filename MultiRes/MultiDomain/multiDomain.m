
%% define variable
warning off
speech  = rawread( 'F:\IFEFSR\an4\wav\an4_clstk\fash\an251-fash-b.raw' );
rbs = 4;
RBS = [128 64 32 16 8 4 ];
nScale = length(RBS);
lambda = 0e4;
Fs_inout = [16000 16000];

ticEncode = tic;
rangePartition = rbs*ones(size(speech, 1)/rbs, 1);
multiVarFC = MultiVarFixAFCEncoder( speech, rangePartition, ...
    1, lambda, nScale, rbs );
encodeTime = toc(ticEncode)

ticDecode = tic;
REC_SIG = MultiVarFixAFCDecoder(multiVarFC, Fin_out(1), Fin_out(2), 15);
decodeTime = toc(ticEncode)





