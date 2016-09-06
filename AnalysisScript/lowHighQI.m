function [ qiLow, qiHigh ] = lowHighQI( reconSig, originSig )
%LOWHIGHQI Summary of this function goes here
%   Detailed explanation goes here
reconSig = reconSig(:);
originSig = originSig(:);

reconSpec = abs(fft(reconSig, 256));
reconLowSpec = reconSpec(1:128, :);
reconHighSpec = reconSpec(129:256, :);

originSpec = abs(fft(originSig, 256));
originLowSpec = originSpec(1:128, :);
originHighSpec = originSpec(129:256, :);

qiLow = img_qi(reconLowSpec, originLowSpec);
qiHigh = img_qi(reconHighSpec, originHighSpec);

qiLow = corr(reconLowSpec, originLowSpec);
qiHigh = corr(reconHighSpec, originHighSpec);

end

