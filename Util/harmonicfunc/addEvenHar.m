function [ outWave ] = addEvenHar( wave )
%ADDEVENHAR Add even harmonic to input signal using clipping technique

genevenhar = @(wave) wave.^3;
outWave = arrayfun( genevenhar, wave );

end

