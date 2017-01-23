TestHarmonicGeneration;

% [ CC08, FBE08, OUTMAG08, MAG08, H08, DCT08] = mfcc2( origin8, 8000);

[ CC08 ] = spec2ceps( OUTMAG08 );
[ CC016 ] = spec2ceps( OUTMAG016 );

recSpecIDCT08 = zeros(257, size(CC08, 2));
for t = 1:size(CC08, 2)
   recSpecIDCT08(:, t) = idct(CC08(:, t), 257);
end

recSpecIDCT016 = zeros(257, size(CC016, 2));
for t = 1:size(CC016, 2)
   recSpecIDCT016(:, t) = idct(CC016(:, t), 257);
end

recSpecIDCT08Norm = recSpecIDCT08;
recSpecIDCT08Norm(128:end, :) = 0;
recSpecIDCT016Norm = recSpecIDCT016;
recSpecIDCT016Norm(128:end, :) = 0;

MMSPEC08 = OUTMAG0 .* (abs(recSpecIDCT08));
MMSPEC016 = OUTMAG0 .* (abs(recSpecIDCT016));

figure(9), 
subplot(1,3,1), imagesc(OUTMAG0)
subplot(1,3,2), imagesc(MMSPEC08)
subplot(1,3,3), imagesc(MMSPEC016)



%% 
data = load('F:\IFEFSR\AudioFC\FC\EXP\EXP_HARMO\AN48_FP_RBS4\test_harmonics\an4_clstk\fash\an251-fash-b.mat');
f = data.f;
f(:, end-2) = f(:, end-2) + 1;

recWave = MDDecode(f,8000,16000, 2, 1, 1, false, 15);
recWave = addOddHar(zscore(recWave));

[ CCREC, FBEREC, OUTMAGREC, MAGREC, HREC, DCTREC] = mfcc2( recWave, 16000);



