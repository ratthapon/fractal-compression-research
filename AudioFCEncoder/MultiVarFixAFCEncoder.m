function [ FC ] = MultiVarFixAFCEncoder( sig, rangePartition, ...
    degree, lambda, nScale, baseRange )
%FIXENCODER Summary of this function goes here
%   Detailed explanation goes here

%% simple function
% map index k to sample at scale s_(th) of n scales. this for base2
b = baseRange;
n = nScale + 1;
dStart_b2 = @(k ,s) 2^(n-1) - 2^(s-1) + k;
dEnd_b2 = @(k ,s) 2^(n-1) + 2^(s-1) + k;

dStart = @(k ,s) k + (n-s) * (b/2);
dEnd = @(k ,s) k + (n+s) * (b/2) - 1;

%% fix parameters
t = tic;
rIdx = 1; % start sample idx
nC = degree*nScale + 1; % nCoeff
nPart = length(rangePartition);
nSample = sum(rangePartition);
FC = zeros(nPart, nC + 3, 'single'); %ehl
CSlices = 1:nC;

%% generate range blocks indices
rSlices = zeros(1, nPart + 1);
rSlices(1) = 0;
for i = 1:nPart
    rSlices(i + 1) = sum(rangePartition(1:i));
end

%% define data
dat = sig(1: nSample); % data mat
revDat = sig(nSample: -1: 1); % data mat

% overlimit coeff indicator
for fIdx = 1:nPart % each range block
    currentBlock = [num2str(fIdx) ' / ' num2str(nPart)];
    rbs = rangePartition(fIdx);
    nBatch = (nSample - b*n+1) * 2; % calculate possible
    
    %% allocate arrays
    I = diag(ones(nC, 1, 'single')); % identity matrix for inversion
    EXPZERO = ones(rbs, 1, 'single'); % power zero data
    SSE = zeros(nBatch, 1, 'single'); % sum square error
    C = zeros(nBatch, nC, 'single'); % coefficient temp
    
    %% Get range block
    R = dat(rSlices(fIdx) + 1: rSlices(fIdx + 1)); % range block
    
    %% match range block by comparing every possible domain blocks
    for batchIdx = 1:nBatch
        % first order matrix
        X = zeros(rbs, n, 'single'); % covariance matrix
        X(:, 1) = EXPZERO;
        
        % calculate multivariate input
        for s = 2:n
            if batchIdx <= nBatch/2
                k = batchIdx;
                refDat = dat(dStart(k ,s) : dEnd(k ,s));
            else
                k = batchIdx - (nBatch/2);
                refDat = revDat(dStart(k ,s) : dEnd(k ,s));
            end
            
            % resample domain
            D = (1/s) * ...
                sum( ...
                reshape(refDat, [s rbs] )... % reshape params
                ,1)'; % sum params, sum each column
            % building linear problem
            X(:, s) = D; % input data
        end
        
        %% calculate covariance matrix
        A = (X'*X) + (lambda * I);
        detA = det(A);
        
        %% handle if can not find solution
        % this exception only handle for n coeff == 2
        if nC ~= 2 || (nC == 2 && detA ~= 0)
            % the solution maybe found somewhere
            B = X'*R; % calculate output mat
            % solve least square
            C(batchIdx, CSlices) = (A\B)';
            
        elseif nC == 2 && (detA == 0)
            C(batchIdx, CSlices) = [sum(R)/rbs 0];
        end
        
        %% compute sum square error
        F = X * C(batchIdx, CSlices)';
        SE = (R - F).^2;
        SSE(batchIdx) = sum(SE);
        
    end
    %% store fractal code
    % find the minimum sum square error of models
    [sseValue, minSSEIdx] = min(SSE);
    code = [C(minSSEIdx,1:nC) minSSEIdx rbs sseValue]';
    % represent reverse domain map by negative domain index
    if (minSSEIdx > nBatch / 2)
        minSSEIdx = -(nBatch - minSSEIdx + 2);
        code(nC + 1) = minSSEIdx;
    end
    FC(fIdx, :) = code;
    
end
toc(t)
end

