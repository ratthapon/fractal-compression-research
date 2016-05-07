%% missclassificaiton analysis for sphinx corpus
mfccparams;

originDir = 'F:\IFEFSR\ExpSphinx\FC816\';
inDir = 'F:\IFEFSR\ExpSphinx\FC1616\';
clusterDir = 'misscluster';

%% read result record
alignDir = ['F:\IFEFSR\ExpSphinx\caseA\Sphinx5Feat\cross\FC\A95\an4\'];
alignFile = 'result\an4.align';
fileList  = importdata('F:\IFEFSR\ExpSphinx\etc\an4_test.fileids'); % test file list
fid = fopen([alignDir alignFile],'r');
resultRecord = textscan(fid,'%[^\n]'); % results list
fclose(fid);
resultRecord = resultRecord{1}(4:4:end-1);

%% criteria
thresh = 0;
accRate = @(result) result(2) / result(1);
readResult = @(record) sscanf(record, 'Words: %d Correct: %d Errors: %d');
isMissClass = @(record) thresh >= accRate(readResult(record)); % test function

%% manage directory
system(['rmdir /S /Q ' inDir clusterDir]);
system(['mkdir ' inDir clusterDir]);

%% pattern extract
missClass = zeros(size(fileList));
wordError = zeros(size(fileList, 1), 3);
for i = 1:size(fileList, 1)
    wordError(i, :) = readResult(resultRecord{i})';
    if isMissClass(resultRecord{i})
        missClass(i) = 1;
        i
        sigOri = rawread([originDir 'wav\' fileList{i} '.raw']);
        sigRec = rawread([inDir 'wav\' fileList{i} '.raw']);
        
        [MFCCOri, FBEOri, SPECOri] = mfcc( sigOri, 16000,...
            Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        [MFCCRec, FBERec, SPECRec] = mfcc( sigRec, 16000,...
            Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
        
        f = figure(1),
        subplot(1,2,1), imagesc(-SPECOri); set(gca,'YDir','normal');
        title('original spectrum')
        xlabel('Frame index')
        ylabel('Frequency index')
        subplot(1,2,2), imagesc(-SPECRec); set(gca,'YDir','normal');
        title('reconstructed spectrum')
        xlabel('Frame index')
        ylabel('Frequency index')
        colormap(gray)
        
        path = regexp(fileList{i}, '/', 'split');
        saveas(f, [inDir clusterDir '/' num2str(i) '_' path{3}], 'png')
    end
end






