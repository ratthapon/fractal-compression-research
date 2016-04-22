%% audio parameter
dFPC = [8000 16000 24000]; % resampling rate to frame per second
wordCount = 67;
fileCountPerWord = 1;
speakers = [1 2 3 4 5 6 8 9 10 11]; % from 7 feamale and 5 male
trainFileIdx = [];
for i = speakers
    trainFileIdx = [trainFileIdx (i-1)*wordCount+1:i*wordCount];
end
nTrain = size(trainFileIdx,2);