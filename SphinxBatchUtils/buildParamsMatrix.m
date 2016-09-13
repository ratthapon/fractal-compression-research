function [ paramsSet ] = buildParamsMatrix( varargin )
%BUILDPARAMSMATRIX Summary of this function goes here
%   Detailed explanation goes here

%% estimate number of params set
nParamsSet = 1;
for paramIdx = 1:nargin
    nParamsSet = nParamsSet * length(varargin{paramIdx});
end

% allocate params matrix
paramsSet = cell(nParamsSet, nargin);

nRepeat = nParamsSet;
% for each feature
for paramIdx = 1:nargin
    nValue = length(varargin{paramIdx});
    nRepeat = nRepeat / nValue;
    % for each vertical block
    for vBlock = 1:(nParamsSet/(nRepeat*nValue))
        vBlockOffset = (vBlock - 1) * (nRepeat*nValue);
        % for each value in vertical block
        for vIdx = 1: nValue
            % for each sample of each value
            for r = 1:nRepeat
                offset = (vIdx - 1) * nRepeat + vBlockOffset;
                paramsSet{ offset + r, paramIdx} = varargin{paramIdx}{vIdx};
            end
        end
    end
end





