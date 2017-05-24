
%%
close all
Fc = 1;
Fs = 30;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.050;             % seconds
t = (0:dt:1)';     % seconds

pulse = 0.3*sin(2*pi*Fc*t);

silentSig = zeros(1, 100);

selfSimSig = silentSig';
selfSimSig(10:40) = pulse;
selfSimSig(60:90) = pulse;
figure, plot(selfSimSig);

contractedSig = silentSig';
contractedSig(10:40) = 3*pulse;
contractedSig(60:90) = pulse;
figure, plot(contractedSig);




