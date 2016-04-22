function [loglike,ESTTR,statesPath]= myviterbi(ObSeq,trans,logEmit)

% allocate delta
logTrans = log(trans);
% [~,logEmit] = pdf(GMM,ObSeq');
% [logEmit] = pdf(GMM,ObSeq');
% logEmit = logEmit';
stateSize = size(trans,1);
seqLen = size(ObSeq,2);
delta = zeros(stateSize,seqLen);
Prior = zeros(stateSize,1);
Prior(1,1) = 1;
logPrior = log(Prior);%(1/stateSize));
% delta(:,1) = logPrior + logEmit(:,seq(1));
delta(:,1) = logPrior + logEmit(:,1);

currentStates = zeros(stateSize,seqLen);
[~,maxPrevState] = max(delta(:,1));
currentStates(:,1) = maxPrevState;

ESTTR = zeros(size(trans));
statesPath = zeros(1,seqLen);
for n=2:seqLen
    % for each transition from
    for s=1:stateSize
        [maxLL,maxPrevState] = max(logTrans(:,s) + delta(:,n-1));
        delta(s,n)  = maxLL  + logEmit(s,n);
        currentStates(s,n) = maxPrevState;
    end
end
[~,maxLastState] = max(delta(:,end));
statesPath(1,end) = maxLastState;
for n=seqLen-1:-1:1
    statesPath(1,n) = currentStates(statesPath(1,n+1),n);
end
for n=2:seqLen
    ESTTR(statesPath(1,n-1),statesPath(1,n)) = ESTTR(statesPath(1,n-1),statesPath(1,n)) + 1;
end
ESTTR = ESTTR ./ repmat(sum(ESTTR,2),1,stateSize);
[loglike ] = max(delta(:,end));
