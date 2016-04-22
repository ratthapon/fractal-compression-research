load('listFileName1');
cumulativeTime = 0;
for fIdx = 1:size(listFileName,1)
    % Read speech samples, sampling rate and precision from file
    [ speech, fs ] = audioread( listFileName{fIdx} );
    t = size(speech,1) / fs;
    cumulativeTime = cumulativeTime + t;
end