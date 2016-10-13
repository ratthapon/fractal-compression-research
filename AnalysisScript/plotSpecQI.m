function [ qi ] = plotSpecQI( spec1, spec2 )
%PLOTSPECQI Summary of this function goes here
%   Detailed explanation goes here

nU = floor( size(spec1, 1)/8 );
QI = zeros(nU, 1);
for uIdx = 1:nU
    s1 = 255*mat2gray(spec1( (uIdx - 1)*8 + 1: uIdx * 8, :));
    s2 = 255*mat2gray(spec2( (uIdx - 1)*8 + 1: uIdx * 8, :));
    QI(uIdx) = img_qi(s1, s2);
end
figure, plot(QI)
