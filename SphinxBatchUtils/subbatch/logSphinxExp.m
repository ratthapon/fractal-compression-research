function logSphinxExp(expDirPrefix, preemAlphaStr, featExtractor, ...
    featCase, dataSet, recogCase, parameters, notes)
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
save( fullfile(expDirPrefix, 'ExpSummaries', [regexprep(timeString, '[: ]', '-') '.mat']), ...
    'expInfo');

% write to xls file
expRecord = [{timeString}, {preemAlphaStr}, {featExtractor}, {featCase}, ...
    {dataSet}, {recogCase}, {num2str(nCorrectSent)}, {num2str(nSent)}, {num2str(nCorrectWord)}, ...
    {num2str(nWord)} , {num2str(double(nCorrectWord)/double(nWord))}, ...
    {num2str(1 - double(nCorrectWord)/double(nWord))}];

fid = fopen(fullfile(expDirPrefix, 'expsummary.csv'), 'a') ;
fprintf(fid, '%s,', expRecord{1,1:end}) ;
fprintf(fid, '%s,', notes{1,1:end}) ;

% write parameters to log
for i = 1:size(parameters, 1)
    fprintf(fid, '%s,', sprintf('%s %s', parameters{:})) ;
end

fprintf(fid, '\n') ;
fclose(fid) ;
end

