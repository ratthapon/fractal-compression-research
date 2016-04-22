clc
clear all

Tw = 25;                % analysis frame duration (ms)
Ts = 10;                % analysis frame shift (ms)
alpha = 1.0;           % preemphasis coefficient
M = 20;                 % number of filterbank channels
C = 12;                 % number of cepstral coefficients
L = 22;                 % cepstral sine lifter parameter
LF = 300;               % lower frequency limit (Hz)
HF = 3700;              % upper frequency limit (Hz)

load('C:\Project\IFEFSR\MData\GMM');
[speech fs] = audioread('F:\IFEFSR\SpeechData\NECTEC\CF001_Va001\CF001_Va001_001.wav');
[ MFCCs, FBEs, frames ] = ...
        mfcc( speech(:,1), fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    MFCCs = MFCCs(2:end,:);
    
frame = MFCCs(:,1)';

sigma_c1 = GMM.Sigma(:,:,1);
mu_c1 = GMM.mu(1,:);
test1 = pdf(GMM,mu_c1);
[idx,nlogl,P,test2] = cluster(GMM,mu_c1);
% pdf_x_c1 = pdf('gaussian mixture distribution',frame,mu_c1,sigma_c1);

p_X_given_O =  (1./((2*pi*(sigma_c1^2))^0.5))*exp(-1/2*(sigma_c1.^2)*((frame-mu_c1).^2)')

