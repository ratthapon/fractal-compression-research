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
    outWave = harfunc(inWave);
    
    % write output wave
    if strcmpi('raw', outExt)
        filePath = normpath([outDir '/' fileList{i} '.raw']);
        rawwrite(filePath, outWave);
    end
end

