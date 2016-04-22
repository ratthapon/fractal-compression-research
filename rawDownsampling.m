% matlab resampling
% raw sampling
fileList = importdata('F:\IFEFSR\44k_train.txt');
audioPrefix = 'F:\IFEFSR\SpeechData\TestDAT_rawResampling\';
mkdir(audioPrefix);
FsOut = 42000;
strK = num2str(floor(FsOut/1000));
fos = fopen(['F:\IFEFSR\' strK 'k_train_rawResampling.txt'],'w');
for sp = 1:18
    for wIdx = 1:10
        i = (sp-1)*10 + wIdx;
        wave44 = audioread(fileList{i});
        sampleIdx = 1:(44100/FsOut):size(wave44,1);
        sampleIdx = floor(sampleIdx');
        waveOut = wave44(sampleIdx);
        audioSuffix = ['k_speaker_1_sp_' num2str(sp) ...
            '-' sprintf('%02d',wIdx) '.wav'];
        audiowrite([audioPrefix strK audioSuffix],waveOut,FsOut);
        fprintf(fos,'%s\r\n',[audioPrefix strK audioSuffix]);
    end
end
fclose(fos);

fileList = importdata('F:\IFEFSR\44k_test.txt');
fos = fopen(['F:\IFEFSR\' strK 'k_test_rawResampling.txt'],'w');
for sp = 1:18
    for wIdx = 1:10
        i = (sp-1)*10 + wIdx;
        wave44 = audioread(fileList{i});
        sampleIdx =1:(44100/FsOut):size(wave44,1);
        sampleIdx = floor(sampleIdx');
        waveOut = wave44(sampleIdx');
        audioSuffix = ['k_speaker_1_sp_' num2str(sp) ...
            '-' sprintf('%02d',wIdx + 10) '.wav'];
        audiowrite([audioPrefix strK audioSuffix],waveOut,FsOut);
        fprintf(fos,'%s\r\n',[audioPrefix strK audioSuffix]);
    end
end
fclose(fos);