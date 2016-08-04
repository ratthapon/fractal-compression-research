function [ complexSignal ] = createComplexSignal( Fs )
%COMPLEXSIGNAL Summary of this function goes here
%   Detailed explanation goes here
% Fs = 8000;
dt = 1/Fs;                   % seconds per sample
t = (0:dt:1.5)';     % seconds
complexSignal = zeros(200, 1);
for i = 1:70
    freq = i * 55;
    hsignal = 20*sin(2*pi* (freq) *t);
    hsignal = hsignal(1:200);
    complexSignal = complexSignal + hsignal;
end
end

