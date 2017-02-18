
%% missclass functions
thresh = 0;
accRate = @(result) result(2) / result(1);
readResult = @(record) sscanf(record, 'Words: %d Correct: %d Errors: %d');
isMissClass = @(record) thresh >= accRate(readResult(record)); % test function
isCorrectClass = @(record) 1-thresh <= accRate(readResult(record)); % test function

expDir = 'F:\IFEFSR\ExpSphinx\';
fileListPath = [expDir 'an4traintest.txt'];
fileList = importdata(fileListPath);
% errorRelation = @union;
% errorRelation = @intersect;
errorRelation = @setdiff;
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
        featCase, 'BASE', recogCase, 'an4\');
    fid = fopen([baseDir alignFile],'r');
    baseRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    baseRecord = baseRecord{1}(4:4:end-1);
    
    % expecting record
    originDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, PREFIX{1}, recogCase, 'an4\');
    fid = fopen([originDir alignFile],'r');
    originRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    originRecord = originRecord{1}(4:4:end-1);
    
    % expecting record
    excludeDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, dataSet, recogCase, 'an4\');
    excludeDir = regexprep(excludeDir, 'INCLUDEORIGIN', 'EXCLUDEORIGIN');
    fid = fopen([excludeDir alignFile],'r');
    excludeRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    excludeRecord = excludeRecord{1}(4:4:end-1);
    
    % inspecting record
    includeDir = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, ...
        featCase, dataSet, recogCase, 'an4\');
    includeDir = regexprep(includeDir, 'EXCLUDEORIGIN', 'INCLUDEORIGIN');
    fid = fopen([includeDir alignFile],'r');
    includeRecord = textscan(fid,'%[^\n]'); % results list
    fclose(fid);
    includeRecord = includeRecord{1}(4:4:end-1);
    
    % error list
    missBase = [];
    missOrigin = [];
    missExclude = [];
    missInclude = [];
    
    for sampleIdx = 1:size(fileList, 1)
        % error information information
        baseError(sampleIdx, :) = readResult(baseRecord{sampleIdx})';
        originError(sampleIdx, :) = readResult(originRecord{sampleIdx})';
        excludeError(sampleIdx, :) = readResult(includeRecord{sampleIdx})';
        includeError(sampleIdx, :) = readResult(excludeRecord{sampleIdx})';
        
        % check if sample is miss class
        if isCorrectClass(baseRecord{sampleIdx})
            missBase = [missBase sampleIdx];
        end
        if isCorrectClass(includeRecord{sampleIdx})
            missExclude = [missExclude sampleIdx];
        end
        if isCorrectClass(excludeRecord{sampleIdx})
            missOrigin = [missOrigin sampleIdx];
        end
    end
    
    %% exclude baseline missing, extract error relation
    %     realMissRecon = setdiff(...
    %         errorRelation(missRecon, missOrigin), ...
    %         missBase);
    realMissRecon = errorRelation(missExclude, missOrigin);
    
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
    for i = 11:size(fileList, 1)
        %% read speech signals
        baseSpeech = rawread(normpath(fullfile(expDir, ...
            ['BASE16'], 'wav', [fileList{i} '.raw'])));
        [ CC00, FBE00, OUTMAG00, MAG00, H00, DCT00] = mfcc2( baseSpeech, 16000);
        ACC1 = accRate(baseError(i, :));
        
        originSpeech = rawread(normpath(fullfile(expDir, ...
            [PREFIX{1} '816'], 'wav', [fileList{i} '.raw'])));
        [ CC0, FBE0, OUTMAG0, MAG0, H0, DCT0] = mfcc2( originSpeech, 16000);
        ACC2 = accRate(originError(i, :));
        
        excludePath = regexprep(normpath(fullfile(expDir, ...
            [dataSet '816'], 'wav', [fileList{i} '.raw'])), ...
            'INCLUDEORIGIN', 'EXCLUDEORIGIN');
        excludeSpeech = rawread(excludePath);
        [ CC1, FBE1, OUTMAG1, MAG1, H1, DCT1] = mfcc2( excludeSpeech, 16000);
        ACC3 = accRate(excludeError(i, :));
        
        includePath = regexprep(normpath(fullfile(expDir, ...
            [dataSet '816'], 'wav', [fileList{i} '.raw'])), ...
            'EXCLUDEORIGIN', 'INCLUDEORIGIN');
        includeSpeech = rawread(includePath);
        [ CC2, FBE2, OUTMAG2, MAG2, H2, DCT2] = mfcc2( includeSpeech, 16000);
        ACC4 = accRate(includeError(i, :));
        
        %% norm
        OUTMAG00 = zscore(OUTMAG00);
        OUTMAG0 = zscore(OUTMAG0);
        OUTMAG1 = zscore(OUTMAG1);
        OUTMAG2 = zscore(OUTMAG2);
        
        ALLOUTMAG = [OUTMAG00 OUTMAG0 OUTMAG1 OUTMAG2];
        
        if ACC4 > 0
            %% visualize spectrum
            figure(1),
