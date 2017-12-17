%%
close all
Fc = 1;
Fs = 15;                   % samples per second
dt = 1/Fs;                   % seconds per sample
StopTime = 0.050;             % seconds
t = (0:dt:1.5)';     % seconds

figSize = [100, 100, 300, 100];

x0 = 0.2*sin(2*pi*Fc*t);
x1 = 0.2*sin(2*pi*Fc*2.5*t);

x = x0 + x1;
sampleIdx = 1:size(t,1);
f1 = figure(1);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
axis([0 15 -0.5 0.5]);
set(f1, 'Position', figSize);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[-0.01 -0.1 1.02 1.2],'units','normalized')

f2 = figure(2);
plot(sampleIdx-1,x0(sampleIdx),'LineWidth',1,'MarkerSize',2);
axis([0 15 -0.5 0.5]);
set(f2, 'Position', figSize);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[-0.01 -0.1 1.02 1.2],'units','normalized')

f3 = figure(3);
plot(sampleIdx-1,x1(sampleIdx),'LineWidth',1,'MarkerSize',2);
axis([0 15 -0.5 0.5]);
set(f3, 'Position', figSize);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[-0.01 -0.1 1.02 1.2],'units','normalized')


