% kkkkk
for k = 1:10
    observerSize = k*10
    clearvars -except observerSize KResult
    tactic3_transcodeTrainer
    tactic3_transcodeTester
    KResult(k) = {results};
    try
        KResult3d(:,:,k) = results;
    catch ex
    end
    save('F:\IFEFSR\MData\KResult','KResult');
    save('F:\IFEFSR\MData\KResult3d','KResult3d');
end