%% Sphinx 5 feat extraction
FEAT_PARAMS;
outPrefix = 'F:/IFEFSR/ExpSphinx/';
featExtractor = 'Sphinx5Feat';
t = tic;
for ds = 1:2
    dataSet = DATASETs{ds};
    for alpha = ALPHAs
        for C = Cs
            for M = Ms
                for a = As
                    for HF = HFs
                        %% make directory
                        if (C==30), expCase = 'caseA' ; elseif (C==13), expCase = 'caseB'; end;
                        if (a==1), dataCase = 'origin' ; elseif (a==2), dataCase = 'cross'; end;
                        alphaStr = num2str(alpha*100);
                        outDir = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4']
                        mkdir(outDir);
                        mkdir([outDir '/fig/']);
                        mkdir([outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4_clstk']);
                        mkdir([outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4test_clstk']);
                        
                        %% copy wav folder
                        %                     if (a == 2) && strcmp(dataSet, 'FC')
                        %                         srcPath = 'F:\IFEFSR\ExpSphinx\FC1616\wav\an4_clstk';
                        %                         destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4_clstk'];
                        %                         copyfile(srcPath, destPath, 'f');
                        %                         srcPath = 'F:\IFEFSR\ExpSphinx\FC816\wav\an4test_clstk';
                        %                         destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4test_clstk'];
                        %                         copyfile(srcPath, destPath, 'f');
                        %                     elseif strcmp(dataSet, 'FC')
                        %                         srcPath = 'F:\IFEFSR\ExpSphinx\FC1616\wav\an4_clstk';
                        %                         destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4_clstk'];
                        %                         copyfile(srcPath, destPath, 'f');
                        %                         srcPath = 'F:\IFEFSR\ExpSphinx\FC1616\wav\an4test_clstk';
                        %                         destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4test_clstk'];
                        %                         copyfile(srcPath, destPath, 'f');
                        
                        %                                             if (a == 2)
                        %                                                 srcPath = 'F:\IFEFSR\SpeechData\an4\wav\an4_clstk';
                        %                                                 destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4_clstk'];
                        %                                                 copyfile(srcPath, destPath, 'f');
                        %                                                 srcPath = 'F:\IFEFSR\SpeechData\an4_8k\wav\an4test_clstk';
                        %                                                 destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4test_clstk'];
                        %                                                 copyfile(srcPath, destPath, 'f');
                        %                                             else
                        %                                                 srcPath = 'F:\IFEFSR\SpeechData\an4\wav\an4_clstk';
                        %                                                 destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4_clstk'];
                        %                                                 copyfile(srcPath, destPath, 'f');
                        %                                                 srcPath = 'F:\IFEFSR\SpeechData\an4\wav\an4test_clstk';
                        %                                                 destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/wav/an4test_clstk'];
                        %                                                 copyfile(srcPath, destPath, 'f');
                        %                                             end
                        %
                        %% copy etc folder and config file
%                         srcPath = 'F:/IFEFSR/ExpSphinx/etc/';
%                         destPath = [outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4/etc/'];
%                         copyfile(srcPath, destPath, 'f');
%                         SPHINX_TRAIN_CFG;
                        
                        %% gen sphinx run scripts
                        cmd = [{['cd /d ' outPrefix expCase '/' featExtractor '/' dataCase '/' dataSet '/A' alphaStr '/an4']},...
                            {'python F:/IFEFSR/Sphinx/sphinxtrain/scripts/sphinxtrain run'}];
                        cmdFileName = ['F:\IFEFSR\ExpSphinx\Sphinx5Feat_' expCase '_' dataCase '_' dataSet '_' alphaStr '.bat'];
                        fileID = fopen(cmdFileName,'w');
                        fprintf(fileID,'%s\n',cmd{:});
                        fclose(fileID);
                    end
                end
            end
        end
    end
end
time = toc(t);



