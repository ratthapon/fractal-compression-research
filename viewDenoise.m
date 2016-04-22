% denoise
denoiseMethod = 'db1';
for denoiseLevel = 1:5
    clearvars -except denoiseLevel denoiseMethod DResult
    tactic3_transcodeTrainer
    tactic3_transcodeTester
    DResult(denoiseLevel) = {results};
    try
        DResult3d(:,:,denoiseLevel) = results;
    catch ex
    end
    save('F:\IFEFSR\MData\DResult','DResult');
    save('F:\IFEFSR\MData\DResult3d','DResult3d');
end