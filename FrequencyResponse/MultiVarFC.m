function [ REC_SIG ] = MultiVarFC( sig, nScale, rbs, Fin_out, lambda )
%MULTISCALEFC Summary of this function goes here
%   Detailed explanation goes here
%%

rangePartition = rbs*ones(size(sig, 1)/rbs, 1);
multiVarFC = MultiVarFixAFCEncoder( sig, rangePartition, ...
    1, lambda, nScale, rbs );

REC_SIG = MultiVarFixAFCDecoder(multiVarFC, Fin_out(1), Fin_out(2), 15);


%%