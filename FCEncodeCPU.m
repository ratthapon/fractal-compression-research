% function FC = FCEncode(signal, part, dScale, dStep)
%% !!! ALL INPUT DATA MUST ALREADY ON GPU MEMORY !!!
t = tic;
rIdx = 1; % start sample idx
nC = 1+1; % nCoeff
nPart = length(hpart);
nSample = sum(hpart);
FC_QR = zeros(nPart, nC + 3, 'single'); %ehl
% FC_INV = zeros(nPart, nC + 3, 'single'); % 
% FC_SVD_PINV = zeros(nPart, nC + 3, 'single'); % 
% FC_POLYFIT = zeros(nPart, nC + 3, 'single'); % 
% FC_DERIVERTIVE = zeros(nPart, nC + 3, 'single'); % 

% singular measure [min(svd(A)) cond(A) rcond(A) det(A)]
nDSize = round((log(max(hpart)) - log(min(hpart))) / log(2)) + 1;
% SINGULAR = {}; 

% overlimit coeff indicator
for fIdx = 1:nPart % each range block
    rbs = hpart(fIdx);
    nBatch = (nSample - rbs*dScale) * 2; % calculate possible
    
    I = diag(ones(nC, 1, 'single')); % identity matrix for inversion
    EXPZERO = ones(rbs, 1, 'single'); % power zero data
    QR_SSE = zeros(nBatch, 1, 'single'); % sum square error
    QR_C = zeros(nBatch, nC, 'single'); % coefficient temp
%     INV_SSE = zeros(nBatch, 1, 'single'); % sum square error
%     INV_C = zeros(nBatch, nC, 'single'); % coefficient temp
%     SVD_PINV_SSE = zeros(nBatch, 1, 'single'); % sum square error
%     SVD_PINV_C = zeros(nBatch, nC, 'single'); % coefficient temp
%     POLYFIT_SSE = zeros(nBatch, 1, 'single'); % sum square error
%     POLYFIT_C = zeros(nBatch, nC, 'single'); % coefficient temp
%     DERIVERTIVE_SSE = zeros(nBatch, 1, 'single'); % sum square error
%     DERIVERTIVE_C = zeros(nBatch, nC, 'single'); % coefficient temp
    
    dat = hsignal(1: nSample); % data mat
    revDat = hsignal(nSample: -1: 1); % data mat
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
        A = (X'*X) + I;
        detA = det(A);
%         partSizeIdx = (log(rbs)-log(min(hpart)))/log(2) +1;
%         SINGULAR{batchIdx,round(partSizeIdx)} = ...
%             [min(svd(A)) cond(A) rcond(A) detA]; 

        % handle if can not find solution
        % this exception only handle for n coeff == 2
        
        if nC ~= 2 || (nC == 2 && detA ~= 0)
            % the solution maybe found somewhere
            % Ainv = A\I; % inverse input mat
            B = X'*R; % calculate output mat
            % solve least square
            QR_C(batchIdx, 1:nC) = (A\B)';
%             INV_C(batchIdx, 1:nC) = (inv(A)*B)';
%             SVD_PINV_C(batchIdx, 1:nC) = (pinv(A)*B)';
%             POLYFIT_C(batchIdx, 1:nC) = polyfit(D,R,1)';
            
%             [~,msgId] = lastwarn;
        elseif nC == 2 && (detA == 0)
            %
%             QR_C(batchIdx, [1 2]) = [sum(R)/rbs 0];
            QR_C(batchIdx, [1 2]) = [sum(R)/rbs 0];
%             SVD_PINV_C(batchIdx, [1 2]) = [sum(R)/rbs 0];
%             POLYFIT_C(batchIdx, [1 2]) = [sum(R)/rbs 0];
        end
%         if QR_C(batchIdx, 2) > 0.99
%             QR_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*0.99)/rbs 0.99];
%         end
%         if QR_C(batchIdx, 2) < -0.99
%             QR_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*-0.99)/rbs -0.99];
%         end
%         if INV_C(batchIdx, 2) > 0.99
%             INV_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*0.99)/rbs 0.99];
%         end
%         if INV_C(batchIdx, 2) < -0.99
%             INV_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*-0.99)/rbs -0.99];
%         end
%         if SVD_PINV_C(batchIdx, 2) > 0.99
%             SVD_PINV_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*0.99)/rbs 0.99];
%         end
%         if SVD_PINV_C(batchIdx, 2) < -0.99
%             SVD_PINV_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*-0.99)/rbs -0.99];
%         end
%         if POLYFIT_C(batchIdx, 2) > 0.99
%             POLYFIT_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*0.99)/rbs 0.99];
%         end
%         if POLYFIT_C(batchIdx, 2) < -0.99
%             POLYFIT_C(batchIdx, [1 2]) = [(sum(R) - sum(D)*-0.99)/rbs -0.99];
%         end
        % compute sum square error
        F = X * QR_C(batchIdx, 1: nC)';
        SE = (R - F).^2;
        QR_SSE(batchIdx) = sum(SE);
        
