function [ sigWithHar, fundFreq, synthHar ] = addHarToSigFromCeps( originSig, sig, inFs, outFs, varargin )
%ADDHARTOSPECFROMCEPS Generate the higher harmonic from lower fs signal
%then add to higher fs spectrum.

% if inFs >= outFs
%     fundFreq = [];
%     synthHar = [];
%     sigWithHar = sig;
%     return;
% end

nfft = 512;
dt = 1/inFs;                            % sample duration
t = 0:dt:length(originSig)*dt-dt;       % time index of sample
df = 1/nfft;                            % nft per sample
stopFreq = 1;                           % nft
fh = (0:df:stopFreq-df)';               % seconds
magFilt = exp(-(1:nfft)/nfft)';
% magFilt = 1 * atan((1:nfft)/nfft)';
nPitch = 1;
if ~isempty(varargin)
    nPitch = varargin{1};
end

% obtain the mfcc parameters
[ Tw, Ts, ~, ~, ~, ~, ~, ~ ] = getMFCCSphinxParams();
Nw = round( 1E-3*Tw* 8000);    % frame duration (samples)
Ns = round( 1E-3*Ts* 8000);    % frame shift (samples)
frames = vec2frames( originSig, Nw, Ns, 'cols', @hamming, false );

Nw2 = round( 1E-3*Tw*outFs );    % frame duration (samples)
Ns2 = round( 1E-3*Ts*outFs );    % frame shift (samples)
framesSig = vec2frames( sig, Nw2, Ns2, 'cols', @hamming, false );

% initialize data
inSpec = fft(framesSig, nfft + 1, 1);
originCeps = zeros(size(frames));
fundFreq = zeros(1, size(frames, 2));
specWithHar = zeros(nfft+1, size(frames, 2));
synthHar = ones(nfft, size(frames, 2));

for i = 1:size(frames, 2)
    originCeps(:, i) = cceps(frames(:, i));
    
    trng = t(t>=2e-3 & t<=10e-3);
    crng = originCeps(t>=2e-3 & t<=10e-3, i);
    
    % determine the pitch index
    sortedPitch = sortrows([crng(:) (1:length(crng))']);
    for p = 1:nPitch
        I = sortedPitch(p, 2);
        
        % get the fundamental frequency from index
        f0 = 1/trng(I);
        fundFreq(i) = f0;
        
        % caculate the new frequency index of pitch
        f0FT = outFs/2/nfft/f0;
        
        % synthesize the harmonic filter
        synthHar(:, i) = synthHar(:, i) .*  ...
            (sin(2 * pi * 1/f0FT * fh - pi/2));
    end
    % bias harmonic
    synthHar(:, i) = (synthHar(:, i) - min(synthHar(:, i))) ...
        / (max(synthHar(:, i)) - min(synthHar(:, i))) ;
    synthHar(:, i) = synthHar(:, i) + 1;
    synthHar(:, i) = synthHar(:, i) .* magFilt;
    
    % retain lower frequency spectrum
    halfOutFsIdx = floor(Nw/2);
    [~, localMinPeaks] = findpeaks(-synthHar(:, i));
    halfLocalMinPeaksIdx = find(localMinPeaks > halfOutFsIdx, 1);
    lowerF0Idx = localMinPeaks(halfLocalMinPeaksIdx);
    synthHar(1:lowerF0Idx, i) = 1;
    
    % duplicate the half spectrum
    synthHar(end:-1:(end/2)+1, i) = synthHar(1:(end/2), i);
    
    % apply the harmonic filter to spectrum
    specWithHar(2:end, i) = inSpec(2:end, i) .* synthHar(:, i);
end
% j = sqrt(-1);
% magInfo = fft(frames, nfft, 1);
% phaseInfo = exp(j*angle(magInfo));
% sing = complex(abs(magInfo), phaseInfo);
% figure, imagesc(abs(specWithHar(1:end/2, :)));
% figure, imagesc(abs(inSpec(1:end/2, :)));

invSpec = real(ifft(specWithHar, Nw2, 1));

sigWithHar = deframe_sig(invSpec', length(sig), Nw2, Ns2, @hamming);
% [ CC0REC, FBE0REC, OUTMAG0REC, ~, ~, ~] = mfcc2( sigWithHar, 16000);
% figure;imagesc(OUTMAG0REC);
% soundsc(sigWithHar, 16000)

end

