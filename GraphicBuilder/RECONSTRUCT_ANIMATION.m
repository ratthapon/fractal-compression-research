%% generate signal and other information
Fc = 650;
Fs = 8000;
dt = 1/Fs;                   % seconds per sample
StopTime = 0.050;             % seconds
t = (0:dt:1.5)';     % seconds
hsignal = 20*sin(2*pi*Fc*t);
hsignal = hsignal(1:200);
hpart = 4*ones(size(hsignal, 1)/4, 1);
sampleIdx = 1:size(t,1);
dScale = 2;
try
    FCEncodeCPU;
    close all;
catch
end

%% plot original signal
f1 = figure(1);
plot(hsignal);
hold on
stem(hsignal);
axis([1 32 -20 20])
title(['iteration ' num2str(iter)])

set(f1, 'Position', [100, 100, 300, 150]);
set(gca,'XTick',sampleIdx);
set(gca,'XTickLabel',sampleIdx);
set(gca,'position',[0 0 1 0.8],'units','normalized')
set(f1, 'PaperPositionMode', 'auto');
saveas(f1, ['C:\Project\IFEFSR\Presentation\Con1\ori\Original signal.jpg']);

%% zxc
for iter = 0:15
    %     close all
    %% normal reconstruct
    QR_SIG = decompressAudioFC(FC_QR,8000,8000,iter);
    b1 = fir1(8,0.4);
    QR_SIG = filtfilt(b1,1,QR_SIG);       % Zero-phase digital filtering
    
    % amplifying
    gain = 1.3;
    QR_SIG = QR_SIG * gain;
    
    f2 = figure(2);
    hold off
    plot(QR_SIG);
    hold on
    stem(QR_SIG);
    axis([1 32 -20 20])
    title(['iteration ' num2str(iter)])
    
    set(f2, 'Position', [100, 100, 300, 150]);
    set(gca,'XTick',sampleIdx);
    set(gca,'XTickLabel',sampleIdx);
    set(gca,'position',[0 0 1 0.8],'units','normalized')
    set(f2, 'PaperPositionMode', 'auto');
    saveas(f2, ['C:\Project\IFEFSR\Presentation\Con1\recon\' num2str(iter) '.jpg']);
    
    %% higher reconstruct
    QR_SIG = decompressAudioFC(FC_QR,8000,16000,iter);
    b1 = fir1(8,0.4);
    QR_SIG = filtfilt(b1,1,QR_SIG);       % Zero-phase digital filtering
    
    % amplifying
    gain = 1.2;
    QR_SIG = QR_SIG * gain;
    
    f2 = figure(2);
    hold off
    plot(QR_SIG);
    hold on
    stem(QR_SIG);
    axis([1 64 -20 20])
    title(['iteration ' num2str(iter)])
    
    set(f2, 'Position', [100, 100, 300, 150]);
    set(gca,'XTick',sampleIdx);
    set(gca,'XTickLabel',sampleIdx);
    set(gca,'position',[0 0 1 0.8],'units','normalized')
    set(f2, 'PaperPositionMode', 'auto');
    saveas(f2, ['C:\Project\IFEFSR\Presentation\Con1\recon_1\' num2str(iter) '.jpg']);
end

%%
hold off
f3 = figure(3),
stem(1:2:26, hsignal(1:2:26),'linewidth', 2)
hold on
plot(hsignal,'linewidth', 2)
axis([1 25.5 -20 20])
set(f3, 'Position', [100, 100, 300, 150]);
set(gca,'position',[0 0 1 1],'units','normalized')
set(f3, 'PaperPositionMode', 'auto');
saveas(f3, ['C:\Project\IFEFSR\Presentation\Con1\ori\Original signal no header.jpg']);

hold off
f4 = figure(4),
stem(1:2:52, QR_SIG(1:2:52),'linewidth', 2)
hold on
plot(QR_SIG,'linewidth', 2)
axis([1 51 -20 20])
set(f4, 'Position', [100, 100, 300, 150]);
set(gca,'position',[0 0 1 1],'units','normalized')
set(f4, 'PaperPositionMode', 'auto');
saveas(f4, ['C:\Project\IFEFSR\Presentation\Con1\ori\Reconstruct signal no header.jpg']);

%%