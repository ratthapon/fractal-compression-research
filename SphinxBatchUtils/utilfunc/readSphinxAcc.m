function [ nCorrectSent, nSent, nCorrectWord, nWord ] =  ...
    readSphinxAcc(  expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase  )
%READSPHINXACC Get the accuracy information from Sphinx directory

execDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4');
fid = fopen( fullfile(execDir, 'acc.txt') ,'r');
accInfo = textscan(fid, '%d','Delimiter','\n');
fclose(fid);

nCorrectSent = accInfo{1}(1);
nSent = accInfo{1}(2);
nCorrectWord = accInfo{1}(3);
nWord = accInfo{1}(4);

end

