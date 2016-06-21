%%
close all
Fc = 1;
Fs = 10;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.050;             % seconds
t = (0:dt:1.5)';     % seconds


x = 0.3*sin(2*pi*Fc*t);
sampleIdx = 1:size(t,1);
f1 = figure(1);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
% set(gca, 'YTick', []);
hold on
stem(sampleIdx-1,x(sampleIdx),'LineWidth',1);
% set(gca, 'YTick', []);
axis([0 15 -0.5 0.5]);
title('Original domain blocks')
xlabel('sample')
ylabel('amplitude')
set(f1, 'Position', [100, 100, 400, 125]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 1],'units','normalized')

%%
Fs = 5;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:1.6)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
sampleIdx = 1:size(t,1);
f2 = figure(2);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
% set(gca, 'YTick', []);
set(gca, 'YTick', []);
hold on
stem(sampleIdx-1,x(sampleIdx),'LineWidth',1);
axis([0 7.5 -0.5 0.5]);
title('Reconstructed domain blocks')
set(gca, 'YTick', []);
xlabel('sample')

ylabel('amplitude')
set(f2, 'Position', [100, 100, 400, 125]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 1],'units','normalized')

%%

Fs = 100;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:1.5)';     % seconds
x = 0.3*sin(2*pi*Fc*t);
f3 = figure(3);
plot(t,x,'LineWidth',1,'MarkerSize',2);
% hold on
% stem(t,x,'LineWidth',1);
axis([0 1 -0.5 0.5]);
% title('continuous signal')
xlabel('time')
ylabel('amplitude')
set(f3, 'Position', [100, 100, 400, 125]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 1],'units','normalized')
