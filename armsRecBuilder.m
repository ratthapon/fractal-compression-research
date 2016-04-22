
inDir = 'F:\IFEFSR\SpeechData\TestDAT\';
outDir = 'F:\IFEFSR\SpeechData\ARMS_REC\';
fos1 = fopen(['F:\IFEFSR\8k_ARMS_REC_INT.txt'],'w');
fos2 = fopen(['F:\IFEFSR\16k_ARMS_REC_INT.txt'],'w');
for c =1:18
    for i = 1:20
        inFileName = ['44k_speaker_1_sp_' num2str(c) '-' sprintf('%02d.wav',i)];
        [inWav,Fs] = audioread([inDir inFileName]);
        
        outWav = resample(inWav,8000,Fs);
        outFileName = ['8k_speaker_1_sp_' num2str(c) '-' sprintf('%02d.wav',i)];
        audiowrite([outDir outFileName],outWav,8000);
        fprintf(fos1,'%s\r\n',[outDir outFileName]);
        
        outWav = resample(inWav,16000,Fs);
        outFileName = ['16k_speaker_1_sp_' num2str(c) '-' sprintf('%02d.wav',i)];
        audiowrite([outDir outFileName],outWav,16000);
        fprintf(fos2,'%s\r\n',[outDir outFileName]);
    end
end
fclose(fos1);
fclose(fos2);

nClass = 18;
wordCount = 20;
trainIdx = 1:2:wordCount * nClass;
testIdx = 2:2:wordCount * nClass;
trainClass = [];
for c = 1:nClass
    trainClass = [trainClass ; c * ones(wordCount/2,1)];
end
label = trainClass;

load('F:\IFEFSR\Recognition analysis\FIXED_MODEL_NECTEC','MODEL');
MODEL = MODEL(1:nClass);
save(['F:\IFEFSR\Recognition analysis\FIXED_MODEL_NECTEC_ALL' ...
    '_ARMS_REC'],'MODEL');
save(['F:\IFEFSR\Recognition analysis\SampleIdx_ALL' ...
    '_BAND_ARMS_REC'],'trainIdx','testIdx','trainClass','label');