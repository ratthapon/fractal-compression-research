function [ FC ] = FixAFCEncoder( sig, rangePartition, degree, dScale, lambda )
%FIXENCODER Summary of this function goes here
%   Detailed explanation goes here

%% fix parameters
t = tic;
rIdx = 1; % start sample idx
nC = 1+1; % nCoeff
nPart = length(rangePartition);
nSample = sum(rangePartition);
FC = zeros(nPart, nC + 3, 'single'); %ehl

dat = sig(1: nSample); % data mat
revDat = sig(nSample: -1: 1); % data mat

% overlimit coeff indicator
for fIdx = 1:nPart % each range block
    rbs = rangePartition(fIdx);
    nBatch = (nSample - rbs*dScale) * 2; % calculate possible
    
    I = diag(ones(nC, 1, 'single')); % identity matrix for inversion
    EXPZERO = ones(rbs, 1, 'single'); % power zero data
    SSE = zeros(nBatch, 1, 'single'); % sum square error
    C = zeros(nBatch, nC, 'single'); % coefficient temp
    X = zeros(rbs, nC, 'single'); % covariance matrix
    
    R = dat(rIdx: rIdx + rbs - 1); % range block
    rIdx = rIdx + rbs;
    
    %% match range block by comparing every possible domain blocks
    for batchIdx = 1:nBatch
        
        %% check reverss
        if batchIdx <= nBatch/2
            dIdx = batchIdx;
            refDat = dat(dIdx: dIdx + rbs*dScale - 1);
        else
            dIdx = batchIdx - (nBatch/2);
            refDat = revDat(dIdx: dIdx + rbs*dScale - 1);
        end
        
        %% resample domain
        D = (1/dScale) * ...
            sum( ...
            reshape(refDat, [dScale rbs] )... % reshape params
            ,1)'; % sum params, sum each column
        X(:, 2) = D; % input data
        
        % building linear problem
        % first order matrix
        X(:, 1) = EXPZERO;

        A = (X'*X) + lambda * I;
        detA = det(A);
        
        % handle if can not find solution
        % this exception only handle for n coeff == 2
        if nC ~= 2 || (nC == 2 && detA ~= 0)
            % the solution maybe found somewhere
            % Ainv = A\I; % inverse input mat
            B = X'*R; % calculate output mat
            % solve least square
            C(batchIdx, 1:nC) = (A\B)';
            
        elseif nC == 2 && (detA == 0)
            C(batchIdx, [1 2]) = [sum(R)/rbs 0];
        end
        
        % compute sum square error
        F = X * C(batchIdx, 1: nC)';
        SE = (R - F).^2;
        
        % limit coeff
        if abs(C(nC)) < 1.2
            SSE(batchIdx) = sum(SE);
        else
            SSE(batchIdx) = inf;
        end
        
    end
    % find the minimum sum square error of models
    [sseValue, minSSEIdx] = min(SSE);
    FC(fIdx,1:nC) = C(minSSEIdx,1:nC);
    if (minSSEIdx > nBatch / 2)
        minSSEIdx = -(nBatch - minSSEIdx + 2);
    end
    FC(fIdx,nC+1) = minSSEIdx;
    FC(fIdx,nC+2) = rbs;
    FC(fIdx,end) = sseValue;
    
    % buiding least square parameters
end
toc(t)
end

