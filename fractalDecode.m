function [wav] = fractalDecode(f,wavInFs,encodeFs,encodeDstep,wavOutFs,inSignal,inIter)
% decode process
%% facter for reconstruction buffer, recon should equal output Fs
FsFactor = wavOutFs/wavInFs; 
decodeFs = ceil(encodeFs*FsFactor); % scaling decode buffer to 

% ensure frames size should be even
if mod(decodeFs,2) == 1
    decodeFs = decodeFs + 1;
end
%% check initial reconstruction signal
if length(inSignal) > 0
    rec = zeros(1,size(f,1)*decodeFs);
    [r c] = size(rec);
    rec(1,1:c) = inSignal(1,1:c);
else
    % if no input, reconstruct from zero signal
    rec = zeros(1,size(f,1)*decodeFs); % noise = sqrt(0.01)*randn(N,1);
end

%% specify maxiterration of reconstruction
maxIter = 30;
if length(inIter) > 0
    maxIter = inIter;
end
%% reconstruction buffer parameter  
oddIdx = 1:2:decodeFs*2; % odd even for mean signal
evenIdx = 2:2:decodeFs*2;
% frame bound, bounding recon buffer
frameBound = [1:decodeFs:size(rec,2) size(rec,2)+1];
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
        s = f(fIdx,1);
        o = f(fIdx,2);
        
        % locate range block pointer
        rIdx = floor(f(fIdx,3)*FsFactor);
        if rIdx<=0 % exception for underflow idx
            rIdx =1;
        end
        if rIdx+decodeFs*2-1 > size(rec,2) % exception for overflow idx
            rIdx = size(rec,2) + 1 - decodeFs*2;
        end
        % create buffer for reconstruction
        subRec = wav(1,rIdx:rIdx+decodeFs*2-1);
        
        % meaning odd,even elements
        X = (subRec(:,oddIdx) + subRec(:,evenIdx)) /2;
        Y = s.*X + o;
        Y(Y>1) = 1;
        rec(1,frameBound(fIdx):frameBound(fIdx+1)-1) = Y;
%         rec(rec>0.17) = 0.17;
    end
    if any(isnan(rec(:))) || any(isinf(rec(:)))
        break;
    else
        wav = rec; 
    end
end

% wav = resample(rec,wavOutFs,wavOutFs);
% wav = resample(rec,wavInFs,wavOutFs); % decode to its original sampling rate

% recBound = [1:FsFactor:size(rec,2)-1 size(rec,2)];
% wav = zeros(size(recBound,2) - 1,1);
% for i = 1:size(recBound,2) - 1
%     wav(i) = mean(rec(floor(recBound(i)):ceil(recBound(i))));
% end
% audiowrite(['F:\IFEFSR\WavOut\' outSigName '_decode' num2str(wavInFs) '_to_' num2str(wavOutFs) 'fs' num2str(encodeFs) 'dStep' num2str(encodeDstep) '.wav'],rec',wavOutFs);