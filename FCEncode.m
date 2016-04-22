% function FC = FCEncode(signal, part, dScale, dStep)
%% !!! ALL INPUT DATA MUST ALREADY ON GPU MEMORY !!!
rIdx = 1; % start sample idx
nC = 2; % nCoeff
nPart = length(part);
nSample = sum(part);
FC = gpuArray(zeros(nPart, nC + 3, 'single'));
for fIdx = 1: 1 %nPart % each range block
    rbs = gather(part(fIdx));
    nBatch = gather((nSample - rbs*dScale - 4)) * 2; % calculate possible
    
    I = gpuArray(diag(ones(nC, 1, 'single'))); % identity matrix for inversion
    EXPZERO = gpuArray(ones(rbs, 1, 'single')); % power zero data
    SSE = gpuArray(zeros(nBatch, 1, 'single')); % sum square error
    C = gpuArray(zeros(nBatch, nC, 'single')); % coefficient temp
    
    dat = signal(gpuArray.colon(1, nSample)); % data mat
    revDat = signal(gpuArray.colon(nSample, -1, 1)); % data mat
    R = dat(gpuArray.colon(rIdx, rIdx + rbs - 1)); % range block
    rIdx = rIdx + rbs;
    
    %% match range block by comparing every possible domain blocks
    for batchIdx = 1:gather(nBatch)
        % resample domain
        
        if batchIdx <= nBatch/2
            dIdx = batchIdx;
            refDat = dat(gpuArray ...
                .colon(dIdx, dIdx + rbs*dScale - 1));
        else
            dIdx = batchIdx - (nBatch/2);
            refDat = revDat(gpuArray ...
                .colon(dIdx, dIdx + rbs*dScale - 1));
        end
        
        D = (1/dScale) * ...
            sum( ...
            reshape(refDat, [dScale rbs] )... % reshape params
            ,1)'; % sum params, sum each column
        % building linear problem
        X = [D EXPZERO]; % input data
        A = (X'*X);
        
        % handle if can not find solution
        % this exception only handle for n coeff == 2
        detA = det(A);
        if nC ~= 2 || (nC == 2 && detA ~= 0)
            % the solution maybe found somewhere
            % Ainv = A\I; % inverse input mat
            B = X'*R; % calculate output mat
            % solve least square
            cIdx = gpuArray.colon(1, nC);
            C(batchIdx, cIdx) = (A\B)';
        elseif nC == 2 && (det(A) == 0)
            %
            C(batchIdx, [1 2]) = [0 sum(R)/rbs];
        end
        % compute sum square error
        F = X*C(batchIdx, gpuArray.colon(1, nC))';
        SE = (R - F).^2;
        SSE(batchIdx) = sum(SE);
    end
    % find the minimum sum square error of models
    [~, minSSEIdx] = min(SSE);
    
    % buiding least square parameters
end