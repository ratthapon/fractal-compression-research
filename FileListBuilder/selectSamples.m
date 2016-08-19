%% this script intend to build small samples of speech signals
% read speech-paths
filePathsLoc = 'F:\IFEFSR\SpeechData\an4\an4fileids.txt';
fid = fopen(filePathsLoc,'r');
allFilePaths = textscan(fid, '%s','Delimiter','\n');
allFilePaths = allFilePaths{1};
fclose(fid);

% add prefix expression
addPrefix = @(list, prefix) cellfun( ...
    @(item) [prefix item], list, ...
    'UniformOutput', false);

nSamples = 5;
fsSet = [{''}, {'_8k'}];
% samplesIdx = floor(rand([1 nSamples]) * length(allFilePaths));
samplesIdx = [816 801 422 706 184];

for fsIdx = 1:2
    inDir = ['F:\IFEFSR\SpeechData\an4' fsSet{fsIdx} '\wav\'];
    outDir = ['F:\IFEFSR\SamplesSpeech\speech\' num2str(8 * fsIdx) '\'];
    
    subInFilePaths = addPrefix(allFilePaths(samplesIdx), regexprep(inDir,'\','/'));
    subOutFilePaths = addPrefix(allFilePaths(samplesIdx), regexprep(outDir,'\','/'));
    
    %% copy files from inDir to outDir
    for fIdx = 1:length(subInFilePaths)
        [dirPath, fileName, ext] = fileparts(subOutFilePaths{fIdx});
        mkdir(dirPath);
        copyfile(subInFilePaths{fIdx}, subOutFilePaths{fIdx});
    end
    
    fileIdsDir = ['F:\IFEFSR\SamplesSpeech\' 'ids' num2str(8 * fsIdx) '.txt'];
    fid = fopen(fileIdsDir,'w');
    fprintf(fid, '%s\r\n', allFilePaths{samplesIdx});
    fclose(fid);
end







