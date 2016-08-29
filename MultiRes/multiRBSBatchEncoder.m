
%% define the parameters set
FS = [8 16];
RBS = [2 4 8];
partitionType = [{'ADP_RBS'}, {'FIXED_PARTITION_RBS'}];
coeffVal = [0.99, 1.2];
pThresh = [{'1e-6'}, {'0'}];

for fsIdx = 1:length(FS)
    for coeffIdx = 1:length(coeffVal)
        for parTypeIdx = 1:length(partitionType)
            lenRBS = length(RBS);
            if parTypeIdx == 1
                lenRBS = 1;
            end
            for rbsIdx = 1:lenRBS
                testname = ['SUBAN4' num2str(FS(fsIdx)) '_' partitionType{parTypeIdx} ...
                    num2str(RBS(rbsIdx)) '_COEFF' sprintf('%03d', coeffVal(coeffIdx) * 100)];
                coeffLimit = sprintf('%2.2f', coeffVal(coeffIdx));
                minR = num2str(RBS(rbsIdx));
                maxR = num2str(RBS(rbsIdx));
                pthresh = pThresh{parTypeIdx};
                if parTypeIdx == 1
                    testname = ['SUBAN4' num2str(FS(fsIdx)) '_' partitionType{parTypeIdx} ...
                        num2str(RBS(1)) 'T' num2str(RBS(end)) '_COEFF' ...
                        sprintf('%03d', coeffVal(coeffIdx) * 100)];
                    minR = num2str(RBS(1));
                    maxR = num2str(RBS(end));
                    pthresh = pThresh{parTypeIdx};
                end
                
                
                % create tempolary parameters file
                
                injectParameters = ...
                    [{'processname compress'},
                    {['testname ' testname]},
                    {['infile F://IFEFSR//SamplesSpeech//ids' num2str(FS(fsIdx)) '.txt']},
                    {['inpathprefix F://IFEFSR//SamplesSpeech//speech//' num2str(FS(fsIdx)) '//']},
                    {'outdir F://IFEFSR//SamplesSpeech//code//'},
                    {'maxprocess 1'},
                    {'inext raw'},
                    {'outext mat'},
                    {['pthresh ' pthresh]},
                    {'reportrate 0'},
                    {'gpu true'},
                    {['coefflimit ' coeffLimit]},
                    {'skipifexist false'},
                    {['minr ' minR]},
                    {['maxr ' maxR]}];
                
                fileIdsDir = 'F:\IFEFSR\SamplesSpeech\tempParameters.txt';
                fid = fopen(fileIdsDir,'w');
                fprintf(fid, '%s\r\n', injectParameters{:});
                fclose(fid);
                
                % call fractal coding process
                system(['java -cp ".;lib/*;audio-compressor-0.0.1.jar"' ...
                    ' th.ac.kmitl.it.prip.fractal.MainExecuter ' ...
                    fileIdsDir], '-echo');
                
            end
        end
    end
end



