function TestHarEffect()
%DISPATCHBATCHLPFILTER MATLAB low pass filter batch dispatcher

expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'raw';
outExt = 'raw';

DATASET = [{'FCMATLABRBS4FS'}];
HARTPYEPREFIX = [{'PITCH5'}];
NHAR = [{'NHAR20'}];
MINCD = [{'MINCD3'}];
MINHD = [{'MINHD5'}];
EXCLUDEORIGIN = [{'EXCLUDEORIGIN'}, {'INCLUDEORIGIN'}];
TYPEVERSION = [{'T91'}];
HARTYPE = [];
HP = buildParamsMatrix( EXCLUDEORIGIN, HARTPYEPREFIX, NHAR, MINCD, MINHD, TYPEVERSION );
for hpIdx = 1:size(HP, 1)
    excludeOrigin = HP{hpIdx, 1};
    harType = HP{hpIdx, 2};
    nHar = HP{hpIdx, 3};
    minCD = HP{hpIdx, 4};
    minHD = HP{hpIdx, 5};
    typeVer = HP{hpIdx, 6};
    HARTYPE{hpIdx} = [harType nHar minCD minHD excludeOrigin typeVer];
end

INFS = [{8}, {16}];
OUTFSFS = [{16}];

P = buildParamsMatrix( DATASET, HARTYPE, INFS, OUTFSFS );
parfor pIdx = 1:size(P, 1)
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
    if strcmpi(hartype, 'ODD1')
        harfunc = @(in) addOddHar(in, 1, 1.0);
    elseif strcmpi(hartype, 'ODD2')
        harfunc = @(in) addOddHar(in, 2, 1.0);
    elseif strcmpi(hartype, 'ODD3')
        harfunc = @(in) addOddHar(in, 3, 1.0);
    elseif strcmpi(hartype, 'EVEN')
        harfunc = @addEvenHar;
    elseif strcmpi(hartype, 'ODDEVEN')
        harfunc = @addOddEvenHar;
    elseif ~isempty(regexp(hartype, 'PITCH\d', 'once'))
        nPitch = 1;
        nHar = 1;
        minCD = 1;
        minHD = 1;
        exclude = true;
        
        nPitch = sscanf(cell2mat(regexp(hartype, 'PITCH\d+', 'match')), 'PITCH%d');
        if ~isempty(regexp(hartype, 'NHAR\d', 'once'))
            nHar = sscanf(cell2mat(regexp(hartype, 'NHAR\d+', 'match')), 'NHAR%d');
        end
        if ~isempty(regexp(hartype, 'MINCD\d', 'once'))
            minCD = sscanf(cell2mat(regexp(hartype, 'MINCD\d+', 'match')), 'MINCD%d');
        end
        if ~isempty(regexp(hartype, 'MINHD\d', 'once'))
            minHD = sscanf(cell2mat(regexp(hartype, 'MINHD\d+', 'match')), 'MINHD%d');
        end
        if ~isempty(regexp(hartype, 'EXCLUDEORIGIN', 'once'))
            exclude = true;
        end
        if ~isempty(regexp(hartype, 'INCLUDEORIGIN', 'once'))
            exclude = false;
        end
        harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
            inFs * 1000, outFs  * 1000, ...
            'npitch', nPitch, 'nhar', nHar, 'mincd', minCD, 'minhd', minHD, ...
            'enableexcludeorigin', exclude);
    end
    batchHarmonicGeneration( fileList, inDir, outDir, harfunc, inFs, outFs, inExt, outExt );
    
end

