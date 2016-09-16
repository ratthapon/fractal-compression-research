function batchMATLABDecode( fileList, inDir, outDir, inFs, outFs, inExt, outExt )
%BATCHMATLABDECODE Batch decode .mat files from inDir and write to outDir
%using MATLAB
%   fileList - file ids list 
%   inDir - input directory
%   outDir - output directory
%   inFs - input sampling rate
%   outFs - output sampling rate
%   inExt - nput extension
%   outExt - output extension

for ids = 1:length(fileList)
    %% read code
    codePath = normpath(fullfile(inDir, [fileList{ids} '.' inExt]));
    dat = load(codePath);
    
    %% decode 
    wav = AFCDecode(dat.f, inFs, outFs, 15);
    
    %% write output signal
    wavPath = normpath(fullfile(outDir, [fileList{ids} '.' outExt]));
    rawwrite( wavPath , wav);
    
end

