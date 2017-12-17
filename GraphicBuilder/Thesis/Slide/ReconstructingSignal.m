%% generate signal and other information
Fc = 100;                       % signal's frequency
Fs = 8000;                      % sample rate
dt = 1/Fs;                      % seconds per sample
t = (0:dt:2)';                % seconds
inSig = 20*sin(2*pi*Fc*t);
inSig = inSig(1:length(t(t < 1/Fc)));
gain = 1.0;

%% encode signal
rbs = 2;
sigParts = rbs * ones(size(inSig, 1)/rbs, 1);
rParts = ADP(inSig, [4 8], 1e-10);
sampleIdx = 1:size(t,1);
dScale = 2;
nCoeff = 2;
lambda = 0;
OUTDAT = {};
subsample = 2;

%% add gimmick to range parts
% merge 12-13th and 2-3th parts
rParts = rParts(1:end-1);
rParts(2) = 8;
rParts(11) = 8;
fc = FixAFCEncoder( inSig, rParts, nCoeff, dScale, lambda);

%% reconstruction using alpha
for alpha = 1:2
    outSig = zeros(1, sum(rParts)*alpha);
    
    %% visualize each iterations
    for iter = 0:5
        if iter >= 1
            outSig = singleIterAFCDecode(fc, alpha, outSig);
        end
        outSig = outSig * gain; % amplifying
        OUTDAT{alpha}(:, iter + 1) = outSig(1:subsample: end);
        
        % ploting
        figure(alpha), hold off;
        plot(OUTDAT{alpha}(:, iter + 1)); hold on;
        stem(OUTDAT{alpha}(:, iter + 1));
        title(['iteration ' num2str(iter)]);
        %         axis([1 32*alpha -20 20]);
        
        % set figure properties
        set(alpha, 'Position', [100, 100, 300, 150]);
        set(gca,'position',[0 0 1 0.8],'units','normalized');
        set(alpha, 'PaperPositionMode', 'auto');
    end
end
