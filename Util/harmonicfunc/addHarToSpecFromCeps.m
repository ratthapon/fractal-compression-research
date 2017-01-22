function [ specWithHar ] = addHarToSpecFromCeps( originSig, inSpec, inFs, outFs )
%ADDHARTOSPECFROMCEPS Generate the higher harmonic from lower fs signal
%then add to higher fs spectrum.

nfft = size(inSpec, 1) - 1;                   % samples per second
dt = 1/inFs;
t = 0:dt:length(originSig)*dt-dt;
df = 1/nfft;                   % nft per sample
stopFreq = 1;             % nft
fh = (0:df:stopFreq-df)';     % seconds
magFilt = exp(-(1:nfft)/nfft)';

[ Tw, Ts, ~, ~, ~, ~, ~, ~ ] = getMFCCSphinxParams();
Nw = round( 1E-3*Tw*inFs );    % frame duration (samples)
Ns = round( 1E-3*Ts*inFs );    % frame shift (samples)
frames = vec2frames( originSig, Nw, Ns, 'cols', @hamming, false );

originCeps = zeros(nfft, size(frames, 2));
fundFreq = zeros(1, size(frames, 2));
specWithHar = zeros(nfft+1, size(frames, 2));
specWithHar(1, :) = inSpec(1, :);
synthHar = zeros(nfft, size(frames, 2));

for i = 1:size(frames, 2)
    originCeps(:, i) = cceps(frames(:, i));
    
    trng = t(t>=2e-3 & t<=10e-3);
    crng = originCeps(t>=2e-3 & t<=10e-3, i);
    [pitchMag,I] = max(crng);
    fprintf('Complex cepstrum F0 estimate is %3.2f Hz.\n',1/trng(I))
    f0 = 1/trng(I);
    fundFreq(i) = f0;
    f0FT = outFs/2/nfft/f0;
    synthHar(:, i) = 1 * (0.5*sin(2 * pi * 1/f0FT * fh - pi/2) + 0.5) .* magFilt;
    specWithHar(2:end, i) = inSpec(2:end, i) .* synthHar(:, i);
end



end

