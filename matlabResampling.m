% matlab resampling
% raw sampling
fileList = importdata('F:\IFEFSR\44k_test.txt');
% fileList = importdata('F:\IFEFSR\fileList.txt');
FsOut = 44100;
strK = num2str(floor(FsOut/1000));
fos = fopen(['F:\IFEFSR\' strK 'k_TEST_MR.txt'],'w');
for i = 1:size(fileList,1)
    i
    [waveIn,FsIn] = audioread(fileList{i});
%     waveIn = cropVoice(waveIn(:,1));
    %     waveOut = resample(waveIn,FsOut,FsIn);
    %     waveOut = waveIn;
    %     waveOut = downsample(waveIn,2);
    if FsOut > FsIn
        waveOut = resample(waveIn,FsOut,FsIn);
    end
    if FsOut == FsIn
        waveOut = waveIn;
    end
    if FsIn > FsOut
        waveOut = downsample(waveIn,FsIn/FsOut);
    end
    inAudioPaths = strsplit(fileList{i},'\');
    audioPrefix = ['F:\IFEFSR\SpeechData\MR\' strK ]; %...
%         '\' inAudioPaths{5} ];
    mkdir(audioPrefix);
    audioSuffix = ['\' inAudioPaths{5}];
    audiowrite([audioPrefix audioSuffix],waveOut(:,1),FsOut);
    fprintf(fos,'%s\r\n',[audioPrefix audioSuffix]);
end
fclose(fos);

% fileList = importdata('F:\IFEFSR\44k_test.txt');
% fos = fopen(['F:\IFEFSR\' strK 'k_test_matlabResampling.txt'],'w');
% for sp = 1:18
%     for wIdx = 1:10
%         i = (sp-1)*10 + wIdx;
%         wave44 = audioread(fileList{i});
%         waveOut = resample(wave44,FsOut,44100);
%         audioSuffix = ['k_speaker_1_sp_' num2str(sp) ...
%             '-' sprintf('%02d',wIdx + 10) '.wav'];
%         audiowrite([audioPrefix strK audioSuffix],waveOut,FsOut);
%         fprintf(fos,'%s\r\n',[audioPrefix strK audioSuffix]);
%     end
% end
% fclose(fos);