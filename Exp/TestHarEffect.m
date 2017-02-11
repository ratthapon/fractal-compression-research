function TestHarEffect()
%DISPATCHBATCHLPFILTER MATLAB low pass filter batch dispatcher

expDirectory = 'F:\IFEFSR\ExpSphinx';
fileList = importdata( fullfile(expDirectory, 'an4traintest.txt') );
inExt = 'raw';
outExt = 'raw';

DATASET = [{'FCMATLABRBS4FS'}];
HARTPYEPREFIX = [{'PITCH1'},{'PITCH3'},{'PITCH5'}];
NHAR = [{'NHAR1'},{'NHAR10'},{'NHAR20'}];
MINPD = [{'MINPD1'},{'MINPD10'},{'MINPD20'}];
TYPEVERSION = [{'T8'}];
HARTYPE = [];
HP = buildParamsMatrix( HARTPYEPREFIX, NHAR, MINPD, TYPEVERSION );
for hpIdx = 1:size(HP, 1)
    harType = HP{hpIdx, 1};
    nHar = HP{hpIdx, 2};
    minPD = HP{hpIdx, 3};
    typeVer = HP{hpIdx, 4};
    HARTYPE{hpIdx} = [harType nHar minPD typeVer];
end

INFS = [{8}, {16}];
OUTFSFS = [{16}];

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
    elseif isempty(regexp(hartype, 'PITCH\d', 'once'))
        harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
            inFs * 1000, outFs  * 1000 );
    elseif ~isempty(regexp(hartype, 'PITCH\d', 'once'))
        nPitch = sscanf(cell2mat(regexp(hartype, 'PITCH\d+', 'match')), 'PITCH%d');
        harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
            inFs * 1000, outFs  * 1000, nPitch );
        if ~isempty(regexp(hartype, 'NHAR\d', 'once'))
            nHar = sscanf(cell2mat(regexp(hartype, 'NHAR\d+', 'match')), 'NHAR%d');
            harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
                inFs * 1000, outFs  * 1000, nPitch, nHar );
            if ~isempty(regexp(hartype, 'MINPD\d', 'once'))
                minPD = sscanf(cell2mat(regexp(hartype, 'MINPD\d+', 'match')), 'MINPD%d');
                harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
                    inFs * 1000, outFs  * 1000, nPitch, nHar, minPD );
            end
        end
    end
    batchHarmonicGeneration( fileList, inDir, outDir, harfunc, inExt, outExt );
    
end

