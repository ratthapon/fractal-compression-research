function batchMATLABMRBSDecode(  fileList, inDir, RBS, outDir, inFs, outFs, inExt, outExt  )
%BATCHMATLABMRBSDECODE Batch decode .mat files from inDir and write to outDir
%using MATLAB
%   fileList - file ids list
%   inDir - input directory
%   RBS - set of range block size
%   outDir - output directory
%   inFs - input sampling rate
%   outFs - output sampling rate
%   inExt - nput extension
%   outExt - output extension

for ids = 1:length(fileList)
    %% read code
    F = cell(1, length(RBS));
    for sIdx = 1:length(RBS)
        codePath = normpath(fullfile([inDir RBS{sIdx}], [fileList{ids} '.' inExt]));
        dat = load(codePath);
        F{sIdx} = dat.f;
    end
    
    %% decode
    [ wav ] = MultiScaleAFCDecoder(F, inFs, outFs, 15);
    
    %% write output signal
    wavPath = normpath(fullfile(outDir, 'wav', [fileList{ids} '.' outExt]));
    rawwrite( wavPath , wav);
    
end
