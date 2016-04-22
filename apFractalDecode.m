function [wav] = apFractalDecode(f,wavInFs,wavOutFs,inIter)
% decode process
%% facter for reconstruction buffer, recon should equal output Fs
FsFactor = wavOutFs/wavInFs;

rec = [];
%% initial reconstruction signal
for i = 1:size(f,1)
    rec = [rec zeros(1, round(f(i,5)*FsFactor))];
end

%% specify maxiterration of reconstruction
maxIter = 15;
if length(inIter) > 0
    maxIter = inIter;
end

%% reconstruction process
for iter = 1:maxIter
    % each iter, signal should have higher consrast
    cumulativePosition = 1;
    for fIdx = 1:size(f,1)
        % for each individual code
        % retrive S,O parameter
        s = f(fIdx,1);
        o = f(fIdx,2);
        decodeFs = round(f(fIdx,5) * FsFactor);
        
        % reconstruction buffer parameter
        oddIdx = 1:2:decodeFs*2; % odd even for mean signal
        evenIdx = 2:2:decodeFs*2;

        % locate range block pointer
        rIdx = floor(f(fIdx,3)*FsFactor);
        if rIdx<=0 % exception for underflow idx
            rIdx =1;
        end
        if rIdx+decodeFs*2-1 > size(rec,2) % exception for overflow idx
            rIdx = size(rec,2) + 1 - decodeFs*2;
        end
        % create buffer for reconstruction
        subRec = rec(1,rIdx:rIdx+decodeFs*2-1);
        
        % meaning odd,even elements
        X = (subRec(:,oddIdx) + subRec(:,evenIdx)) /2;
        rec(1,cumulativePosition:cumulativePosition + decodeFs-1) = s.*X + o;
        cumulativePosition = cumulativePosition + decodeFs;
        %         rec(rec>0.17) = 0.17;
    end
end
% d = 1/norm(rec);
% wav = rec * d;
wav = rec;
% wav = (wav - mean(wav)) / std(wav);
% wav = (wav / norm(wav));
% wav = resample(rec,wavOutFs,wavOutFs);
% wav = resample(rec,wavInFs,wavOutFs); % decode to its original sampling rate

% recBound = [1:FsFactor:size(rec,2)-1 size(rec,2)];
% wav = zeros(size(recBound,2) - 1,1);
% for i = 1:size(recBound,2) - 1
%     wav(i) = mean(rec(floor(recBound(i)):ceil(recBound(i))));
% end
% audiowrite(['F:\IFEFSR\WavOut\' outSigName '_decode' num2str(wavInFs) '_to_' num2str(wavOutFs) 'fs' num2str(encodeFs) 'dStep' num2str(encodeDstep) '.wav'],rec',wavOutFs);