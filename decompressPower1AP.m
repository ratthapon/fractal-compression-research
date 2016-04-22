function [wav] = decompressPower1(f,wavInFs,wavOutFs,inIter)
% decode process
%% facter for reconstruction buffer, recon should equal output Fs
FsFactor = wavOutFs/wavInFs;

%% check initial reconstruction signal
rec = zeros(1,sum(f(:,5)*FsFactor)); 

%% specify maxiterration of reconstruction
maxIter = 30;
if ~isempty(inIter)
    maxIter = inIter;
end

wav = rec;
%% reconstruction process
for iter = 1:maxIter
    % each iter, signal should have higher consrast
    rIdx = 1; % initial range block poiter
    for fIdx = 1:size(f,1)
        % for each individual code
        % retrive S,O parameter
        a = f(fIdx,1);
        b = f(fIdx,2);
        reverse = f(fIdx,3);
        dIdx = f(fIdx,4);
        decodeFs = ceil(f(fIdx,5)*FsFactor); % scaling decode buffer to
        % ensure frames size should be even
        if mod(decodeFs,2) == 1
            decodeFs = decodeFs + 1;
        end
        oddIdx = 1:2:decodeFs*2; % odd even for mean signal
        evenIdx = 2:2:decodeFs*2;
        
        % locate input poiter
        scaleDIdx = ceil(dIdx*FsFactor);
        if scaleDIdx <= 0 % exception for underflow idx
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
        rec(1,rIdx:rIdx + decodeFs - 1) = Y;
        rIdx = rIdx + decodeFs; % locat next output block
    end
    if any(isnan(rec(:))) || any(isinf(rec(:)))
        break;
    else
        wav = rec/norm(rec);
    end
    %     figure(3),plot(wav(1,1:300));
end


