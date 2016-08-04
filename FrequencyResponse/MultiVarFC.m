function [ REC_SIG ] = MultiVarFC( sig, nScale, rbs, lambda )
%MULTISCALEFC Summary of this function goes here
%   Detailed explanation goes here
%%

rangePartition = rbs*ones(size(sig, 1)/rbs, 1);
multiVarFC = MultiVarFixAFCEncoder( sig, rangePartition, ...
    1, lambda, nScale, rbs );

REC_SIG = MultiVarFixAFCDecoder(multiVarFC, 8000, 16000, 15);


%%