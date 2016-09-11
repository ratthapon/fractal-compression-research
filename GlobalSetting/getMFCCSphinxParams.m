function [ Tw, Ts, preemAlpha, M, C, L, LF, HF ] = getMFCCSphinxParams()
%GETMFCCSPHINXPARAMS Load the global setting of MFCC parameters
Tw = 32;                % analysis frame duration (ms)
Ts = 16;                % analysis frame shift (ms)
preemAlpha = 0.95;      % preemphasis coefficient
M = 30;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 130;               % lower frequency limit (Hz)
HF = 7300;              % upper frequency limit (Hz)
end

