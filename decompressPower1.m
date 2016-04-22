function [wav] = decompressPower1(f,wavInFs,encodeFs,wavOutFs,inIter)
% decode process
%% facter for reconstruction buffer, recon should equal output Fs
FsFactor = wavOutFs/wavInFs;
decodeFs = ceil(encodeFs*FsFactor); % scaling decode buffer to

% ensure frames size should be even
if mod(decodeFs,2) == 1
    decodeFs = decodeFs + 1;
end
%% check initial reconstruction signal
% if length(inSignal) > 0
%     rec = zeros(1,size(f,1)*decodeFs);
%     [r c] = size(rec);
%     rec(1,1:c) = inSignal(1,1:c);
% else
% if no input, reconstruct from zero signal
rec = zeros(1,size(f,1)*decodeFs); % noise = sqrt(0.01)*randn(N,1);
% end

%% specify maxiterration of reconstruction
maxIter = 30;
if length(inIter) > 0
    maxIter = inIter;
end

%% for adaptive partition data
adaptivePartition = false;
if size(f,2) > 4
    adaptivePartition = true;
end

%% reconstruction buffer parameter
oddIdx = 1:2:decodeFs*2; % odd even for mean signal
evenIdx = 2:2:decodeFs*2;
% frame bound, bounding recon buffer
rangeIdx = [1:decodeFs:size(rec,2) size(rec,2)+1];
if decodeFs <= 1
    oddIdx = 1:2:1*2;
    evenIdx = 2:2:1*2;
end
wav = rec;
%% reconstruction process
for iter = 1:maxIter
    % each iter, signal should have higher consrast
    for fIdx = 1:size(f,1)
        % for each individual code
        % retrive S,O parameter
        a = f(fIdx,1);
        b = f(fIdx,2);
        reverse = f(fIdx,3);
        dIdx = f(fIdx,4);
        
        % locate range block pointer
        scaleDIdx = floor(dIdx*FsFactor);
        if scaleDIdx<=0 % exception for underflow idx
            scaleDIdx =1;
        end
        if scaleDIdx+decodeFs*2-1 > size(rec,2) % exception for overflow idx
            scaleDIdx = size(rec,2) + 1 - decodeFs*2;
        end
        % create buffer for reconstruction
        subRec = wav(1,scaleDIdx:scaleDIdx+decodeFs*2-1);
        if reverse
            subRec = subRec(1,end:-1:1);
        end
        
        % meaning odd,even elements
        X = (subRec(:,oddIdx) + subRec(:,evenIdx)) /2;
        %         X = rec(1,rIdx:rIdx+decodeFs-1);
        Y = a.*X + b;
        Y(Y>1) = 1;
        rec(1,rangeIdx(fIdx):rangeIdx(fIdx+1)-1) = Y;
        %         rec(rec>0.17) = 0.17;
        
    end
    if any(isnan(rec(:))) || any(isinf(rec(:)))
        break;
    else
        wav = rec;
    end
%     figure(3),plot(wav(1,1:300));
end

% wav = resample(rec,wavOutFs,wavOutFs);
% wav = resample(rec,wavInFs,wavOutFs); % decode to its original sampling rate

% recBound = [1:FsFactor:size(rec,2)-1 size(rec,2)];
% wav = zeros(size(recBound,2) - 1,1);
% for i = 1:size(recBound,2) - 1
%     wav(i) = mean(rec(floor(recBound(i)):ceil(recBound(i))));
% end
% audiowrite(['F:\IFEFSR\WavOut\' outSigName '_decode' num2str(wavInFs) '_to_' num2str(wavOutFs) 'fs' num2str(encodeFs) 'dStep' num2str(encodeDstep) '.wav'],rec',wavOutFs);