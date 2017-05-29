%% load data from Graphicbuiler/Thesis/Thesis.m
% diff specs
plotCMPSpec(3,...
    SPECO16, {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of', ...
    '\color[rgb]{0.7804 0.9176 0.2745}16-kHz original signal'}, ...
    SPECO8, {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of', ...
    '\color[rgb]{0.7804 0.9176 0.2745}8-kHz original signal'})
set(gcf, 'position', [0 0 1200 500])
subplot(1,2,1),
set(gca,'YColor',[199 234 70]/255);
set(gca,'XColor',[199 234 70]/255);
subplot(1,2,2),
set(gca,'YColor',[199 234 70]/255);
set(gca,'XColor',[199 234 70]/255);

% diff feature
plotCMPSpec(4,...
    MFCCO16, {'\color[rgb]{0.7804 0.9176 0.2745}MFCCs of', ...
    '\color[rgb]{0.7804 0.9176 0.2745}16-kHz original signal'}, ...
    MFCCO8, {'\color[rgb]{0.7804 0.9176 0.2745}MFCCs of', ...
    '\color[rgb]{0.7804 0.9176 0.2745}8-kHz original signal'})
set(gcf, 'position', [0 0 1200 500])
subplot(1,2,1),
set(gca,'YColor',[199 234 70]/255);
set(gca,'XColor',[199 234 70]/255);
subplot(1,2,2),
set(gca,'YColor',[199 234 70]/255);
set(gca,'XColor',[199 234 70]/255);

% similar spec
plotCMPSpec(5,...
    SPECO8, {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of', ...
    '\color[rgb]{0.7804 0.9176 0.2745}8-kHz original signal'}, ...
    SPECR816_rbs4, {'\color[rgb]{0.7804 0.9176 0.2745}Spectrum of', ...
    '\color[rgb]{0.7804 0.9176 0.2745}8-kHz-to-16-kHz reconstructed signal'})
set(gcf, 'position', [0 0 1200 500])
subplot(1,2,1),
set(gca,'YColor',[199 234 70]/255);
set(gca,'XColor',[199 234 70]/255);
subplot(1,2,2),
set(gca,'YColor',[199 234 70]/255);
set(gca,'XColor',[199 234 70]/255);



