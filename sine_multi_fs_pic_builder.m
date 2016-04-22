close all
Fc = 400;
Fs = 2133;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.0050;             % seconds
t = (0:dt:StopTime-dt)';     % seconds


x = 0.3*sin(2*pi*Fc*t);
figure(1);
plot(t,x,'LineWidth',7,'MarkerSize',7);
hold on
stem(t,x,'LineWidth',5);
axis([0 0.00375 -0.5 0.5]);
title('sampling rate low')
xlabel('time')
ylabel('amplitude')

Fs = 3195;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.0050;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
figure(2);
plot(t,x,'LineWidth',7,'MarkerSize',7);
hold on
stem(t,x,'LineWidth',5);
axis([0 0.00375 -0.5 0.5]);
title('sampling rate high')
xlabel('time')
ylabel('amplitude')


Fs = 4266;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.0050;             % seconds
t = (0:dt:StopTime-dt)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
figure(3);
plot(t,x,'LineWidth',7,'MarkerSize',7);
hold on
stem(t,x,'LineWidth',5);
axis([0 0.00375 -0.5 0.5]);
title('sampling rate high')
xlabel('time')
ylabel('amplitude') 
