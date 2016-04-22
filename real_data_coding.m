%% Time specifications:
for FPC = [4]
    %% Sine wave:
    [x,Fq] = audioread(['F:\IFEFSR\SpeechData\NECTEC_matlabResampling' ...
        '\16\CF001_Va001\CF001_Va001_001.wav']);
%     load(['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly.mat']);
    x = x(901:2000);

    % Plot the signal versus time:
    figure(1);
    subplot(3,1,3),plot(x);
    for cumulative=1:FPC:size(x,1)
        linesX = [cumulative cumulative];
        linesY = [-1 1];
        line(linesX,linesY);
    end
    axis([1 8000 -0.2 0.5]);
    xlabel('n samples sampling 16k');
    title(['Frequency ' num2str(Fq) ' original']);
    
    %% linear
%     fP1 = fractalCompress(x,FPC,1);
    nWavP1 = fractalDecode(fP1,Fq,FPC,1,Fq,[],[]);
    figure(1),subplot(3,1,2),plot(nWavP1);
    for cumulative=1:FPC:size(x,1)
        linesX = [cumulative cumulative];
        linesY = [-1 1];
        line(linesX,linesY);
    end
   axis([1 8000 -0.2 0.5]);
    xlabel('n samples');
    title(['Frequency ' num2str(Fq) ' block size ' num2str(FPC) ...
        ' linear snr=' num2str(snr(nWavP1,x)) ' psnr=' num2str(PSNR(nWavP1,x))]);
%     linearF = [linearF; f];
    
    % power 2
%     fP2  = compressPower2(x,FPC);
    nWavP2 = decompressPower2(fP2,Fq,FPC,Fq,[]);
    figure(1),subplot(3,1,3),plot(nWavP2);
    for cumulative=1:FPC:size(x,1)
        linesX = [cumulative cumulative];
        linesY = [-1 1];
        line(linesX,linesY);
    end
    axis([901 1000 -0.5 0.5]);
    xlabel('n samples');
    title(['Frequency ' num2str(Fq) ' range block size ' num2str(FPC) ...
        ' p2 snr=' num2str(snr(nWavP2,x)) ' psnr=' num2str(PSNR(nWavP2,x))]);
%     polyF = [polyF; f];
    
    % varrianve of data in block 
%     figure(2),plot(std(reshape(x(901:1000,:),FPC,25)));
%     axis([1 25 -inf inf]);
%     xlabel('nth block');
%     title(['Variance of block']);
%     
    save(['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly.mat']);
    saveas(gcf,['F:\IFEFSR\RealData\Mat\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly.fig']);
    saveas(gcf,['F:\IFEFSR\RealData\Graph\RealData_Fq' num2str(Fq) '_Fs' num2str(FPC) '_poly.jpg']);
end