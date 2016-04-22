% AN4 PSNR
%% wav coppy
% % an4 decoder
target = 'F:\IFEFSR\ExpSphinx\FC1616\wav\';
test = 'F:\IFEFSR\ExpSphinx\FC816\wav\';
fileList = importdata('F:\IFEFSR\AudioFC\an4traintest.txt');
psnrValues = zeros(size(fileList,1),1);

fromto = [1 size(fileList,1)];
for i = fromto(1):fromto(2)
    inFName = [target fileList{i} '.raw'];
    fid = fopen(inFName, 'r');
    sigTarget = fread(fid, 'int16')/(2^15);
    fclose(fid);
    
    inFName = [test fileList{i} '.raw'];
    fid = fopen(inFName, 'r');
    sigTest = fread(fid, 'int16')/(2^15);
    fclose(fid);
    
    psnrValues(i) = PSNR(sigTest,sigTarget);
    
end














