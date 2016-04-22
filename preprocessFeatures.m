% preprocessFeatures

load('C:\Project\IFEFSR\MData\fs32dstep1\fData.mat');
X = fData; % raw features
ZMfData = {};
warning = [];
for i=1:size(fData,1)
    x = fData{i};
    if size(x,1) > 4000
        warning = [warning i];
    end
    dataZM = (x - (ones(size(x,1),1)*mean(x)))./(ones(size(x,1),1)*std(x));
    ZMfData(i,1) = {dataZM};
end
save('C:\Project\IFEFSR\MData\ZMfData32fs1dstep.mat' ,'ZMfData');