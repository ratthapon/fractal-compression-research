function [ outWave ] = addEvenHar( wave )
%ADDEVENHAR Add even harmonic to input signal using clipping technique

genevenhar = @(wave) atan(wave);
outWave = genevenhar( wave/norm(wave));
end

