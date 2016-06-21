close all
Fc = 300;
Fs = 500;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.050;             % seconds
t = (0:dt:StopTime-dt)';     % seconds


x = 0.3*sin(2*pi*Fc*t);
f1 = figure(1);
plot(interp(t,8),interp(x,8),'LineWidth',1,'MarkerSize',2);
hold on
stem(t,x,'LineWidth',1);
axis([0 0.028 -0.5 0.5]);
title('low sampling rate')
xlabel('time')
ylabel('amplitude')
set(f1, 'Position', [100, 100, 600, 200]);

Fs = 1000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:StopTime-dt)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
f2 = figure(2);
plot(interp(t,4),interp(x,4),'LineWidth',1,'MarkerSize',2);
hold on
stem(t,x,'LineWidth',1);
axis([0 0.028 -0.5 0.5]);
title('high sampling rate')
xlabel('time')
ylabel('amplitude')
set(f2, 'Position', [100, 100, 600, 200]);


Fs = 6000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:StopTime-dt)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
f3 = figure(3);
plot(t,x,'LineWidth',1,'MarkerSize',2);
% hold on
% stem(t,x,'LineWidth',1);
axis([0 0.028 -0.5 0.5]);
title('continuous signal')
xlabel('time')
ylabel('amplitude')
set(f3, 'Position', [100, 100, 600, 200]);
