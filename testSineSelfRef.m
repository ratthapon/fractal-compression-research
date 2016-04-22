%% Time specifications:
Fs = 16000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.0025;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
for FPC = [4]
    for Fc = 300
        %% Sine wave:
        %         Fc = 5000;                     % hertz
        x = 0.3*sin(2*pi*Fc*t);
        x = x(1:40);
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
%         [f R]  = fractalCompress(x,FPC,1);
        [f2]  = compressPower1(x,FPC);
        %         load(['F:\IFEFSR\BasicSine2\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.mat'],'f');
        nWav = fractalDecode(f,Fs,FPC,FPC*2,Fs,[],[]);
        figure(1),subplot(2,1,2),plot(nWav);
        for cumulative=1:FPC:size(x,1)
            linesX = [cumulative cumulative];
            linesY = [-1 1];
            line(linesX,linesY);
        end
        axis([1 100 -1 1]);
        xlabel('n samples');
        title(['Frequency ' num2str(Fc) ' range block size ' num2str(FPC) ' poly sampling 16k']);
        
        %         save(['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.mat']);
        %         saveas(gcf,['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.fig']);
        %         saveas(gcf,['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs' num2str(FPC) '_poly.jpg']);
        
        interCount = [];
        for fIdx = 1:size(f,1)
            domainReference = (fIdx-1)*FPC+1:fIdx*(FPC);
            rangeReference = f(fIdx,3):f(fIdx,3)+FPC-1;
            nIntersect = size(intersect(domainReference,rangeReference),2);
            interCount = [interCount nIntersect];
        end
        figure(2),bar(interCount);sum(interCount>0)
    end
end