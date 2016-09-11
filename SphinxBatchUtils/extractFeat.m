function extractFeat( expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase )
%EXTRACTFEAT Feature extraction using Sphinx version 5 prealpha

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

%% set sphinx
etcPath = fullfile(execDir, 'etc', 'sphinx_train.cfg');
[ cfg ] = parseSphinxCfg( etcPath );
[ cfg ] = setSphinxCfg( cfg, 'CFG_SPHINXTRAIN_DIR', '"F:/IFEFSR/Sphinx5/sphinxtrain"' );
[ cfg ] = setSphinxCfg( cfg, 'CFG_BIN_DIR', '"F:/IFEFSR/Sphinx5/sphinxtrain/bin/Release"');
[ cfg ] = setSphinxCfg( cfg, 'CFG_SCRIPT_DIR', '"F:/IFEFSR/Sphinx5/sphinxtrain/scripts"' );
writeSphinxCfg(cfg, etcPath);

%% launch a feature extraction
system(cmdFileName,'-echo');

end

