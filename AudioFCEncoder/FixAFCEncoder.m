function [ FC_QR ] = FixAFCEncoder( sig, rangePartition, degree, dScale, lambda )
%FIXENCODER Summary of this function goes here
%   Detailed explanation goes here

%% fix parameters
t = tic;
rIdx = 1; % start sample idx
nC = 1+1; % nCoeff
nPart = length(rangePartition);
nSample = sum(rangePartition);
FC_QR = zeros(nPart, nC + 3, 'single'); %ehl

% overlimit coeff indicator
for fIdx = 1:nPart % each range block
    rbs = rangePartition(fIdx);
    nBatch = (nSample - rbs*dScale) * 2; % calculate possible
    
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
        % resample domain
        
        if batchIdx <= nBatch/2
            dIdx = batchIdx;
            refDat = dat(dIdx: dIdx + rbs*dScale - 1);
        else
            dIdx = batchIdx - (nBatch/2);
            refDat = revDat(dIdx: dIdx + rbs*dScale - 1);
        end
        
        D = (1/dScale) * ...
            sum( ...
            reshape(refDat, [dScale rbs] )... % reshape params
            ,1)'; % sum params, sum each column
        % building linear problem
        X = [EXPZERO D]; % input data
%         X = (X - repmat(mean(X,2),1,nC)) ./ repmat(var(X,[],2),1,nC);
        A = (X'*X) + lambda * I;
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
        if abs(QR_C(nC)) < 1.2
            QR_SSE(batchIdx) = sum(SE);
        else
%             QR_C(batchIdx, 1:end) = [sum(R)/rbs zeros(1, nC - 1)];
%             F = X * QR_C(batchIdx, 1: nC)';
%             SE = (R - F).^2;
            QR_SSE(batchIdx) = inf;
        end
        
    end
    % find the minimum sum square error of models
    [sseValue, QR_minSSEIdx] = min(QR_SSE);
    FC_QR(fIdx,1:nC) = QR_C(QR_minSSEIdx,1:nC);
    if (QR_minSSEIdx > nBatch / 2) 
	   QR_minSSEIdx = -(nBatch - QR_minSSEIdx + 2);
    end
    FC_QR(fIdx,nC+1) = QR_minSSEIdx;
    FC_QR(fIdx,nC+2) = rbs;
    FC_QR(fIdx,end) = sseValue;
    
    % buiding least square parameters
end
toc(t)
end

