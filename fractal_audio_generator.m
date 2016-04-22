% matlab resampling
% raw sampling
FsIn = 22050;
FsOut = 22050; % 22050 11025 44100
fpc = 32;
strIn = num2str(floor(FsIn/1000));
strOut = num2str(floor(FsOut/1000));
strFs = num2str(fpc);
fileList = importdata(['F:\IFEFSR\' strIn 'k_train_rawResampling_fs' strFs ...
    '_code.txt']);
audioPrefix = 'F:\IFEFSR\SpeechData\TestDAT_decoded_rawResampling\';
mkdir(audioPrefix);

fos = fopen(['F:\IFEFSR\' strOut 'k_train_decoded_' strIn ...
    'k_fs' strFs '_rawResampling.txt'],'w');
for sp = 1:18
    for wIdx = 1:10
        i = (sp-1)*10 + wIdx;
        load(fileList{i}); % load f data
        signal = fractalDecode(f,FsIn,fpc,1,FsOut,[],[]);
        signal = ((signal - mean(signal)) / std(signal));
        signal = signal / norm(signal);
        clear f;
        
        audioSuffix = ['k_decoded_' strIn 'k_speaker_1_sp_' num2str(sp) ...
            '-' sprintf('%02d',wIdx) '.wav'];
        audiowrite([audioPrefix strOut audioSuffix],signal,FsOut);
        fprintf(fos,'%s\r\n',[audioPrefix strOut audioSuffix]);
    end
end
fclose(fos);

fileList = importdata(['F:\IFEFSR\' strIn 'k_test_rawResampling_fs' strFs ...
    '_code.txt']);
fos = fopen(['F:\IFEFSR\' strOut 'k_test_decoded_' strIn ...
    'k_fs' strFs '_rawResampling.txt'],'w');
for sp = 1:18
    for wIdx = 1:10
        i = (sp-1)*10 + wIdx;
        load(fileList{i}); % load f data
        signal = fractalDecode(f,FsIn,fpc,1,FsOut,[],[]);
        signal = ((signal - mean(signal)) / std(signal));
        signal = signal / norm(signal);
        clear f;
        
        audioSuffix = ['k_decoded_' strIn 'k_speaker_1_sp_' num2str(sp) ...
            '-' sprintf('%02d',wIdx + 10) '.wav'];
        audiowrite([audioPrefix strOut audioSuffix],signal,FsOut);
        fprintf(fos,'%s\r\n',[audioPrefix strOut audioSuffix]);
    end
end
fclose(fos);