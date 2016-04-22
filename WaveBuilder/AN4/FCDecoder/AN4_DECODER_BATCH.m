FEAT_PARAMS;
fileListS = [{importdata('F:\IFEFSR\AudioFC\an4traintest.txt')}, ...
    {importdata('F:\IFEFSR\AudioFC\an4test.txt')}];
inDirS = [{'F:\IFEFSR\AudioFC\FC\AN4_8K_CURVEFIT_LM\'}, ...
    {'F:\IFEFSR\AudioFC\FC\QR\AN4_16K\'}];
outPrefix = 'F:/IFEFSR/ExpSphinx/';
dataSet = 'FC';
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
                    
%                     AN4_DECODER;
                    
                    %                     %% copy 16k features folder
                    %                     if (a==1)
                    %                         srcPath = outDir;
                    %                         destPath = [outPrefix expCase '/MatlabFeat/cross/' dataSet '/A' alphaStr '/an4'];
                    %                         copyfile(srcPath, destPath, 'f');
                    %                     end
                    %% copy train wav folder
                    srcPath = 'F:\IFEFSR\ExpSphinx\FC1616_LOWPASS_2\wav\an4_clstk';
                    destPath = [outPrefix expCase '/Sphinx5Feat/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4_clstk'];
                    copyfile(srcPath, destPath, 'f');
                    %% copy test wav folder
                    srcPath = 'F:\IFEFSR\ExpSphinx\FC1616_LOWPASS_2\wav\an4test_clstk';
                    if (a==2)
                        srcPath = 'F:\IFEFSR\ExpSphinx\FC816_LOWPASS_2\wav\an4test_clstk';
                    end
                    destPath = [outPrefix expCase '/Sphinx5Feat/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4test_clstk'];
                    copyfile(srcPath, destPath, 'f');
                    
                    %% copy etc folder and config file
                    srcPath = 'F:/IFEFSR/ExpSphinx/etc/';
                    destPath = [outPrefix expCase '/Sphinx5Feat/' dataCase '/' dataSet '/A' alphaStr '/an4/etc/'];
                    copyfile(srcPath, destPath, 'f');
                    % SPHINX_TRAIN_CFG;
                    
                    %% gen sphinx run scripts
                    cmd = [{['cd /d ' outPrefix expCase '/Sphinx5Feat/' dataCase '/' dataSet '/A' alphaStr '/an4']},...
                        {'python F:/IFEFSR/Sphinx5/sphinxtrain/scripts/sphinxtrain run'}];
                    cmdFileName = ['F:\IFEFSR\ExpSphinx\MatlabFeat_' expCase '_' dataCase '_' dataSet '_' alphaStr '.bat'];
                    fileID = fopen(cmdFileName,'w');
                    fprintf(fileID,'%s\n',cmd{:});
                    fclose(fileID);
                end
            end
        end
    end
end
time = toc(t)

