% code filelist generator
audioPrefix = 'F:\IFEFSR\FractalCode\';
RBSSet = [8 16 32];
FSet = [11 22 44];
for fsIdx = 1:3
    fos = fopen(['F:\IFEFSR\' num2str(FSet(fsIdx)) ...
        'k_train_matlabResampling_fs' num2str(RBSSet(fsIdx)) '_code.txt'],'w');
    for sp = 1:18
        for wIdx = 1:10
            i = (sp-1)*10 + wIdx;
            audioSuffix = ['k_train_matlabResampling_Fs' ...
                num2str(RBSSet(fsIdx)) 'ds1\' num2str(FSet(fsIdx)) 'k_speaker_1_sp_' num2str(sp) ...
                '-' sprintf('%02d',wIdx) '.mat'];
            fprintf(fos,'%s\r\n',[audioPrefix num2str(FSet(fsIdx)) audioSuffix]);
        end
    end
    fclose(fos);
end
for fsIdx = 1:3
    fos = fopen(['F:\IFEFSR\' num2str(FSet(fsIdx)) ...
        'k_test_matlabResampling_fs' num2str(RBSSet(fsIdx)) '_code.txt'],'w');
    for sp = 1:18
        for wIdx = 1:10
            i = (sp-1)*10 + wIdx;
            audioSuffix = ['k_test_matlabResampling_Fs' ...
                num2str(RBSSet(fsIdx)) 'ds1\' num2str(FSet(fsIdx)) 'k_speaker_1_sp_' num2str(sp) ...
                '-' sprintf('%02d',wIdx + 10) '.mat'];
            fprintf(fos,'%s\r\n',[audioPrefix num2str(FSet(fsIdx)) audioSuffix]);
        end
    end
    fclose(fos);
end