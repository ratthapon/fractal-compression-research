%% load parameter from Graphicbuiler/Thesis/Thesis.m
i = 40;
baseSpeech = rawread(normpath(fullfile(expDir, ...
    ['BASE8'], 'wav', [fileList{i} '.raw'])));
originSpeech = rawread(normpath(fullfile(expDir, ...
    ['BASE16'], 'wav', [fileList{i} '.raw'])));

originSpeechFPR = regexprep(normpath(fullfile(expDir, ...
    [dirFCD '1616'], 'wav', [fileList{i} '.raw'])), ...
    'EXCLUDEORIGIN', 'INCLUDEORIGIN');
originSpeechR = rawread(originSpeechFPR);

set1SpeechFP = regexprep(normpath(fullfile(expDir, ...
    [dirFCD '816'], 'wav', [fileList{i} '.raw'])), ...
    'EXCLUDEORIGIN', 'INCLUDEORIGIN');
set1Speech = rawread(set1SpeechFP);

set2SpeechFP = regexprep(normpath(fullfile(expDir, ...
    [dirHFCD '816'], 'wav', [fileList{i} '.raw'])), ...
    'EXCLUDEORIGIN', 'INCLUDEORIGIN');
set2Speech = rawread(set2SpeechFP);

figNum = 43;
switch i
    case 40
        [ CC0, FBE0, OUTMAG0] = mfcc2( originSpeech(40000:50000), 16000);
        [ CC0R, FBE0R, OUTMAG0R] = mfcc2( originSpeechR(40000:50000), 16000);
        [ CC00, FBE00, OUTMAG00] = mfcc2( baseSpeech(20000:25000), 8000);
        OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];
        [ CC1, FBE1, OUTMAG1] = mfcc2( set1Speech(40000:50000), 16000);
        [ CC2, FBE2, OUTMAG2] = mfcc2( set2Speech(40000:50000), 16000);
        figNum = 431;
    case 90
        [ CC0, FBE0, OUTMAG0] = mfcc2( originSpeech(10000:15000), 16000);
        [ CC0R, FBE0R, OUTMAG0R] = mfcc2( originSpeechR(10000:15000), 16000);
        [ CC00, FBE00, OUTMAG00] = mfcc2( baseSpeech(5000:7500), 8000);
        OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];
        [ CC1, FBE1, OUTMAG1] = mfcc2( set1Speech(10000:15000), 16000);
        [ CC2, FBE2, OUTMAG2] = mfcc2( set2Speech(10000:15000), 16000);
        figNum = 432;
    case 103
        [ CC0, FBE0, OUTMAG0] = mfcc2( originSpeech(4400:9700), 16000);
        [ CC0R, FBE0R, OUTMAG0R] = mfcc2( originSpeechR(4400:9700), 16000);
        [ CC00, FBE00, OUTMAG00] = mfcc2( baseSpeech(2200:4900), 8000);
        OUTMAG00 = [OUTMAG00; zeros(size(OUTMAG00))];
        [ CC1, FBE1, OUTMAG1] = mfcc2( set1Speech(4400:9700), 16000);
        [ CC2, FBE2, OUTMAG2] = mfcc2( set2Speech(4400:9700), 16000);
        figNum = 433;
end

%% visualize spectrum
plotCMPSpec(figNum*10 + 1, ...
    OUTMAG0, {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of ', '16-kHz original speech signal','of "Sixth"'}, ...
    OUTMAG00,  {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of ', '8-kHz original speech signal','of "Sixth"'},...
    OUTMAG433,  {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of ', '16-kHz original speech signal','of "Fifth"'}...
    );
set(gcf, 'Position', [0 0 1200 600])

plotCMPSpec(figNum*10 + 2, ...
    OUTMAG0R, {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using FCD method'}, ...
    OUTMAG1,  {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using FCD method'},...
    OUTMAG433R,  {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of ', '16-kHz-to-16-kHz reconstructed speech signal','of "Fifth" using FCD method'}...
    );
set(gcf, 'Position', [0 0 1200 600])

%             plotCMPSpec(figNum*10 + 3, ...
%                 OUTMAG1, {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using FCD method'}, ...
%                 OUTMAG2,  {'Spectrum of ', '8-kHz-to-16-kHz reconstructed speech signal','of "Sixth" using HFCD-HP method'}...
%                 );
%             set(gcf, 'Position', [0 0 1200 600])
%             colormap default

figs = [4311 4312 45 46 47];
for fig = figs
    figure(fig),
    set(gcf,'DefaultTextColor', [199 234 70]/255);
    for sp = 1:3
        subplot(1,3,sp),
        set(gca,'YColor',[199 234 70]/255);
        set(gca,'XColor',[199 234 70]/255);
        xlabel('\color[rgb]{0.7804 0.9176 0.2745}Time (ms)');
        ylabel('\color[rgb]{0.7804 0.9176 0.2745}Frequency (kHz)');
        name = get(get(gca,'title'),'string');
        name{1} = ['\color[rgb]{0.7804 0.9176 0.2745}' name{1}]
        title(name);
    end
end


