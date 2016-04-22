% prepare compressed data
load('listFileName1');
fs = 8; % frame size
dStep = 1;
fData = [];
cumulativeTime = 0;
for fIdx = 7:50 %size(listFileName,1)
    fIdx
    % Read speech samples, sampling rate and precision from file
    [ speech, Fs ] = audioread( listFileName{fIdx} );
    audioTime = size(speech,1) / Fs;
    cumulativeTime = cumulativeTime + audioTime;
    
    [f fs compressTime] = fractalCompress(speech,fs,dStep);
    fData = [fData;{f} fs dStep audioTime compressTime];
end
save(['fData' num2str(fs) '-' num2str(dStep) '_7-50'],'fData');
