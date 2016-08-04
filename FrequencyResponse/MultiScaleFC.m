function [ REC_SIG ] = MultiScaleFC( sig, RBSs, Fin_out, lambda )
%MULTISCALEFC Summary of this function goes here
%   Detailed explanation goes here

multiScaleFC = cell(size(RBSs));
for rbsIdx = 1:length(RBSs)
    rbs = RBSs(rbsIdx);
    rangePartition = rbs*ones(size(sig, 1)/rbs, 1);
    FC_QR = FixAFCEncoder( sig, rangePartition, 1, 2, lambda );
    multiScaleFC(rbsIdx) = {FC_QR};
end

REC_SIG = MultiScaleAFCDecoder(multiScaleFC, Fin_out(1), Fin_out(2), 15);
