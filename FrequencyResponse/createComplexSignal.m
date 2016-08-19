function [ complexSignal ] = createComplexSignal( Fs )
%COMPLEXSIGNAL Summary of this function goes here
%   Detailed explanation goes here
% Fs = 8000;
dt = 1/Fs;                   % seconds per sample
t = (0:dt:1.5)';     % seconds
nSample = 400 * floor(Fs/8000);
complexSignal = zeros(nSample, 1);
nBand = 70 * floor(Fs/8000);
for i = 1:nBand
    freq = i * 55;
    hsignal = 20*sin(2*pi* (freq) *t);
    hsignal = hsignal(1:nSample);
    complexSignal = complexSignal + hsignal;
end
end

