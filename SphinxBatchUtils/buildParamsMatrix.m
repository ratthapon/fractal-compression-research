function [ paramsSet ] = buildParamsMatrix( varargin )
%BUILDPARAMSMATRIX Combined the each parameters to single 2d-cell for
%convenient coding.
%   varargin - arrays of cells that contain parameter

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





