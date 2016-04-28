%% missclassificaiton analysis for sphinx corpus

inDir = '';
clusterDir = '';
alignFile = '';
fileList  = importdata(''); % test file list

%% criteria
thresh = 0.5;
accRate = @(result) result(2) / result(1);
readResult = @(record) sscanf(record, 'Words: %f Correct: %f Errors: d');
isMissClass = @(record) thresh > accRate(readResult(record)); % test function

%% pattern extract

for i = 1:size(fileList, 1)
    
end






