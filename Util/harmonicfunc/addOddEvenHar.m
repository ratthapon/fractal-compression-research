function [ outWave ] = addOddEvenHar( wave )
%ADDODDEVENHAR SAdd odd and even harmonic to input signal

outWave = wave;
for i = 1:length(wave) - 1
    if wave(i) >= wave(i+1)
       outWave(i+1) = wave(i+1).^3;
    else 
       outWave(i+1) = wave(i+1);
    end
end
end

