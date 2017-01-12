
% inWave = rawread('F:\IFEFSR\ExpSphinx\FCMATLABRBS4FS816\wav\an4_clstk\fash\an251-fash-b.raw');

genevenhar = @(wave) atan(wave);
genoddhar = @(wave) wave.^3;

oddevensig = inWave;
for i = 1:length(inWave) - 1
    if inWave(i) >= inWave(i+1)
       oddevensig(i+1) = inWave(i+1).^3;
    else 
       oddevensig(i+1) = inWave(i+1);
    end
end

evenharsig = genevenhar(inWave/norm(inWave));
oddharsig = genoddhar(inWave);

figure(1),
subplot(3,1,1), plot(evenharsig);
subplot(3,1,2), plot(oddharsig);
subplot(3,1,3), plot(oddevensig);

[ CC1, FBE1, OUTMAG1, MAG1, H1, DCT1] = mfcc2( evenharsig, 16000);
[ CC2, FBE2, OUTMAG2, MAG2, H2, DCT2] = mfcc2( oddharsig, 16000);
[ CC3, FBE3, OUTMAG3, MAG3, H3, DCT3] = mfcc2( oddevensig, 16000);

figure(2),
subplot(1,3,1), imagesc(OUTMAG1);
subplot(1,3,2), imagesc(OUTMAG2);
subplot(1,3,3), imagesc(OUTMAG3);


