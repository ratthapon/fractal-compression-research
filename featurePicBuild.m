% pic builder
mfccparams;
bandparams;
HF = 5500;
MFCC_PARAMS_STR = ['_MEL_' num2str(M) '_HF_' num2str(HF) '_CC_' num2str(C)];
% DATA_SET = '_SEL_NECTEC_MR_4_128_INT_Thesh1E-3AA2';
DATA_SET = 'k_NECTEC_MR';
% DATA_SET = '_ARMS_REC_INT_Thesh1E-4AA2';
DFPS_SET = [8000 16000 ]; % resampling rate to frame per second
EFPS_SET = [8000 16000]; % base sampling rate frame per second
for EFPS = EFPS_SET
    for DFPS = DFPS_SET
%                 filesList = importdata(['F:\IFEFSR\' num2str(floor(EFPS/1000)) 'to' ...
%                     num2str(floor(DFPS/1000)) DATA_SET '.txt']);
%                 dir = ['F:\IFEFSR\Recognition analysis\Feature analysis\' num2str(floor(EFPS/1000)) 'to' ...
%                     num2str(floor(DFPS/1000)) ...
%                     DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND'];
        filesList = importdata(['F:\IFEFSR\' ...
            num2str(floor(DFPS/1000)) DATA_SET '.txt']);
        dir = ['F:\IFEFSR\Recognition analysis\Feature analysis\' ...
            num2str(floor(DFPS/1000)) ...
            DATA_SET MFCC_PARAMS_STR '_' SUBBAND 'BAND'];
        mkdir(dir);
        for i=1:1 %size(filesList,1)
            
            %% load audio signal
            [signal,Fs] = audioread(filesList{i});
            %             signal = downsample(signal,4);
            %             signal = upsample(signal,4);
            
            %% Feature extraction (feature vectors as columns)
            [ CC,FBE, OUTMAG, MAG, H, DCT] = mfcc( signal, Fs,...
                Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
            
            figure(3),
            subplot(1,2,1),imagesc(MAG);
            subplot(3,2,2),imagesc(OUTMAG);
            subplot(3,2,4),imagesc(FBE);
            subplot(3,2,6),imagesc(CC);
            
            if Fs == 8000
                temp_H = [H zeros(22,128)];
                for i =1:M
                    hold on
                    figure(4),
                    subplot(2,1,1),plot(0:8000/256:8000,temp_H(i,:))
                end
                hold off
                title('Mel filter Fs = 8kHz');
                xlabel('Frequency (F0)');
                ylabel('Weight');
                
                figure(5),
                subplot(1,2,1),imagesc([OUTMAG; zeros(128,size(OUTMAG,2))]);
                title('Frequecy analysis Fs = 8kHz');
                ylabel('Frequency order');
                xlabel('Frame number');
                
                figure(6),
                subplot(1,2,1),imagesc(FBE,[0,max(FBE(:))]);
                title('Mel spectrum Fs = 8kHz');
                ylabel('Frequency order');
                xlabel('Frame number');
                
                figure(7),
                subplot(1,2,1),imagesc(CC);
                title('MFCC Fs = 8kHz');
                ylabel('CC order');
                xlabel('Frame number');
                
%                 figure(5),subplot(2,1,1),imagesc(temp_H);
%                 set(gca,'XLim',[1 256])
%                 set(gca,'XTick',0:8000/256:8000)
            else
                for i =1:M
                    hold on
                    figure(4),
                    subplot(2,1,2),plot(0:8000/256:8000,H(i,:))
                end
                hold off
                title('Mel filter Fs = 16kHz');
                xlabel('Frequency (F0)');
                ylabel('Weight');
                
                figure(5),
                subplot(1,2,2),imagesc(OUTMAG);
                title('Frequecy analysis Fs = 16kHz');
                ylabel('Frequency order');
                xlabel('Frame number');
                
                figure(6),
                subplot(1,2,2),imagesc(FBE,[0,max(FBE(:))]);
                title('Mel spectrum Fs = 16kHz');
                ylabel('Frequency order');
                xlabel('Frame number');
                
                figure(7),
                subplot(1,2,2),imagesc(CC);
                title('MFCC Fs = 16kHz');
                ylabel('CC order');
                xlabel('Frame number');
% 
%                 figure(5),subplot(2,1,2),imagesc(H);
%                 set(gca,'XTick',0:100:8000)
            end
            %             saveas(gcf,[dir '\Feature_' num2str(i) '.jpg'],'jpg');
            
        end
    end
end