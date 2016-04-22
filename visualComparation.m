% pic builder
mfccparams;
bandparams;
HF = 6000;
MFCC_PARAMS_STR = ['_MEL_' num2str(M) '_HF_' num2str(HF) '_CC_' num2str(C)];
% DATA_SET = '_SEL_NECTEC_MR_4_128_INT_Thesh1E-3AA2';
% DATA_SET = 'k_NECTEC_MR';


for fIdx = 17
    DFPS = 8000;
    DATA_SET = 'k_ARMS_REC_INT';
    filesList_BASE = importdata(['F:\IFEFSR\' ...
        num2str(floor(DFPS/1000)) DATA_SET '.txt']);
    [signal,Fs] = audioread(filesList_BASE{fIdx});
    [ CC,FBE, OUTMAG, MAG, H, DCT] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    figure(1),
    subplot(1,3,1),imagesc([OUTMAG; zeros(128,size(OUTMAG,2))]);
    title('Frequecy analysis Fs = 8kHz');
    ylabel('Frequency order');
    xlabel('Frame number');
    
    figure(2),
    subplot(1,3,1),imagesc(FBE,[0,max(FBE(:))]);
    title('Mel spectrum Fs = 8kHz');
    ylabel('Channel order');
    xlabel('Frame number');
    
    figure(3),
    subplot(1,3,1),imagesc(CC);
    title('MFCC Fs = 8kHz');
    ylabel('CC order');
    xlabel('Frame number');
    
    
    DFPS = 16000;
    filesList_BASE = importdata(['F:\IFEFSR\' ...
        num2str(floor(DFPS/1000)) DATA_SET '.txt']);
    [signal,Fs] = audioread(filesList_BASE{fIdx});
    [ CC,FBE, OUTMAG, MAG, H, DCT] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    figure(1),
    subplot(1,3,2),imagesc(OUTMAG);
    title('Frequecy analysis Fs = 16kHz');
    ylabel('Frequency order');
    xlabel('Frame number');
    
    figure(2),
    subplot(1,3,2),imagesc(FBE,[0,max(FBE(:))]);
    title('Mel spectrum Fs = 16kHz');
    ylabel('Channel order');
    xlabel('Frame number');
    
    figure(3),
    subplot(1,3,2),imagesc(CC);
    title('MFCC Fs = 16kHz');
    ylabel('CC order');
    xlabel('Frame number');
    
    
    EFPS = 8000;
    DFPS = 16000;
    DATA_SET = '_ARMS_REC_INT_Thesh1E-4AA2';
    filesList_FC = importdata(['F:\IFEFSR\' num2str(floor(EFPS/1000)) 'to' ...
        num2str(floor(DFPS/1000)) DATA_SET '.txt']);
    [signal,Fs] = audioread(filesList_FC{fIdx});
    [ CC,FBE, OUTMAG, MAG, H, DCT] = mfcc( signal, Fs,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
    figure(1),
    subplot(1,3,3),imagesc(OUTMAG);
%     colormap gray
%     colormap(flipud(colormap))
%     colormap([1,1,1; 0,0,1; 1,0,0 ])
    title('Frequecy analysis Fs = 8->16kHz');
    ylabel('Frequency order');
    xlabel('Frame number');
    
    figure(2),
    subplot(1,3,3),imagesc(FBE,[0,max(FBE(:))]);
    title('Mel spectrum Fs = 8->16kHz');
    ylabel('Channel order');
    xlabel('Frame number');
    
    figure(3),
    subplot(1,3,3),imagesc(CC);
    title('MFCC Fs = 8->16kHz');
    ylabel('CC order');
    xlabel('Frame number');
    
    
end

