function batchMATLABResample3( fileList, inDir, outDir, inFs, outFs, inExt, outExt, nFilt, cutoff )
%BATCHMATLABRESAMPLE Batch resample raw files from inDir and write to outDir
%   fileList - general file ids list exclude directory and extension
%   inDir - input directory
%   outDir - output directory
%   inFs - input sampling rate
%   outFs - output sampling rate
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
    
    outWave = inWave;
    % apply filter
    if outFs < inFs
        mask = fir1( nFilt, cutoff);
        inWave = filtfilt(mask, 1, inWave);% resample
        outWave = resample(inWave, outFs, inFs, 0);
    end
    
    % write output wave
    if strcmpi('raw', outExt)
        filePath = normpath([outDir '/' fileList{i} '.raw']);
        rawwrite(filePath, outWave);
    end
end

