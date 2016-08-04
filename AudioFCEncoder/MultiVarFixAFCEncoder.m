function [ FC_QR ] = MultiVarFixAFCEncoder( sig, rangePartition, ...
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
FC_QR = zeros(nPart, nC + 3, 'single'); %ehl

% overlimit coeff indicator
for fIdx = 1:nPart % each range block
    rbs = rangePartition(fIdx);
    nBatch = (nSample - b*n+1) * 2; % calculate possible
    
    I = diag(ones(nC, 1, 'single')); % identity matrix for inversion
    EXPZERO = ones(rbs, 1, 'single'); % power zero data
    QR_SSE = zeros(nBatch, 1, 'single'); % sum square error
    QR_C = zeros(nBatch, nC, 'single'); % coefficient temp
    
    dat = sig(1: nSample); % data mat
    revDat = sig(nSample: -1: 1); % data mat
    R = dat(rIdx: rIdx + rbs - 1); % range block
    rIdx = rIdx + rbs;
    
    %% match range block by comparing every possible domain blocks
    for batchIdx = 1:nBatch
        % first order matrix
        X = EXPZERO;
        
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
            X = [X D]; % input data
        end
%         Xu = repmat(mean(X), rbs, 1);
%         Xsd = repmat(std(X), rbs, 1);
%         Xnorm = X;
%         Xnorm(:,2:end) = (X(:,2:end) - Xu(:,2:end)) ./ Xsd(:,2:end);
%         Rnorm = (R - mean(R)) / std(R);
        
        % X = (X - repmat(mean(X,2),1,nC)) ./ repmat(var(X,[],2),1,nC);
        A = (X'*X) + (lambda * I);
        detA = det(A);
        
        % handle if can not find solution
        % this exception only handle for n coeff == 2
        
        if nC ~= 2 || (nC == 2 && detA ~= 0)
            % the solution maybe found somewhere
            % Ainv = A\I; % inverse input mat
            B = X'*R; % calculate output mat
            % solve least square
            QR_C(batchIdx, 1:nC) = (A\B)';
            
        elseif nC == 2 && (detA == 0)
            QR_C(batchIdx, [1 2]) = [sum(R)/rbs 0];
        end
        
        % compute sum square error
        F = X * QR_C(batchIdx, 1: nC)';
        SE = (R - F).^2;
        
        % limit coeff
        if any(abs(QR_C(2:end)) < 1.2)
            QR_SSE(batchIdx) = sum(SE);
        else
%             QR_C(batchIdx, 1:end) = [sum(R)/rbs zeros(1, nC - 1)];
%             F = X * QR_C(batchIdx, 1: nC)';
%             SE = (R - F).^2;
            QR_SSE(batchIdx) = inf;
        end
        
    end
    %% store fractal code
    % find the minimum sum square error of models
    [sseValue, QR_minSSEIdx] = min(QR_SSE);
    FC_QR(fIdx,1:nC) = QR_C(QR_minSSEIdx,1:nC);
    % represent reverse domain map by negative domain index
    if (QR_minSSEIdx > nBatch / 2)
        QR_minSSEIdx = -(nBatch - QR_minSSEIdx + 2);
    end
    FC_QR(fIdx,nC+1) = QR_minSSEIdx;
    FC_QR(fIdx,nC+2) = rbs;
    FC_QR(fIdx,end) = sseValue;
    
end
toc(t)
end

