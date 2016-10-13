function [ f ] = ADPAFCCompose( parts, codePathPrefix, codeName, RBS )
%ADPAFCCOMPOSE Compose the adaptive partition fractal codes from multiple
%fixed partition fractal codes.
%   parts - partition of signal from ADP or FP
%   codePathPrefix - path prefix of fixed partition fractal codes.
%   codeName - path string to code path
%   RBS - array of size of fixed partition

% load all fixed partition codes into mem
F = cell(length(RBS), 1);
for sIdx = 1:length(RBS)
    dat = load(fullfile( [codePathPrefix num2str(RBS(sIdx))], codeName ));
    F{sIdx} = dat.f;
end

% allocate output code
nf = length(parts);
f = zeros(nf, 5);

cumulParts = 0;
for fIdx = 1:nf
    % find the part index for part at fIdx
    pIdx = floor(cumulParts/parts(fIdx)) + 1;
    
    % find the size index
    pSize = find( RBS == parts(fIdx) );
    
    % copy the code for part
    f(fIdx, :) = F{pSize}(pIdx, :);

    % cumulate next part idx
    cumulParts = cumulParts + parts(fIdx);
end

