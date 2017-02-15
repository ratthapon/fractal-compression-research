function [ sigWithHar, fundFreq, synthHar ] = addHarToSigFromCeps( originSig, sig, inFs, outFs, varargin )
%ADDHARTOSPECFROMCEPS Generate the higher harmonic from lower fs signal
%then add to higher fs spectrum.

nfft = 512;
dt = 1/inFs;                            % sample duration
t = 0:dt:length(originSig)*dt-dt;       % time index of sample
df = 1/nfft;                            % nft per sample
stopFreq = 1;                           % nft
fh = (0:df:stopFreq-df)';               % seconds
quartNfft = nfft/4;
logisBias = 1./(1 + exp(-(-(quartNfft*1.5):(quartNfft*2.5)-1)/16));
magFilt = exp(-(1:nfft)/nfft)';
% magFilt = 1 * atan((1:nfft)/nfft)';
nHar = nfft/2;
nPitch = 1;
minHD = 1;
minCD = 1;
for vIdx = 1:2:length(varargin)
    switch lower(varargin{vIdx})
        case 'npitch'
            nPitch = varargin{vIdx + 1};
        case 'nhar'
            nHar = varargin{vIdx + 1};
        case 'minhardist'
        case 'minhd'
            minHD = varargin{vIdx + 1};
        case 'mincepsdist'
        case 'mincd'
            minCD = varargin{vIdx + 1};
        case 'enableexcludeorigin'
            isExclude = varargin{vIdx + 1};
            if inFs >= outFs && isExclude == true
                fundFreq = [];
                synthHar = [];
                sigWithHar = sig;
                return;
            end
        otherwise
    end
end

% obtain the mfcc parameters
[ Tw, Ts, ~, ~, ~, ~, ~, ~ ] = getMFCCSphinxParams();
Nw = round( 1E-3*Tw* 8000);    % frame duration (samples)
Ns = round( 1E-3*Ts* 8000);    % frame shift (samples)
Nw2 = round( 1E-3*Tw*outFs );    % frame duration (samples)
Ns2 = round( 1E-3*Ts*outFs );    % frame shift (samples)

frames = vec2frames( originSig, Nw, Ns, 'cols', @hamming, false );
framesSig = vec2frames( sig, Nw2, Ns2, 'cols', @hamming, false );

% initialize data
inSpec = fft(framesSig, nfft, 1);
originCeps = zeros(size(frames));
fundFreq = zeros(1, size(frames, 2));
specWithHar = zeros(nfft, size(frames, 2));
synthHar = ones(nfft, size(frames, 2));

for i = 1:size(frames, 2)
    originCeps(:, i) = cceps(frames(:, i));
    
    trng = t(t>=2e-3 & t<=10e-3);
    crng = originCeps(t>=2e-3 & t<=10e-3, i);
    
    % determine the pitch index
    [~, sortedPitch] = findpeaks(crng(:), ...
        'MinPeakDistance', minCD, 'SortStr', 'descend');
    nPitch = min(nPitch, length(sortedPitch));
    
    for p = 1:nPitch
        I = sortedPitch(p);
        
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
    [~, localMinPeaks] = findpeaks(-synthHar(:, i), ...
        'MinPeakDistance', minHD);
    halfLocalMinPeaksIdx = find(localMinPeaks > halfOutFsIdx, 1);
    lowerF0Idx = localMinPeaks(halfLocalMinPeaksIdx);
    upperF0Idx = localMinPeaks(min(halfLocalMinPeaksIdx + nHar, ...
        length(localMinPeaks)));
    synthHar(1:lowerF0Idx, i) = 1;
    synthHar(upperF0Idx:end, i) = 0;
    
    % duplicate the half spectrum
    synthHar(end:-1:(end/2)+1, i) = synthHar(1:(end/2), i);
    
    % apply the harmonic filter to spectrum
    specWithHar(:, i) = inSpec(:, i) .* synthHar(:, i);
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

