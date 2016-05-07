function [ frameWiseCorr ] = framecorr( matA, matB )
%This function compute frame-wise correlation of matrix.
%   Detailed explanation goes here
nCol = min( size(matA, 2), size(matB, 2) );
frameWiseCorr = zeros(1, nCol);
for col = 1:nCol
    frameWiseCorr(1, col) = corr(matA(:, col), matB(:, col));
end

