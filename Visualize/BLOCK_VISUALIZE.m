close all
Fc = 230;
Fs = 500;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.050;             % seconds
t = (0:dt:StopTime-dt)';     % seconds


x = 0.3*sin(2*pi*Fc*t);
f1 = figure(1);
plot(interp(t,8),interp(x,8),'LineWidth',1,'MarkerSize',2);
set(gca, 'YTick', []);
hold on
stem(t,x,'LineWidth',1);
set(gca, 'YTick', []);
axis([0 0.018 -0.5 0.5]);
title('Original domain blocks')
xlabel('sample')
ylabel('amplitude')
set(f1, 'Position', [100, 100, 600, 125]);
set(gca,'XTickLabel',1:size(interp(x,8),1));

Fs = 1000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:StopTime-dt)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
f2 = figure(2);
plot(interp(t,4),interp(x,4),'LineWidth',1,'MarkerSize',2);
set(gca, 'YTick', []);
hold on
stem(t,x,'LineWidth',1);
axis([0 0.019 -0.5 0.5]);
title('Reconstructed domain blocks')
set(gca, 'YTick', []);
xlabel('sample')
ylabel('amplitude')
set(f2, 'Position', [100, 100, 600, 125]);
set(gca,'XTickLabel',1:2:size(interp(x,8),1));



Fs = 6000;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:StopTime-dt)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
f3 = figure(3);
plot(t,x,'LineWidth',1,'MarkerSize',2);
% hold on
% stem(t,x,'LineWidth',1);
axis([0 0.022 -0.5 0.5]);
% title('continuous signal')
xlabel('time')
ylabel('amplitude')
set(f3, 'Position', [100, 100, 600, 200]);
