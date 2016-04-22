N = 50;
k = 0:N-1;
n = 0;
x = audioread('F:\IFEFSR\SpeechData\ARMS_REC\8k_speaker_1_sp_1-01.wav');
x = x(4501:4756);
nfft = 2^nextpow2( 256 );     % length of FFT analysis 
MAG = abs( fft(x,256,1) ); 
X = abs(ifft(x(2),256,1));
figure,plot(x);
figure,plot(X);


