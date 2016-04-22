% qqqqq
observerSize = 100;
for q = 3:2:49
    stateSize = q
    clearvars -except stateSize KResult q KResult3d observerSize
    tactic3_transcodeTrainer;
    tactic3_transcodeTester;
    KResult(q) = {results};
    try
        KResult3d(:,:,q) = results;
    catch ex
        ex
    end
    save('F:\IFEFSR\MData\KResult','KResult');
    save('F:\IFEFSR\MData\KResult3d','KResult3d');
end