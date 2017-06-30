% setup signal parameters
f0 = 256;
fs = 4000;
df = fs/f0;
freqIdx = [10:10:256];
freq = freqIdx * df;

% Type III DCT matrix routine (see Eq. (5.14) on p.77 of [1])
dctm = @( N, M )( sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
    .* repmat(pi*([1:M]-0.5)/M,N,1) ) );

% gen artificial spectrum, specify frequency of signal
inSpec = zeros(f0, 1);
inSpec( freqIdx ) = 10;
figure(1), subplot(2,1,1)
stem(inSpec)

% gen signal from spectrum
sig = real(ifft(inSpec, f0/2, 1));
figure(1), subplot(2,1,1)
plot(sig)
figure(2), subplot(3,1,1)
plot(sig)

% extract spectrum
outSpec = fft( sig , f0*2, 1);
outSpec = outSpec(1:(end/2));
figure(2), subplot(3,1,2)
stem(abs(outSpec))

% extract cepstrumm
DCT = dctm(128, f0);
logspec = log( abs(outSpec) + 1 );
ceps = DCT * logspec;
figure(2), subplot(3,1,3)
stem(ceps)

% formating output data
datOutSig = [(1:size(sig))'*(1000/fs) sig];
datOutSpec = [(1:(f0/2))'*df outSpec];
datOutSpec = datOutSpec(2:2:end, :);
