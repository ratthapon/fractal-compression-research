% nectec wav builder
mfccparams;
for params_Thresh = [-3];
    for params_AA = [2]
        paramsText = [num2str(params_Thresh) 'AA' num2str(params_AA) ];
        for EFPS = [8000 16000];
            inFilesList = importdata(['F:\IFEFSR\' num2str(EFPS/1000) ...
                'k_SEL_NECTEC_MR_4_128_INT_Thesh1E' paramsText '_code.txt']);
            for DFPS = [8000 16000];
                fos = fopen(['F:\IFEFSR\' num2str(EFPS/1000) 'to' num2str(DFPS/1000)...
                    '_SEL_NECTEC_MR_4_128_INT_Thesh1E' paramsText '.txt'],'w');
                dirName = ['F:\IFEFSR\Recognition analysis\' num2str(EFPS/1000) ...
                    'to' num2str(DFPS/1000) '_SEL_NECTEC_MR_4_128_INT\1E' paramsText '\'];
                mkdir(dirName);
                for fIdx = 1:size(inFilesList,1);
                    load(inFilesList{fIdx});
                    fileName = [ dirName num2str(fIdx) '.wav'];
                    y = decompressAPAA(f,EFPS,DFPS,15);
                    [ CC,FBE, OUTMAG, MAG] = mfcc( y, DFPS,...
                        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                    
                    figure(1),
                    subplot(1,2,1),imagesc(MAG);
                    subplot(3,2,2),imagesc(OUTMAG);
                    subplot(3,2,4),imagesc(FBE);
                    subplot(3,2,6),imagesc(CC);
                    colormap('gray')
                    
                    y = ((y - mean(y)) / (2^15));
                    
                    [ CC,FBE, OUTMAG, MAG] = mfcc( y, DFPS,...
                        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
                    figure(2),
                    subplot(1,2,1),imagesc(MAG);
                    subplot(3,2,2),imagesc(OUTMAG);
                    subplot(3,2,4),imagesc(FBE);
                    subplot(3,2,6),imagesc(CC);
                    colormap('gray')
                    %                     figure(1),plot(y);
                    audiowrite(fileName,y,DFPS);
                    fprintf(fos,'%s\r\n',fileName);
                end
                fclose(fos);
            end
        end
        
    end
end