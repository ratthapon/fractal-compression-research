
%Number of Gaussian component densities
%   M = 8;
%   model = gmdistribution.fit(MFCCtraindata,M);
% 
% 
% [seq,states] = hmmgenerate(len,TRANS,EMIS);
% [TRANS,EMIS] = hmmestimate(seq,states);
% [ESTTR,ESTEMIT] = hmmtrain(seq,TRGUESS,EMITGUESS);
% STATES = hmmviterbi(seq,TRANS,EMIS);
% hmmdecode
% 
% 
% tr = [0.95,0.05;
%     0.10,0.90];
% 
% e = [1/6,  1/6,  1/6,  1/6,  1/6,  1/6;
%     1/10, 1/10, 1/10, 1/10, 1/10, 1/2;];
% 
% [seq, states] = hmmgenerate(100,tr,e);
% 
% [seq, states] = hmmgenerate(100,tr,e,'Symbols',...
%     {'one','two','three','four','five','six'},...
%     'Statenames',{'fair';'loaded'});
% 
% stateName = {'Sunny';'Rainy';'Foggy'};
% transition = [0.8 0.05 0.15;
%               0.2 0.6 0.2;
%               0.2 0.3 0.5];
% emission = [0.1 0.9;
%             0.8 0.2;
%             0.3 0.7];
% [PSTATES, LOGPSEQ] = hmmdecode([2 2 2 1 1],transition,emission);
% [currentState, logP] = hmmviterbi([2 2 2 1 1],transition,emission);
%         
% [seq, states] = hmmgenerate(100,transition,emission);
% 
% 
% [seq, states] = hmmgenerate(100,transition,emission);
% [estimateTR, estimateE] = hmmestimate(seq,states);
% 
% seq = [1 1 1];
% states = [1 2 3];
% [estimateTR, estimateE] = hmmestimate(seq,states);
% 
% X = MFCCs(:,1);
% re = pdf(gmm,X');


transition = [0.6 0.4 0;
              0 0.6 0.4;
              0 0.6 .4];
emission = [0.5 0.5;
            0.4 0.6;
            0.3 0.7];
[seq] = hmmgenerate(10,transition,emission);
%  seq = [2 1 1];
% load seq;
seq = [2 1 1 2 2 1 2 1 2 1 2];
[PSTATES, LOGPSEQ] = hmmdecode(seq,transition,emission);
[maxVal resultIdx] = max(PSTATES);
[currentState, logP ] = hmmviterbi(seq,transition,emission);
[statepath ,myloglike ] = myviterbi(seq,transition,emission);
cmpStatePath = [resultIdx;currentState;statepath];
state_seq = currentState;
ob_seq = seq;
prev = state_seq(1);
prob_seq = 1;
for i=1:size(ob_seq,2)
    prob_seq(i) = transition(prev,state_seq(i)) * emission(state_seq(i),ob_seq(i));
    prev = state_seq(i);
end

% pdf(GMM,MFCCs)
