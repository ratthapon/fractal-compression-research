
linearF = [];
polyF = [];
for FPC = [4]
    for Fc = 300:250:5500
        %% Sine wave:
        load(['F:\IFEFSR\BasicSine_linear\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '.mat']);
        % Plot the signal versus time:
        figure(1);
        subplot(5,1,1),plot(x,'b*-');
        
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples sampling 16k');
        title(['Frequency ' num2str(Fc) ' block size ' num2str(FPC) ' original']);
        
        figure(1),subplot(5,1,2),plot(nWav,'b*-');
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' block size ' num2str(FPC) ...
            ' linear snr=' num2str(snr(nWav,x)) ' psnr=' num2str(PSNR(nWav,x))]);
        linearF = [linearF; f];
        
        load(['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.mat']);
        figure(1),subplot(5,1,3),plot(nWav,'b*-');
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ...
            ' poly snr=' num2str(snr(nWav,x)) ' psnr=' num2str(PSNR(nWav,x))]);
        polyF = [polyF; f];
        
        load(['F:\IFEFSR\BasicSine_p3\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.mat']);
        figure(1),subplot(5,1,4),plot(nWav,'b*-');
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ...
            ' poly snr=' num2str(snr(nWav,x)) ' psnr=' num2str(PSNR(nWav,x))]);
%         polyF = [polyF; f];
        
        figure(1),subplot(5,1,5),plot(std(reshape(x(1:100,:),FPC,25)));
        axis([1 25 -inf inf]);
        saveas(gcf,['F:\IFEFSR\BasicSine_compet\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.fig']);
        saveas(gcf,['F:\IFEFSR\BasicSine_compet\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.jpg']);
    end
end