function [ qiLow, qiHigh, qiAll, corrLow, corrHigh, corrAll ] = lowHighIndices( spec1, spec2 )
%LOWHIGHINDICES Compare two spectrum
%   Detailed explanation goes here

spec1LowSpec = spec1(1:128, :);
spec1HighSpec = spec1(129:256, :);

spec2LowSpec = spec2(1:128, :);
spec2HighSpec = spec2(129:256, :);

qiLow = img_qi(spec1LowSpec, spec2LowSpec);
qiHigh = img_qi(spec1HighSpec, spec2HighSpec);
qiAll = img_qi(spec1, spec2);

corrLow = img_qi(spec1LowSpec, spec2LowSpec);
corrHigh = img_qi(spec1HighSpec, spec2HighSpec);
corrAll = img_qi(spec1, spec2);

end

