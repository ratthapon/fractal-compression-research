function [ outWave ] = addOddHar( wave )
%ADDODDHAR Gen odd harmonic using power

genoddhar = @(wave) wave.^3;
outWave = genoddhar(wave);

end

