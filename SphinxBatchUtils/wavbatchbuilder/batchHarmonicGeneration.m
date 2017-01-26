function batchHarmonicGeneration( fileList, inDir, outDir, harfunc, inExt, outExt )
%BATCHMATLABRESAMPLE Batch resample raw files from inDir and write to outDir
%   fileList - general file ids list exclude directory and extension
%   inDir - input directory
%   outDir - output directory 
%   harfunc - harmonic function
%   inExt - nput extension
%   outExt - output extension

n = length(fileList);
for i = 1:n
    % read input wave
    inWave = [];
    if strcmpi('raw', inExt)
        filePath = normpath([inDir '/' fileList{i} '.raw']);
        inWave = rawread(filePath);
    end
    
    % gen harmonic
    [normWave, mu, sd] = zscore(inWave);
    if isempty(regexpi(outDir, 'pitch'))
        outWave = harfunc(normWave) * sd + mu;
    else
        originSpeech = [];
        if strcmpi('raw', inExt)
            inWavePath = normpath(char(strcat('F:/IFEFSR/ExpSphinx/BASE8/wav/', fileList{i}, '.raw')));
            originSpeech = rawread(inWavePath);
        end
        [normOriginWave, ~, ~] = zscore(originSpeech);
        outWave = harfunc(normOriginWave, normWave) * sd + mu;
    end
    
    % write output wave
    if strcmpi('raw', outExt)
        filePath = normpath([outDir '/' fileList{i} '.raw']);
        rawwrite(filePath, outWave);
    end
end