%         F = X * INV_C(batchIdx, 1: nC)';
%         SE = (R - F).^2;
%         INV_SSE(batchIdx) = sum(SE);
        
%         F = X * SVD_PINV_C(batchIdx, 1: nC)';
%         SE = (R - F).^2;
%         SVD_PINV_SSE(batchIdx) = sum(SE);
%         
%         F = X * POLYFIT_C(batchIdx, 1: nC)';
%         SE = (R - F).^2;
%         POLYFIT_SSE(batchIdx) = sum(SE);
    end
    % find the minimum sum square error of models
    [~, QR_minSSEIdx] = min(QR_SSE);
    FC_QR(fIdx,1:nC) = QR_C(QR_minSSEIdx,1:nC);
    if (QR_minSSEIdx > nBatch / 2) 
	   QR_minSSEIdx = -(nBatch - QR_minSSEIdx + 2);
    end
    FC_QR(fIdx,nC+1) = QR_minSSEIdx;
    FC_QR(fIdx,nC+2) = rbs;
    
%     [~, INV_minSSEIdx] = min(INV_SSE);
%     FC_INV(fIdx,1:nC) = INV_C(INV_minSSEIdx,1:nC);
%     if (INV_minSSEIdx > nBatch / 2) 
% 	   INV_minSSEIdx = -(nBatch - INV_minSSEIdx + 2);
%     end
%     FC_INV(fIdx,nC+1) = INV_minSSEIdx;
%     FC_INV(fIdx,nC+2) = rbs;
    
%     [~, SVD_PINV_minSSEIdx] = min(SVD_PINV_SSE);
%     FC_SVD_PINV(fIdx,1:nC) = SVD_PINV_C(SVD_PINV_minSSEIdx,1:nC);
%     FC_SVD_PINV(fIdx,nC+1) = mod(SVD_PINV_minSSEIdx,nBatch/2)*((-1)^(floor(SVD_PINV_minSSEIdx/(nBatch/2))));
%     FC_SVD_PINV(fIdx,nC+2) = rbs;
    
%     [~, POLYFIT_minSSEIdx] = min(POLYFIT_SSE);
%     FC_POLYFIT(fIdx,1:nC) = POLYFIT_C(POLYFIT_minSSEIdx,1:nC);
%     FC_POLYFIT(fIdx,nC+1) = mod(POLYFIT_minSSEIdx,nBatch/2)*((-1)^(floor(POLYFIT_minSSEIdx/nBatch/2)));
%     FC_POLYFIT(fIdx,nC+2) = rbs;
    
    % buiding least square parameters
end
toc(t)
% save('F:\IFEFSR\LS_ANALYZE\ws2');

% figure,plot([FC_SVD_PINV(:,1) FC_INV(:,1) FC_QR(:,1) FC_POLYFIT(:,1)]);
% figure,plot([FC_SVD_PINV(:,2) FC_INV(:,2) FC_QR(:,2) FC_POLYFIT(:,2)]);
% sumSingularElement = zeros(6, 4);
% rangeSize = [4 8 16 32 64 128];
% for psIdx = [1:4 6]
%     rbs = rangeSize(psIdx);
%     nBatch = (nSample - rbs*dScale - 4) * 2; % calculate possible
%     for dIdx = 1:nBatch
%         if (SINGULAR{dIdx,psIdx}(1) - 1) <= eps
%             sumSingularElement(psIdx, 1) = sumSingularElement(psIdx, 1) + 1;
%         end
%         if (SINGULAR{dIdx,psIdx}(2) > 1e6)
%             sumSingularElement(psIdx, 2) = sumSingularElement(psIdx, 2) + 1;
%         end
%         if (SINGULAR{dIdx,psIdx}(3) < 1e-6)
%             sumSingularElement(psIdx, 3) = sumSingularElement(psIdx, 3) + 1;
%         end
%         if (SINGULAR{dIdx,psIdx}(4)) <= 1e-5
%             sumSingularElement(psIdx, 4) = sumSingularElement(psIdx, 4) + 1;
%         end
%     end
% end

%%
% QR_SIG = decompressAudioFCWithTime(FC_QR,8000,16000,[]);
QR_SIG = decompressAudioFC(FC_QR,8000,16000,20);
b1 = fir1(8,0.4);
QR_SIG = filtfilt(b1,1,QR_SIG);       % Zero-phase digital filtering
% INV_SIG = decompressAudioFC(FC_INV,16000,16000,[]);
% SVD_PINV_SIG = decompressAudioFC(FC_SVD_PINV,16000,16000,[]);
% POLYFIT_SIG = decompressAudioFC(FC_POLYFIT,16000,16000,[]);
figure(2);
hold on
subplot(5,1,1),plot(hsignal);
hold on
stem(hsignal);
axis([1 32 -20 20])
subplot(5,1,2),plot(QR_SIG); stem(QR_SIG);
axis([1 64 -20 20])
% subplot(5,1,3),plot(INV_SIG);
% subplot(5,1,4),plot(SVD_PINV_SIG);
% subplot(5,1,5),plot(POLYFIT_SIG);
% save('F:\IFEFSR\LS_ANALYZE\ws2');

