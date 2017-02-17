function [ hybridSig, fundFreq, synthHar ] = addHighSpecFromRecon( originSig, reconSig, inFs, outFs, varargin )
%ADDHIGHSPECFROMRECON Generate the higher spectrum from lower fs signal
%then add to higher fs spectrum.

nfft = 512;
for vIdx = 1:2:length(varargin)
    switch lower(varargin{vIdx})
        case 'enableexcludeorigin'
            isExclude = varargin{vIdx + 1};
            if inFs >= outFs && isExclude == true
                fundFreq = [];
                synthHar = [];
                hybridSig = reconSig;
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
framesSig = vec2frames( reconSig, Nw2, Ns2, 'cols', @hamming, false );

% initialize data
reconSpec = fft(framesSig, nfft, 1);
fundFreq = zeros(1, size(frames, 2));
originSpec = fft(frames, 0.5*nfft, 1);
hybridSpec = zeros(size(framesSig));
synthHar = ones(nfft, size(frames, 2));

for i = 1:size(frames, 2)
    hybridSpec(1:0.5*nfft, i) = originSpec(1:0.5*nfft, i);
    
    % apply the harmonic filter to spectrum
    hybridSpec(0.5*nfft:nfft, i) = reconSpec(0.5*nfft:nfft, i);
    
    % duplicate the half spectrum
    hybridSpec(end:-1:(end/2)+1, i) = hybridSpec(1:(end/2), i);
end
invSpec = real(ifft(hybridSpec, Nw2, 1));

hybridSig = deframe_sig(invSpec', length(reconSig), Nw2, Ns2, @hamming);

end

