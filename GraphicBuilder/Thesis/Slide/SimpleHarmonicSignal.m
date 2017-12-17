% setup signal parameters
f0 = 256;
fs = 8000;
df = fs/f0;
freqIdx = 10;
freq = freqIdx * df;

% gen artificial spectrum, specify frequency of signal
inSpec = zeros(f0, 1);
inSpec( freqIdx ) = 1;

% gen signal from spectrum
sig = real(ifft(complex(inSpec), f0, 1));
figure(1), plot(sig)

% inverse to spectrum
outSpec = real(fft(sig, f0, 1));
outSpec = outSpec(1:(end/2));
figure(2), stem(outSpec)

% formating output data
datOutSig = [(1:size(sig))'*(1000/fs) sig];
datOutSpec = [(1:(f0/2))'*df outSpec];
datOutSpec = datOutSpec(2:2:end, :);




