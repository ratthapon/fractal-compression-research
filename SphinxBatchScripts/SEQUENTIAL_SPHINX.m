%% setup exp directory
outDir = [outPrefix expCase '/' featExtractor '/' dataCase '/'  ...
    dataSet '/A' alphaStr '/an4']
mkdir(outDir);

%% coppy configure
etcPath = 'F:/IFEFSR/ExpSphinx/etc/';
copyfile(etcPath, [outDir '/etc/'], 'f');

%% config feature extraction
globalCFG = featCFG;
SPHINX_TRAIN_CFG;

%% write cmd file
extractionCMD = [{['cd /d ' outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4']},...
    {'python F:/IFEFSR/Sphinx5/sphinxtrain/scripts/sphinxtrain run'}];
cmdFileName = ['F:\IFEFSR\ExpSphinx\Sphinx5Feat_' expCase '_' dataCase '_' dataSet '_' alphaStr '_FE.bat'];
fileID = fopen(cmdFileName,'w');
fprintf(fileID,'%s\n',extractionCMD{:});
fclose(fileID);

%% launch a feature extraction
system(cmdFileName,'-echo');

%% config feature extraction
globalCFG = trainingCFG;
SPHINX_TRAIN_CFG;

%% write cmd file
trainingCMD = [{['cd /d ' outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4']},...
    {'python F:/IFEFSR/Sphinx/sphinxtrain/scripts/sphinxtrain run'}];
cmdFileName = ['F:\IFEFSR\ExpSphinx\Sphinx5Feat_' expCase '_' dataCase '_' dataSet '_' alphaStr '_TR.bat'];
fileID = fopen(cmdFileName,'w');
fprintf(fileID,'%s\n',trainingCMD{:});
fclose(fileID);

%% launch a asr training
system(cmdFileName,'-echo');

