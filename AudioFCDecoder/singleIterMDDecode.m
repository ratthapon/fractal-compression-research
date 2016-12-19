function [ Yp ] = singleIterMDDecode( f, alpha, dScale, rScale, h, cenAlign, Y)
%SINGLEITERMDDECODE Decode multi domains FC only 1 iteration
%   f - fractal codes
%   alpha - FsOut/FsInt
%   Y - previous iteration data

nCoeff = size(f, 2) - 3;
nD = nCoeff - 1;
Yp = Y;
rIdx = 1; % initial range block poiter
for fIdx = 1:size(f,1)
    % for each individual code
    % retrive coefficients
    C = f(fIdx, 1:nCoeff);
    dIdx = abs(f(fIdx, nCoeff + 1));
    reverse = f(fIdx, nCoeff + 1) < 0;
    
    w = ceil(f(fIdx, nCoeff + 2) * alpha); % scaling decode buffer to
    
    % create buffer for reconstruction
    d_p = zeros( nCoeff, w);
    d_p( 1, :) = 1;
    for dn = 1:nD
        % locate input poiter
        dIdx_p = round((dIdx - 1)*alpha + 1);
        sumScale = 0;
        dnScale = dScale ^ (h * (dn - 1) + 1);
        for k = 1:(dn - 1)
            dnScale = dScale ^ (h * (k - 1) + 1);
            sumScale = sumScale + dnScale;
        end
        dnIdx = dIdx_p + w * sumScale;
        if cenAlign
            dnIdx = dIdx_p + w/2 * (1 - dnScale);
        end
        
        for ds = 0:dnScale-1
            for i = 1:w
                datIdx = dnIdx + ds + (i-1)*dnScale;
                revDatIdx = dnIdx + ((w*dnScale) - (ds + (i-1)*dnScale) - 1);
                if datIdx <= size(Yp, 2) && datIdx > 0 && revDatIdx <= size(Yp, 2) && revDatIdx > 0
                    if ~reverse
                        d_p(dn + 1, i) = d_p(dn + 1, i) + Y(1, datIdx);
                    else
                        d_p(dn + 1, i) = d_p(dn + 1, i) + Y(1, revDatIdx);
                    end
                end
            end
        end
        d_p(dn + 1, :) = d_p(dn + 1, :) / dnScale;
    end
    
    R = C * d_p;
    Yp(1, rIdx:rIdx + w - 1) = R;
    rIdx = rIdx + w; % locate next output block
end
if any(isnan(Y(:))) || any(isinf(Y(:)))
    Yp = Y;
end

