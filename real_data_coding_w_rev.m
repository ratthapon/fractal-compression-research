%% Time specifications:
for FPC = [4]
    %% Sine wave:
    [x,Fq] = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
        '\16\CF001_Va001\CF001_Va001_001.wav']);
    %     x = x - min(x);
    % load(['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly_w_rev.mat']);
    x = x(8001:10000);
    
    % Plot the signal versus time:
    figure(1);
    subplot(3,1,1),plot(x);
    axis([1 1000 -0.2 0.5]);
%     axis([1 8000 -0.2 0.5]);
    xlabel('n samples sampling 16k');
    title(['Frequency ' num2str(Fq) ' original']);
    
    %% linear
    fP1 = compressPower1(x,FPC);
    nWavP1 = decompressPower1(fP1,Fq,FPC,Fq,[]);
    figure(1),subplot(3,1,2),plot(nWavP1);
    axis([1 1000 -0.2 0.5]);
%     axis([1 8000 -0.2 0.5]);
    xlabel('n samples');
    title(['Frequency ' num2str(Fq) ' block size ' num2str(FPC) ...
        ' linear snr=' num2str(snr(nWavP1,x)) ' psnr=' num2str(PSNR(nWavP1,x))]);
    %     linearF = [linearF; f];
    
    % power 2
    fP2  = compressPower2(x,FPC);
    nWavP2 = decompressPower2(fP2,Fq,FPC,Fq,[]);
    figure(1),subplot(3,1,3),plot(nWavP2);
    axis([1 1000 -0.2 0.5]);
%     axis([1 8000 -0.2 0.5]);
    xlabel('n samples');
    title(['Frequency ' num2str(Fq) ' range block size ' num2str(FPC) ...
        ' p2 snr=' num2str(snr(nWavP2,x)) ' psnr=' num2str(PSNR(nWavP2,x))]);
    %     polyF = [polyF; f];
    
    % varrianve of data in block
    %     figure(1),subplot(4,1,4),plot(std(reshape(x(901:1000,:),FPC,25)));
    %     axis([1 25 -inf inf]);
    %     xlabel('nth block');
    %     title(['Variance of block']);
    
    save(['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly_w_rev.mat']);
    saveas(gcf,['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly_w_rev.fig']);
    saveas(gcf,['F:\IFEFSR\RealData\Graph\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly_w_rev.jpg']);
end