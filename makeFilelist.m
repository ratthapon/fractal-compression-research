
for minBlock = [16 32 64]
    for k = [11 22 44]
        fos = fopen(['F:\IFEFSR\' num2str(k) 'k_TRAIN_MR_' num2str(minBlock) ...
            '-128_Thesh1E-4_code.txt'],'w');
        for i = 1:10
            fileName = ...
                ['F:\IFEFSR\APFractalCode\' num2str(k) ...
                'k_TRAIN_MR_' num2str(minBlock) ...
                '-128_Thresh1E-4ds1\44k_speaker_1_sp_1-' sprintf('%02d',i) '.mat']
            fprintf(fos,'%s\r\n',fileName);
        end
        fclose(fos);
    end
end
