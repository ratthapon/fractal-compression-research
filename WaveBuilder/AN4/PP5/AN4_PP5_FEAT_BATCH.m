FEAT_PARAMS;
fileListS = [{importdata('F:\IFEFSR\AudioFC\an4traintest.txt')}, ...
    {importdata('F:\IFEFSR\AudioFC\an4traintest.txt')}];
inDirS = [{'F:\IFEFSR\SpeechData\an4_8k\wav\'}, ...
    {'F:\IFEFSR\SpeechData\an4\wav\'}];
outPrefix = 'F:/IFEFSR/ExpSphinx/';
dataSet = 'PP5_2';

t = tic;
for alpha = ALPHAs
    for C = Cs
        for M = Ms
            for a = As
                fileList = fileListS{a};
                for HF = HFs
                    %% make directory
                    inDir = inDirS{3 - a}
                    if (C==30), expCase = 'caseA' ; elseif (C==13), expCase = 'caseB'; end;
                    if (a==1), dataCase = 'origin' ; elseif (a==2), dataCase = 'cross'; end;
                    alphaStr = num2str(alpha*100);
                    outDir = [outPrefix expCase '/MatlabFeat/' dataCase '/' dataSet '/A' alphaStr '/an4']
                    mkdir(outDir);
                    mkdir([outDir '/fig/']);
                    
                    AN4_PP5_FEAT;
                    
                    %% copy 16k features folder
                    if (a==1)
                        srcPath = [outDir '/feat'];
                        destPath = [outPrefix expCase '/MatlabFeat/cross/' dataSet '/A' alphaStr '/an4'];
                        copyfile(srcPath, destPath, 'f');
                    end
                    
                    %% copy etc folder and config file
                    srcPath = 'F:/IFEFSR/ExpSphinx/etc/';
                    destPath = [outPrefix expCase '/MatlabFeat/' dataCase '/' dataSet '/A' alphaStr '/an4/etc/'];
                    copyfile(srcPath, destPath, 'f');
                    SPHINX_TRAIN_CFG;
                    
                    %% gen sphinx run scripts
                    cmd = [{['cd /d ' outPrefix expCase '/MatlabFeat/' dataCase '/' dataSet '/A' alphaStr '/an4']},...
                        {'python F:/IFEFSR/Sphinx/sphinxtrain/scripts/sphinxtrain run'}];
                    cmdFileName = ['F:\IFEFSR\ExpSphinx\MatlabFeat_' expCase '_' dataCase '_' dataSet '_' alphaStr '.bat'];
                    fileID = fopen(cmdFileName,'w');
                    fprintf(fileID,'%s\n',cmd{:});
                    fclose(fileID);
                end
            end
        end
    end
end
time = toc(t);

