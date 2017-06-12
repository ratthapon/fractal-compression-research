%% generate signal and other information
Fc = 130;                       % signal's frequency
Fs = 1100;                      % sample rate
dt = 1/Fs;                      % seconds per sample
t = (0:dt:1.5)';                % seconds
inSig = 20*sin(2*pi*Fc*t);
inSig = inSig(1:200);
gain = 1.0;
sampleIdx = 1:size(t(t < 2.5/Fc),1);


%% visualize each fs
for alpha = 1:2
    outSig = resample(inSig(sampleIdx), alpha, 1); % resampling
    OUTDAT{alpha} = outSig;
    
    % ploting
    figure(alpha), hold off;
    plot(outSig); hold on;
    stem(outSig);
    title(['iteration ' num2str(iter)]);
%     axis([1 32*alpha -20 20]);
    
    % set figure properties
    set(alpha, 'Position', [100, 100, 300, 150]);
    set(gca,'position',[0 0 1 0.8],'units','normalized');
    set(alpha, 'PaperPositionMode', 'auto');
end
