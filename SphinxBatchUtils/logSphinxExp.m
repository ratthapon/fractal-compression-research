function logSphinxExp(expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase )
%LOGSPHINXEXP Log the Sphinx experiment

%% get time stamp
c = clock;
fmtTime = sprintf('%02d:%02d:%02d', c(4), c(5), int32(c(6)));
timeString = [date ' ' fmtTime];

%% get configuration info
cfgPath = fullfile(expDirPrefix, ['A' preemAlphaStr], featExtractor, featCase, dataSet,  ...
    recogCase, 'an4', 'etc', 'sphinx_train.cfg');
[ cfg ] = parseSphinxCfg( cfgPath );

%% get accuracy information
[ nCorrectSent, nSent, nCorrectWord, nWord ] =  ...
    readSphinxAcc(  expDirPrefix, preemAlphaStr, featExtractor, featCase, dataSet, recogCase  );

%% write experiment data
expInfo{1} = timeString;
expInfo{2} = cfg;
expInfo{3} = [ nCorrectSent, nSent, nCorrectWord, nWord ];

% write to matrix file
data = load(fullfile(expDirPrefix, 'expsummary.mat'));
data.expSummary = [data.expSummary; expInfo];
expSummary = data.expSummary;
save( fullfile(expDirPrefix, 'expsummary.mat'), ...
    'expSummary');

% write to xls file
expRecord = [{timeString}, {preemAlphaStr}, {featExtractor}, {featCase}, ...
    {dataSet}, {recogCase}, {nCorrectSent}, nSent, nCorrectWord, nWord , ...
    double(nCorrectWord)/double(nWord)]; 

prevSummary = xlsread( fullfile(expDirPrefix, 'expsummary.xls') );
xlswrite( fullfile(expDirPrefix, 'expsummary.xls'), expRecord, ...
    ['A' num2str(size(prevSummary, 1) + 1) ':K' num2str(size(prevSummary, 1) + 1)]);
end

