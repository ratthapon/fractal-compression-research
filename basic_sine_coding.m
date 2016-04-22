%% Time specifications:
Fs = 16000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.10;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
for FPC = [4 8 16]
    for Fc = 300:250:5500
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
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ' sampling 16k']);
        [f ] = fractalCompress(x,FPC,1);
%         load(['F:\IFEFSR\BasicSine\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '.mat'],'f');
        nWav = fractalDecode(f,Fs,FPC,1,Fs,[],[]);
        figure(1),subplot(2,1,2),plot(nWav);
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ' sampling 16k']);
        save(['F:\IFEFSR\BasicSine_linear\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '.mat']);
        saveas(gcf,['F:\IFEFSR\BasicSine_linear\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '.fig']);
        saveas(gcf,['F:\IFEFSR\BasicSine_linear\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '.jpg']);
    end
end