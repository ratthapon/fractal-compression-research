function TestHarEffect()
%DISPATCHBATCHLPFILTER MATLAB low pass filter batch dispatcher

expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'raw';
outExt = 'raw';

DATASET = [{'BASE'}];
% RBS = [{'2'}, {'4'}];
% CUTOFF = [{0.625}];
HARTYPE = [{'ODD'}, {'EVEN'}, {'ODDEVEN'}];
INFS = [{8}, {16}];
OUTFSFS = [{8}, {16}];

P = buildParamsMatrix( DATASET, HARTYPE, INFS, OUTFSFS );
for pIdx = 1:size(P, 1)
    dataSet = P{pIdx, 1};
    hartype = P{pIdx, 2};
    inFs = P{pIdx, 3};
    outFs = P{pIdx, 4};
    
    if length(regexpi(dataSet, 'base')) > 0
        outFs = [];
    end
    
    %% MATLAB low pass filter
    %% apply low-pass filter to recon rbs n 16->16
    inDir = ['F:\IFEFSR\ExpSphinx\' dataSet num2str(inFs) num2str(outFs) '\wav'];
    outDir = fullfile(expDirectory, [dataSet hartype 'HAR' ...
        'FS' num2str(inFs) num2str(outFs) '\wav\']);
    harfunc = @addOddEvenHar;
    if strcmpi(hartype, 'ODD')
        harfunc = @addOddHar;
    elseif strcmpi(hartype, 'EVEN')
        harfunc = @addEvenHar;
    elseif strcmpi(hartype, 'ODDEVEN')
        harfunc = @addOddEvenHar;
    end
    batchHarmonicGeneration( fileList, inDir, outDir, harfunc, inExt, outExt );
    
end

