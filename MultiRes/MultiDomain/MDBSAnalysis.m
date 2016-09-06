%% co-parameters
warning off
speech  = rawread( 'F:\IFEFSR\an4\wav\an4_clstk\fash\an251-fash-b.raw' );
speech = speech(6001:6400);
rbs = 4;
RBS = [ 128 64 32 16 8 4 ]; % determine by number of block, not block size
nScale = length(RBS);
lambda = 0e4;
Fs_inout = [16000 16000];

%% vary base rbs
baseRBS = [4 8 16];
baseRBSCorr = zeros(2, length(baseRBS));
for i = 1:length(baseRBS)
    rbs = baseRBS(i)
    rangePartition = rbs*ones(size(speech, 1)/rbs, 1);
    multiVarFC = MultiVarFixAFCEncoder( speech, rangePartition, ...
        1, lambda, nScale, rbs );
    
    REC_SIG = MultiVarFixAFCDecoder(multiVarFC, Fs_inout(1), Fs_inout(2), 15);
    
    [ qiLow, qiHigh ] = lowHighQI( REC_SIG, speech )
    baseRBSCorr(:, i) = [qiLow; qiHigh];
    
    figure,
    subplot(2,1,1), plot(speech)
    subplot(2,1,2), plot(REC_SIG)
    
    figure,
    hold on
    plot(speech, 'b')
    plot(REC_SIG, 'r')
    title(['Corr low = ' num2str(qiLow) ' Corr high = ' num2str(qiHigh)]);
end

%% vary max dbs
rbs = 4; % fixed rbs
dbsScale = [2 3 4 5 6];
nDBSCorr = zeros(2, length(dbsScale));

for i = 1:length(dbsScale)
    nScale = dbsScale(i)
    rangePartition = rbs*ones(size(speech, 1)/rbs, 1);
    multiVarFC = MultiVarFixAFCEncoder( speech, rangePartition, ...
        1, lambda, nScale, rbs );
    
    REC_SIG = MultiVarFixAFCDecoder(multiVarFC, Fs_inout(1), Fs_inout(2), 15);
    
    [ qiLow, qiHigh ] = lowHighQI( REC_SIG, speech )
    nDBSCorr(:, i) = [qiLow; qiHigh];
    
    figure,
    subplot(2,1,1), plot(speech)
    subplot(2,1,2), plot(REC_SIG)
    
    figure,
    hold on
    plot(speech, 'b')
    plot(REC_SIG, 'r')
    title(['Corr low = ' num2str(qiLow) ' Corr high = ' num2str(qiHigh)]);
end