%             plotCMPSpec(1, ...
%                 -ALLOUTMAG, ['16k ' num2str(ACC1)] ...
%                 );
            plotCMPSpec(1, ...
                -OUTMAG00, ['16k ' num2str(ACC1)], ...
                -OUTMAG0, [ '16k FC ' num2str(ACC2)], ...
                -OUTMAG1, [ '16k FCHM ' num2str(ACC3)], ...
                -OUTMAG2, [ '816 FCHM' num2str(ACC4)] ...
                );
            %
            colormap default
%             set(gcf, 'position', [-1600 0 1600 1280])
            %
            % %             figure(2),
            % %             plotCMPSpec(2, ...
            % %                 -OUTMAG00, ['BASE ' num2str(ACC1)], ...
            % %                 -(OUTMAG0-OUTMAG00), [ 'FC 1616 ' num2str(ACC2)], ...
            % %                 -(OUTMAG2-OUTMAG00), [ 'FC HAR 1616 tr/ts ' num2str(ACC4)] ...
            % %                 );
            % %             colormap default
            %             %     -(OUTMAG2-OUTMAG0), [ ' FC harmonic recon ' num2str(ACC3)], ...
            %             % my 1st screen
            %             %         set(gcf, 'position', [0 0 900 400])
            %
            %             % my 2nd screen
            %             set(gcf, 'position', [-1600 0 1600 1280])
            
            %             prevError = inf;
            %             for col = 1:size(OUTMAG00, 2)
            %                 diff21 = OUTMAG0(end/2:end,col) - OUTMAG00(end/2:end,col);
            %                 % OUTMAG0(:,col) - OUTMAG00(:,col)
            %                 diff31 = OUTMAG2(end/2:end,col) - OUTMAG00(end/2:end,col);
            %                 if sum(abs(diff31)) < sum(abs(diff21))
            %                     figure(3),
            %                     plot(diff21, 'r'),
            %                     hold on
            %                     plot(diff31, 'g'),
            %                     hold off
            %
            %                     figure(5), hold on,
            %                     plot(OUTMAG00(:,col), 'b'),
            %                     plot(OUTMAG0(:,col), 'r'),
            %                     plot(OUTMAG2(:,col), 'g'),
            %                     hold off
            %                 end
            %             end
            
%                         figure(5),
%                         subplot(4,1,1), plot(baseSpeech(20000:25000), 'b'),
%                         subplot(4,1,2), plot(originSpeech(20000:25000), 'r'),
%                         subplot(4,1,3), plot(excludeSpeech(20000:25000), 'g'),
%                         subplot(4,1,4), plot(includeSpeech(20000:25000), 'g'),
            
            % lab 2nd screen
            %     set(gcf, 'position', [-1600 0 1600 1280])
        end
    end
end



