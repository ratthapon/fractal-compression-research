%% generate signal and other information
Fc = 130;                       % signal's frequency
Fs = 2000;                      % sample rate
dt = 1/Fs;                      % seconds per sample
t = (0:dt:1.5)';                % seconds
inSig = 20*sin(2*pi*Fc*t);
inSig = inSig(1:200);
gain = 1.0;

%% encode signal
rbs = 2;
sigParts = rbs * ones(size(inSig, 1)/rbs, 1);
% hpart = ADP(hsignal, [2 4], 1e-9);
sampleIdx = 1:size(t,1);
dScale = 2;
nCoeff = 2;
lambda = 0;
fc = FixAFCEncoder( inSig, sigParts, nCoeff, dScale, lambda);
OUTDAT = {};
subsample = 2;


%% visualize each iterations
for iter = 0:15
    %% reconstruction using alpha
    for alpha = 1:2
        outSig = decompressAudioFC(fc, 1, alpha, iter);
        outSig = outSig * gain; % amplifying
        OUTDAT{alpha}(:, iter + 1) = outSig(1:subsample: 32*alpha);
        
        % ploting
        figure(alpha), hold off;
        plot(outSig); hold on;
        stem(outSig);
        title(['iteration ' num2str(iter)]);
        axis([1 32*alpha -20 20]);
        
        % set figure properties
        set(alpha, 'Position', [100, 100, 300, 150]);
        set(gca,'position',[0 0 1 0.8],'units','normalized');
        set(alpha, 'PaperPositionMode', 'auto');
    end
end
