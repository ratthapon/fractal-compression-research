
for fsIdx = 1:2
    outDir = ['F:\IFEFSR\SamplesSpeech\synth\' num2str(8 * fsIdx) '\'];
    mkdir(outDir);
    
    sig = createComplexSignal(8000 * fsIdx);
    
    outPaths = [outDir 'sig.raw'];
    plotSigVsFreqRes( sig, '', 8000 * fsIdx );
    rawwrite( outPaths , sig);
    
    fileIdsDir = ['F:\IFEFSR\SamplesSpeech\synth_' 'ids' num2str(8 * fsIdx) '.txt'];
    fid = fopen(fileIdsDir,'w');
    fprintf(fid, '%s\r\n', 'sig.raw');
    fclose(fid);
end





