function FBE = getFBE(wave,fs)
M = 22;
LF = 300;
HF = 3700;
R = [LF HF];

hz2mel = @( hz )( 1127*log(1+hz/700) );     % Hertz to mel warping function
mel2hz = @( mel )( 700*exp(mel/1127)-700 ); % mel to Hertz warping function

nfft = 2^nextpow2( size(wave,2) );
K = nfft/2+1;                % length of the unique part of the FFT
MAG = abs( fft(wave,nfft) );
uniquePart = MAG(1,1:K)';
H = trifbank( M, K, R, fs, hz2mel, mel2hz ); % size of H is M x K
FBE = H*uniquePart;