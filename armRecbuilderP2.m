% nectec wav builder
mfccparams;
tic
close all
for params_Thresh = [-4];
    for params_AA = [2]
        paramsText = [num2str(params_Thresh) 'AA' num2str(params_AA) ];
        for EFPS = [ 8000 16000];
            inFilesList = importdata(['F:\IFEFSR\' num2str(EFPS/1000) ...
                'k_ARMS_REC_INT_POLY_WOMAXCOEFF_Thesh1E' paramsText '_code.txt']);
            for DFPS = [8000 16000  ];
                fos = fopen(['F:\IFEFSR\' num2str(EFPS/1000) 'to' num2str(DFPS/1000)...
                    'k_ARMS_REC_INT_POLY_WOMAXCOEFF_Thesh1E' paramsText '.txt'],'w');
                dirName = ['F:\IFEFSR\Recognition analysis\' num2str(EFPS/1000) ...
                    'to' num2str(DFPS/1000) '_ARMS_REC_INT_POLY_WOMAXCOEFF\1E' paramsText '\'];
                mkdir(dirName);
                for fIdx = 1:size(inFilesList,1);
                    load(inFilesList{fIdx});
                    fileName = [ dirName num2str(fIdx) '.wav'];
                    y = decompressAPAAP2(f,EFPS,DFPS,15);
%                     figure,plot(y);
                    y = ((y/(2^15)));
                    figure(1),plot(y);
                    
                    [ CC,FBE, OUTMAG, MAG] = mfcc( y, DFPS,...
                        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                    
                    figure(2),
                    subplot(1,2,1),imagesc(MAG);
                    subplot(3,2,2),imagesc(OUTMAG);
                    subplot(3,2,4),imagesc(FBE);
                    subplot(3,2,6),imagesc(CC);
                    
                    audiowrite(fileName,y,DFPS);
                    fprintf(fos,'%s\r\n',fileName);
                end
                fclose(fos);
            end
        end
        
    end
end
time = toc