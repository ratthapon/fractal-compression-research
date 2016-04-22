%% Time specifications:
Fs = 16000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.05;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
for FPC = [4]
    for Fc = 300:250:5550
        %% Sine wave:
        %         Fc = 5000;                     % hertz
        x = 0.3*sin(2*pi*Fc*t);
        % Plot the signal versus time:
        figure(1);
        subplot(2,1,1),plot(x);
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ' poly sampling 16k']);
        f  = compressPower2(x,FPC);
%         load(['F:\IFEFSR\BasicSine2\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.mat'],'f');
        nWav = decompressPower2(f,Fc,FPC,Fc,[]);
        figure(1),subplot(2,1,2),plot(nWav);
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ' poly sampling 16k']);
        save(['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.mat']);
        saveas(gcf,['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.fig']);
        saveas(gcf,['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.jpg']);
    end
end