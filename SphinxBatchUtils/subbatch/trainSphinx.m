function trainSphinx( expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase )
%TRAINSPHINX Train speech model using Sphinx version 1.0.8
STEPS = [
    {'verify'}, ...
    {'ci_hmm'}, ...
    {'cd_hmm_untied'}, ...
    {'buildtrees'}, ...
    {'prunetree'}, ...
    {'cd_hmm_tied'}, ...
    {'deleted_interpolation'}
    ];
%% write cmd file
execDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4');

extractionCMD = cell(length(STEPS));
extractionCMD(1) = { ['cd /d ' execDir] };
for s = 1:length(STEPS)
    extractionCMD(s + 1) = {['python F:/IFEFSR/Sphinx/sphinxtrain/scripts/sphinxtrain -s ' ...
        STEPS{s} ' run']};
end

cmdFileName = ['F:\IFEFSR\ExpSphinx\' 'A' preemAlphaStr '_' featExtractor ...
    '_' featCase '_' dataSet '_'  recogCase '_' 'an4' '_TR.bat'];
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
system(cmdFileName);

end

