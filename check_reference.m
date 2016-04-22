
Fq = 16000;
FPC = 4;
load(['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly.mat']);
interCount = [];
for fIdx = 1:size(fP1,1)
    domainReference = (fIdx-1)*FPC+1:fIdx*(FPC);
    rangeReference = fP1(fIdx,3):fP1(fIdx,3)+FPC-1;
    nIntersect = size(intersect(domainReference,rangeReference),2);
    interCount = [interCount nIntersect];
end
figure(1),subplot(2,1,1),bar(interCount);sum(interCount>0)

interCount = [];
for fIdx = 1:size(fP2,1)
    domainReference = (fIdx-1)*FPC+1:fIdx*(FPC);
    rangeReference = fP2(fIdx,3):fP2(fIdx,3)+FPC-1;
    nIntersect = size(intersect(domainReference,rangeReference),2);
    interCount = [interCount nIntersect];
end
figure(1),subplot(2,1,2),bar(interCount);sum(interCount>0)