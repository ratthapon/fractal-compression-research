function testSphinx( expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase )
%TESTSPHINX Test speech model using Sphinx version 1.0.8

%% write cmd file
execDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4');
extractionCMD = [{ ['cd /d ' execDir] }, ...
    {'python F:/IFEFSR/Sphinx/sphinxtrain/scripts/sphinxtrain -s decode run'}];
cmdFileName = ['F:\IFEFSR\ExpSphinx\' 'A' preemAlphaStr '_' featExtractor ...
    '_' featCase '_' dataSet '_'  recogCase '_' 'an4' '_TS.bat'];
fileID = fopen(cmdFileName,'w');
fprintf(fileID,'%s\n',extractionCMD{:});
fclose(fileID);

%% set sphinx
etcPath = fullfile(execDir, 'etc', 'sphinx_train.cfg');
[ cfg ] = parseSphinxCfg( etcPath );
[ cfg ] = setSphinxCfg( cfg, 'CFG_SPHINXTRAIN_DIR', '"F:/IFEFSR/Sphinx/sphinxtrain"' );
[ cfg ] = setSphinxCfg( cfg, 'CFG_BIN_DIR', '"F:/IFEFSR/Sphinx/sphinxtrain/bin/Release"');
[ cfg ] = setSphinxCfg( cfg, 'CFG_SCRIPT_DIR', '"F:/IFEFSR/Sphinx/sphinxtrain/scripts"' );
writeSphinxCfg(cfg, etcPath);

%% launch a feature extraction
system(cmdFileName,'-echo');

end
