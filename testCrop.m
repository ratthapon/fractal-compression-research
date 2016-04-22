oriWave_3 = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
    '\32\CF001_Va001\CF001_Va001_001.wav']);
oriWave_3 = oriWave_3(:,1);

crop = cropVoice(oriWave_3);

filesList = importdata(['F:\IFEFSR\' '16' ...
    'k_NECTEC_matlabResampling.txt']);

for i=1:size(filesList,1)
   wav = audioread(filesList{i});
   plot(wav);
end