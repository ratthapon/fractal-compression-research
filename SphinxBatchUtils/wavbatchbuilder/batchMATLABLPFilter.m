function batchMATLABLPFilter( fileList, inDir, outDir, nFilt, cutoff, inExt, outExt )
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
    
    % apply filter
    mask = fir1( nFilt, cutoff);
    outWave = filtfilt(mask, 1, inWave);
    
    % write output wave
    if strcmpi('raw', outExt)
        filePath = normpath([outDir '/' fileList{i} '.raw']);
        rawwrite(filePath, outWave);
    end
end

