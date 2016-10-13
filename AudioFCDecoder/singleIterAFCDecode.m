function [ Yp ] = singleIterAFCDecode( f, alpha, Y)
%SINGLEITERAFCDECODE Decode FC only 1 iteration
%   f - fractal codes
%   alpha - FsOut/FsInt
%   Y - previous iteration data

Yp = Y;
rIdx = 1; % initial range block poiter
for fIdx = 1:size(f,1)
    % for each individual code
    % retrive S,O parameter
    a = f(fIdx, 2);
    b = f(fIdx, 1);
    dIdx = abs(f(fIdx, 3));
    reverse = f(fIdx, 3) < 0;
    
    w = ceil(f(fIdx,4) * alpha); % scaling decode buffer to
    dScale = 2; % f(fIdx,6); % domain size
    % ensure frames size should be even
    %         if mod(decodeFs,2) == 1
    %             decodeFs = decodeFs + 1;
    %         end
    
    % locate input poiter
    dIdx_p = round((dIdx - 1)*alpha + 1);
    if dIdx_p <= 0 % exception for underflow idx
        dIdx_p =1;
    end
    if dIdx_p + w*dScale - 1 > size(Y,2) % exception for overflow idx
        dIdx_p = size(Y,2) + 1 - w*dScale;
    end
    
    % create buffer for reconstruction
    d = Y(1,dIdx_p:dIdx_p + w*dScale - 1);
    if reverse
        d = d(1,end:-1:1);
    end
    
    % meaning odd,even elements / resample
    d_p = zeros(1,w);
    for xIdx = 1:size(d_p,2)
        for elem = 1:dScale
            d_p(:,xIdx) = d_p(:,xIdx) + d(:,(xIdx-1)*dScale+elem);
        end
    end
    d_p = d_p / dScale;
    %         try
    %             d_p = decimate(d, 2, 'fir');
    %         catch ex
    %
    %         end
    
    %         X = rec(1,rIdx:rIdx+decodeFs-1);
    R = a.*d_p + b;
    Yp(1,rIdx:rIdx + w - 1) = R;
    rIdx = rIdx + w; % locate next output block
end
if any(isnan(Y(:))) || any(isinf(Y(:)))
    Yp = Y;
end

