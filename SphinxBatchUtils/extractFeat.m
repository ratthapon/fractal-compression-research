function extractFeat( expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase )
%EXTRACTFEAT Summary of this function goes here
%   Detailed explanation goes here

%% write cmd file
execDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4');
extractionCMD = [{ execDir }, ...
    {'python F:/IFEFSR/Sphinx5/sphinxtrain/scripts/sphinxtrain run'}];
cmdFileName = ['F:\IFEFSR\ExpSphinx\' 'A' preemAlphaStr '_' featExtractor ...
    '_' featCase '_' dataSet '_'  recogCase '_' 'an4' '_FE.bat'];
fileID = fopen(cmdFileName,'w');
fprintf(fileID,'%s\n',extractionCMD{:});
fclose(fileID);

%% launch a feature extraction
system(cmdFileName,'-echo');

end

