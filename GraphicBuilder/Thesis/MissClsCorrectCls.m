expDir = 'F:\IFEFSR\ExpSphinx\';
dirO8 = 'BASE8';
dirO16 = 'BASE16';
dirAFCD = 'FCMATLABRBS4FS';
dirFCD = 'FCMATLABRBS4FS';
dirHFCD = 'FCMATLABRBS4FSPITCH3NHAR20MINCD1MINHD10INCLUDEORIGINT9HARFS';
nPitch = 3;
nHar = 20;
minCD = 1;
minHD = 10;
exclude = false;
harfunc = @(originSig, sig) addHarToSigFromCeps( originSig, sig, ...
    16 * 1000, 16  * 1000, ...
    'npitch', nPitch, 'nhar', nHar, 'mincd', minCD, 'minhd', minHD, ...
    'enableexcludeorigin', exclude);
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);

sampleIdx = 30:30;
fpO8 = normpath([expDir 'BASE8' '\wav\' fileList{sampleIdx} '.raw']);
fpO16 = normpath([expDir 'BASE16' '\wav\' fileList{sampleIdx} '.raw']);
fpFCD816 = normpath([expDir dirFCD '816\wav\' fileList{sampleIdx} '.raw']);
fpHFCD816 = normpath([expDir dirHFCD '816\wav\' fileList{sampleIdx} '.raw']);

filteredWordList = [];

%% Different sampling rate
% extract the informations

%% missclass functions
thresh = 0;
accRate = @(result) result(2) / result(1);
readResult = @(record) sscanf(record, 'Words: %d Correct: %d Errors: %d');
isMissClass = @(record) thresh >= accRate(readResult(record)); % test function
isCorrectClass = @(record) 1-thresh <= accRate(readResult(record)); % test function

expDir = 'F:\IFEFSR\ExpSphinx\';
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);
errorRelation = @union;
% errorRelation = @intersect;
% errorRelation = @setdiff;
% errorRelation = @(expError, baseError) expError;

%% define sets of parameters
EXP = [{'F:/IFEFSR/ExpSphinx'}];
PREEMP = [{'97'}];
FEATEXTRACTOR = [{'Sphinx5FE'}];
FEATCASE = [ {'caseB'}];
NOTES = [{'Frequency harmonic'}, {'Half harmonic filter t7.0'}, {'Exponential mag filter'},...
    {'N harmonic filter'}, {'Fix pitches sorting'}, {'n-th oder harmonic'}, {'n-pitch'}];

%% build dataSet matrix
PREFIX = [{'FCMATLABRBS4FS'}];
HARTPYEPREFIX = [{'PITCH3'}];
NHAR = [{'NHAR20'}];
MINCD = [{'MINCD1'}];
MINHD = [{'MINHD10'}];
EXCLUDEORIGIN = [{'INCLUDEORIGIN'}];
TYPEVERSION = [{'T9'}];
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

% % build harmonic dataset
HAR_P = buildParamsMatrix(PREFIX, HARTYPE);
DATASET_WITH_HAR = cell(size(HAR_P, 1), 1);
for setIdx = 1:size(HAR_P, 1)
    DATASET_WITH_HAR{setIdx} = [HAR_P{setIdx, 1} HAR_P{setIdx, 2} 'HARFS'];
end

% build no harmonic dataset
BASE = [PREFIX];

% DATASET = [DATASET_NO_HAR; DATASET_WITH_HAR];
DATASET = [DATASET_WITH_HAR];

RECOGCASE = [{'cross'}];
P = buildParamsMatrix( EXP, PREEMP, FEATEXTRACTOR, ...
    FEATCASE, DATASET, RECOGCASE);

%% iterate for each parameters combination
for expIdx = 1:size(P, 1)
    expDirPrefix = P{expIdx, 1};
    preemAlphaStr = P{expIdx, 2};
    featExtractor = P{expIdx, 3};
    featCase = P{expIdx, 4};
    dataSet = P{expIdx, 5};
    recogCase = P{expIdx, 6};
    
    %% read result record
    alignFile = 'result\an4.align';
    fileList  = importdata('F:\IFEFSR\ExpSphinx\etc\an4_test.fileids'); % test file list
    
    % baseline record
    baseDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, 'BASE', 'cross', 'an4\');
    fid = fopen([baseDir alignFile],'r');
    baseRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    baseLabels = baseRecord{1}(1:1:end-1);
    baseRecord = baseRecord{1}(4:4:end-1);
    
    % expecting record
    originDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, 'BASE', 'origin', 'an4\');
    fid = fopen([originDir alignFile],'r');
    originRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    originLabels = originRecord{1}(1:1:end-1);
    originRecord = originRecord{1}(4:4:end-1);
    
    % expecting record
    set1Dir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, dirFCD, recogCase, 'an4\');
    set1Dir = regexprep(set1Dir, 'EXCLUDEORIGIN', 'INCLUDEORIGIN');
    %     set1Dir = regexprep(set1Dir, 'INCLUDEORIGIN', 'EXCLUDEORIGIN');
    fid = fopen([set1Dir alignFile],'r');
    set1Record = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    set1Labels = set1Record{1}(1:1:end-1);
    set1Record = set1Record{1}(4:4:end-1);
    
    % inspecting record
    set2Dir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, dirHFCD, recogCase, 'an4\');
    set2Dir = regexprep(set2Dir, 'EXCLUDEORIGIN', 'INCLUDEORIGIN');
    %     set2Dir = regexprep(set2Dir, 'INCLUDEORIGIN', 'EXCLUDEORIGIN');
    fid = fopen([set2Dir alignFile],'r');
    set2Record = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    set2Labels = set2Record{1}(1:1:end-1);
    set2Record = set2Record{1}(4:4:end-1);
    
    
    % error list
    missBase = [];
    missOrigin = [];
    missSet1 = [];
    missSet2 = [];
    
    for sampleIdx = 1:size(fileList, 1)
        % error information
        baseError(sampleIdx, :) = readResult(baseRecord{sampleIdx})';
        originError(sampleIdx, :) = readResult(originRecord{sampleIdx})';
        set1Error(sampleIdx, :) = readResult(set1Record{sampleIdx})';
        set2Error(sampleIdx, :) = readResult(set2Record{sampleIdx})';
        
        % check if sample is miss class
        if isCorrectClass(baseRecord{sampleIdx})
            missBase = [missBase sampleIdx];
        end
        if isCorrectClass(originRecord{sampleIdx})
            missOrigin = [missOrigin sampleIdx];
        end
        if isCorrectClass(set2Record{sampleIdx})
            missSet1 = [missSet1 sampleIdx];
        end
        if isCorrectClass(set1Record{sampleIdx})
            missSet2 = [missSet2 sampleIdx];
        end
        
    end
    
    %% exclude baseline missing, extract error relation=
    realMissRecon = errorRelation(missSet1, missSet2);
    realMissRecon = setdiff(realMissRecon, missBase);
    
    %% set input wave prefix/suffix
    expDir = 'F:\IFEFSR\ExpSphinx\';
    expSuffix = '';
    baseSuffix = '1616';
    if regexp(recogCase, 'cross')
        expSuffix = '816';
    elseif regexp(recogCase, 'origin')
        expSuffix = '1616';
    end
    
    %% iterate over co-miss class
    for i = 1:size(fileList, 1) % realMissRecon %
        % extract spectra
        ACC1 = accRate(baseError(i, :));
        ACC2 = accRate(originError(i, :));
        ACC3 = accRate(set1Error(i, :));
        ACC4 = accRate(set2Error(i, :));
        
        labels = stripWhiteSpace(originLabels{(i-1)*4 + 2});
        originResults = stripWhiteSpace(originLabels{(i-1)*4 + 2 + 1});
        baseResults = stripWhiteSpace(baseLabels{(i-1)*4 + 2 + 1});
        fcdResults = stripWhiteSpace(set1Labels{(i-1)*4 + 2 + 1});
        hfcdResults = stripWhiteSpace(set2Labels{(i-1)*4 + 2 + 1});
        for k = 1:min([length(labels) length(originResults) ...
                length(baseResults) length(fcdResults) length(hfcdResults) ])
            word = labels{k};
            originWord = originResults{k};
            baseWord = baseResults{k};
            fcdWord = fcdResults{k};
            hfcdWord = hfcdResults{k};
            if  strcmpi('e', word) 
                
                result=[num2str(i) ' ' word ' ' originWord ' ' baseWord ' ' fcdWord  ' ' hfcdWord];
                disp(result)
                break;
            end
        end
        
        % six six fifth six six
%         if ismember(i, [40 90 103])
%             missSpeechOrigin = rawread(normpath('F:\IFEFSR\SpeechData\an4\wav\an4_clstk\mkdb\cen8-mkdb-b.raw'));
%             missSpeechRecon = rawread(normpath(fullfile(expDir,[dirFCD '816'], 'wav', 'an4_clstk\mkdb\cen8-mkdb-b.raw')));
%             [ CC433, FBE433, OUTMAG433] = mfcc2( missSpeechOrigin(13000:19000), 16000);
%             [ CC433R, FBE433R, OUTMAG433R] = mfcc2( missSpeechRecon(13000:19000), 16000);
%             
%             baseSpeech = rawread(normpath(fullfile(expDir, ...
%                 ['BASE8'], 'wav', [fileList{i} '.raw'])));
%             originSpeech = rawread(normpath(fullfile(expDir, ...
%                 ['BASE16'], 'wav', [fileList{i} '.raw'])));
%             
%             originSpeechFPR = regexprep(normpath(fullfile(expDir, ...
%                 [dirFCD '1616'], 'wav', [fileList{i} '.raw'])), ...
%                 'EXCLUDEORIGIN', 'INCLUDEORIGIN');
%             originSpeechR = rawread(originSpeechFPR);
%             
%             set1SpeechFP = regexprep(normpath(fullfile(expDir, ...
%                 [dirFCD '816'], 'wav', [fileList{i} '.raw'])), ...
%                 'EXCLUDEORIGIN', 'INCLUDEORIGIN');
%             set1Speech = rawread(set1SpeechFP);
%             
%             set2SpeechFP = regexprep(normpath(fullfile(expDir, ...
%                 [dirHFCD '816'], 'wav', [fileList{i} '.raw'])), ...
%                 'EXCLUDEORIGIN', 'INCLUDEORIGIN');
%             set2Speech = rawread(set2SpeechFP);
%             
%             disp(set1Labels{(i-1)*4 + 1 + 1})
%             disp(originLabels{(i-1)*4 + 2 + 1})
%             disp(baseLabels{(i-1)*4 + 2 + 1})
%             disp(set1Labels{(i-1)*4 + 2 + 1})
%             disp(set2Labels{(i-1)*4 + 2 + 1})
%             
%             figNum = 43;
%             switch i
%                 case 40
%                     [ CC0, FBE0, OUTMAG0] = mfcc2( originSpeech(40000:50000), 16000);
%                     [ CC0R, FBE0R, OUTMAG0R] = mfcc2( originSpeechR(40000:50000), 16000);
%                     [ CC00, FBE00, OUTMAG00] = mfcc2( baseSpeech(20000:25000), 8000);
%                     OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];
%                     [ CC1, FBE1, OUTMAG1] = mfcc2( set1Speech(40000:50000), 16000);
%                     [ CC2, FBE2, OUTMAG2] = mfcc2( set2Speech(40000:50000), 16000);
%                     figNum = 431;
%                 case 90
%                     [ CC0, FBE0, OUTMAG0] = mfcc2( originSpeech(10000:15000), 16000);
%                     [ CC0R, FBE0R, OUTMAG0R] = mfcc2( originSpeechR(10000:15000), 16000);
%                     [ CC00, FBE00, OUTMAG00] = mfcc2( baseSpeech(5000:7500), 8000);
%                     OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];
%                     [ CC1, FBE1, OUTMAG1] = mfcc2( set1Speech(10000:15000), 16000);
%                     [ CC2, FBE2, OUTMAG2] = mfcc2( set2Speech(10000:15000), 16000);
%                     figNum = 432;
%                 case 103
%                     [ CC0, FBE0, OUTMAG0] = mfcc2( originSpeech(4400:9700), 16000);
%                     [ CC0R, FBE0R, OUTMAG0R] = mfcc2( originSpeechR(4400:9700), 16000);
%                     [ CC00, FBE00, OUTMAG00] = mfcc2( baseSpeech(2200:4900), 8000);
%                     OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];
%                     [ CC1, FBE1, OUTMAG1] = mfcc2( set1Speech(4400:9700), 16000);
%                     [ CC2, FBE2, OUTMAG2] = mfcc2( set2Speech(4400:9700), 16000);
%                     figNum = 433;
%             end
%             
%             %% visualize spectrum
%             plotCMPSpec(figNum*10 + 1, ...
%                 OUTMAG0, {'Spectrum of ', '16-kHz original speech signal','of "Sixth"'}, ...
%                 OUTMAG00,  {'Spectrum of ', '8-kHz original speech signal','of "Sixth"'},...
%                 OUTMAG433,  {'Spectrum of ', '16-kHz original speech signal','of "Fifth"'}...
%                 );
%             set(gcf, 'Position', [0 0 1200 600])
%             
%             plotCMPSpec(figNum*10 + 2, ...
%                 OUTMAG0R, {'Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using FCD method'}, ...
%                 OUTMAG1,  {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using FCD method'},...
%                 OUTMAG433R,  {'Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "Fifth" using FCD method'}...
%                 );
%             set(gcf, 'Position', [0 0 1200 600])
%             
% %             plotCMPSpec(figNum*10 + 3, ...
% %                 OUTMAG1, {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using FCD method'}, ...
% %                 OUTMAG2,  {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using HFCD-HP method'}...
% %                 );
% %             set(gcf, 'Position', [0 0 1200 600])
%             %             colormap default
%         end

        if ismember(i, 11)
            three8FP = normpath(fullfile(expDir, 'BASE8', 'wav', [fileList{i} '.raw']));
            thirty16FP = normpath(fullfile(expDir, 'BASE16', 'wav', [fileList{ 56 } '.raw']));
            three16FP = normpath(fullfile(expDir, 'BASE16', 'wav', [fileList{i} '.raw']));
            
            three816FCDFP = normpath(fullfile(expDir, [dirFCD '816'], 'wav', [fileList{i} '.raw']));
            thirty1616FCDFP = normpath(fullfile(expDir, [dirFCD '1616'], 'wav', [fileList{ 56 } '.raw']));
            three1616FCDFP = normpath(fullfile(expDir, [dirFCD '1616'], 'wav', [fileList{i} '.raw']));
            e1616FCDFP = normpath(fullfile(expDir, [dirFCD '1616'], 'wav', [fileList{ 9 } '.raw']));
            three816HFCDFP = normpath(fullfile(expDir, [dirHFCD '816'], 'wav', [fileList{i} '.raw']));
            three1616HFCDFP = normpath(fullfile(expDir, [dirHFCD '1616'], 'wav', [fileList{i} '.raw']));
            e1616HFCDFP = normpath(fullfile(expDir, [dirHFCD '1616'], 'wav', [fileList{ 9 } '.raw']));
            
            three8sig = rawread( three8FP );
            thirty16sig = rawread( thirty16FP );
            three16sig = rawread( three16FP );
            
            three816FCDsig = rawread( three816FCDFP );
            thirty1616FCDsig = rawread( thirty1616FCDFP );
            three1616FCDsig = rawread( three1616FCDFP );
            e1616FCDsig = rawread( e1616FCDFP );
            three816HFCDsig = rawread( three816HFCDFP );
            three1616HFCDsig = rawread( three1616HFCDFP );
            e1616HFCDsig = rawread( e1616HFCDFP );
            
            [ ~, ~, OUTMAG01 ] = mfcc2( three8sig(13500:17000) , 8000);
            OUTMAG01 = [OUTMAG01; zeros(size(OUTMAG01))];
            [ ~, ~, OUTMAG02 ] = mfcc2( thirty16sig(33000:39000) , 16000);
            [ ~, ~, OUTMAG03 ] = mfcc2( three16sig(27000:34000) , 16000);
            
            [ ~, ~, OUTMAG1 ] = mfcc2( three816FCDsig(27000:34000) , 16000);
            [ ~, ~, OUTMAG2 ] = mfcc2( thirty1616FCDsig(33000:39000) , 16000);
            [ ~, ~, OUTMAG3 ] = mfcc2( three1616FCDsig(27000:34000) , 16000);
            [ ~, ~, OUTMAG4 ] = mfcc2( e1616FCDsig(9000:17000) , 16000);
            [ ~, ~, OUTMAG5 ] = mfcc2( three816HFCDsig(27000:34000) , 16000);
            [ ~, ~, OUTMAG6 ] = mfcc2( three1616HFCDsig(27000:34000) , 16000);
            [ ~, ~, OUTMAG7 ] = mfcc2( e1616HFCDsig(9000:17000) , 16000);

            
            disp(set1Labels{(i-1)*4 + 1 + 1})
            disp(originLabels{(i-1)*4 + 2 + 1})
            disp(baseLabels{(i-1)*4 + 2 + 1})
            disp(set1Labels{(i-1)*4 + 2 + 1})
            disp(set2Labels{(i-1)*4 + 2 + 1})
%             
            %% visualize spectrum
            plotCMPSpec(45, ...
                OUTMAG01, {'Spectrum of ', '8-kHz original speech signal','of "Three"'}, ...
                OUTMAG02,  {'Spectrum of ', '16-kHz original speech signal','of "Thirty"'},...
                OUTMAG03,  {'Spectrum of ', '16-kHz original speech signal','of "Three"'}...
                );
            set(gcf, 'Position', [0 0 1200 600])
            
            plotCMPSpec(46, ...
                OUTMAG1, {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Three" using FCD method'}, ...
                OUTMAG4,  {'Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "E" using FCD method'},...
                OUTMAG3,  {'Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "Three" using FCD method'}...
                );
            set(gcf, 'Position', [0 0 1200 600])
            
            plotCMPSpec(47, ...
                OUTMAG5, {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Three" using HFCD-HP method'}, ...
                OUTMAG7,  {'Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "E" using HFCD-HP method'},...
                OUTMAG6,  {'Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "Three" using HFCD-HP method'}...
                );
            set(gcf, 'Position', [0 0 1200 600])
        end
        
    end
end



