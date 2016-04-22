% speed test
%% Time specifications:
Fs = 16000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.10;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
tic
for FPC = [4 8 16]
    for Fc = 300:250:5500
        %% Sine wave:
        %         Fc = 5000;                     % hertz
        x = 0.3*sin(2*pi*Fc*t);
        
        f  = compressPower2(x,FPC);
    
    end
end
time = toc