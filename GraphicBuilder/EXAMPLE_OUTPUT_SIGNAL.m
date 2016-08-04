close all; clear all;

%% sig without partition
Fc = 1;
Fs = 10;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:3)';     % seconds

x = 0.3*sin(2*pi*Fc*t);
sampleIdx = 1:size(t,1);
f3 = figure(3);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
% set(gca, 'YTick', []);
hold on
stem(sampleIdx-1,x(sampleIdx),'LineWidth',1);
% set(gca, 'YTick', []);
axis([0 size(t,1)-1 -0.5 0.5]);
title('Original domain blocks')
xlabel('sample')
ylabel('amplitude')
set(f3, 'Position', [100, 100, 800, 200]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 1],'units','normalized')

%% ideal result
Fc = 1;
Fs = 10;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:3)';     % seconds

x = 0.3*sin(2*pi*Fc*t);
sampleIdx = 1:size(t,1);
f1 = figure(1);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
% set(gca, 'YTick', []);
hold on
stem(sampleIdx-1,x(sampleIdx),'LineWidth',1);
for i = 0:(Fs/2):size(t, 1)
   xcoord = i;
   line([xcoord xcoord], [-0.5 0.5]);
end
% set(gca, 'YTick', []);
axis([0 size(t,1)-1 -0.5 0.5]);
title('Original domain blocks')
xlabel('sample')
ylabel('amplitude')
set(f1, 'Position', [100, 100, 800, 200]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 1],'units','normalized')

%%
Fc = 1;
Fs = 5;                   % samples per second
dt = 1/Fs;                   % seconds per sample
t = (0:dt:3)';     % seconds

x = 0.3*sin(2*pi*Fc*t);
sampleIdx = 1:size(t,1);
f2 = figure(2);
plot(sampleIdx-1,x(sampleIdx),'LineWidth',1,'MarkerSize',2);
% set(gca, 'YTick', []);
hold on
stem(sampleIdx-1,x(sampleIdx),'LineWidth',1);
for i = 0:(Fs/2):size(t, 1)
   xcoord = i;
   line([xcoord xcoord], [-0.5 0.5]);
end
% set(gca, 'YTick', []);
axis([0 size(t,1)-1 -0.5 0.5]);
title('Original domain blocks')
xlabel('sample')
ylabel('amplitude')
set(f2, 'Position', [100, 100, 800, 200]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 1],'units','normalized')

%% gen test data
inFName = ['F:\IFEFSR\SpeechData\an4\wav\' ...
    'an4_clstk\fash\an251-fash-b.raw'];
inRecon = ['F:\IFEFSR\ExpSphinx\FC816\wav\an4_clstk\fash\an254-fash-b.raw'];
fid = fopen(inFName, 'r');
sig = fread(fid, 'int16');
sig = sig(6001:6064);
fclose(fid);
figure(3),plot(sig)
hold on,
stem(sig, ':r');