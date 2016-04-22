% label cluster
load('F:\IFEFSR\Recognition analysis\highIdx');
load('F:\IFEFSR\Recognition analysis\midIdx');
load('F:\IFEFSR\Recognition analysis\lowIdx');
load('F:\IFEFSR\Recognition analysis\allIdx');
allBandsIdx = [{highIdx},{midIdx},{lowIdx},{allIdx}];
allBandsName = [{'HIGH'},{'MID'},{'LOW'},{'ALL'}];
trainPerTestRatio = 1;
for bIdx = 1:4
    trainIdx = [];
    testIdx = [];
    trainClass = [];
    label = [];
    bandIdx = allBandsIdx{bIdx};
    u = unique(bandIdx(:,2));
    nClass = size(u,1);
    nFile = size(bandIdx,1);
    for c = 1:nClass % for each class
        sel = c:nClass:nFile;
        nSample = size(sel,2);
        if nSample >=2 % check if has samples more than 2
            selTest = sel(1,trainPerTestRatio+1:trainPerTestRatio+1:nSample);
%             selTrain = setdiff(sel,selTest);
            selTrain = sel(~ismember(sel,selTest));
            
            trainIdx = [trainIdx; selTrain'];
            trainClass = [trainClass; c*ones(size(selTrain,2),1)];
            testIdx = [testIdx; selTest'];
            label = [label; c*ones(size(selTest,2),1)];
        end
    end
    load('F:\IFEFSR\Recognition analysis\FIXED_MODEL_NECTEC','MODEL');
    MODEL = MODEL(1:nClass);
    save(['F:\IFEFSR\Recognition analysis\FIXED_MODEL_NECTEC_' allBandsName{bIdx}],'MODEL');
    save(['F:\IFEFSR\Recognition analysis\SampleIdx_' allBandsName{bIdx}...
        '_BAND'],'trainIdx','testIdx','trainClass','label');
end
