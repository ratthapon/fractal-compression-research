function nonUniformIteration( )
%NONUNIFORMITERATION Non uniform iterative decoding experiments
% different nIter for differnt part of signal

[ Tw, Ts, preemAlpha, M, C, L, LF, HF ] = getMFCCSphinxParams();

%% load code
codePath = 'F:\IFEFSR\AudioFC\FC\TEST\AN48_FP_RBS2\an4_clstk\fash\an251-fash-b.mat';
data = load(codePath);
f = data.f;

%% decode parameters
alpha = 16000/8000;
Y = zeros(1, sum(f(:, end-1)*alpha));% init reconstruction signal
maxIter = 15; % specify maxiterration of reconstruction

%% define iter limit for each part of signal
sigPart = maxIter * ones(size(Y));

% limit iter
% [1:2699 2700:4500 4600:6200 6201:8000];
for limIter = 3:12
    sigPart(2700:4500) = limIter;
    sigPart(4600:6200) = limIter;
    
    wav = Y;
    %% reconstruction process
    for iter = 1:maxIter
        decodeFilter = (sigPart >= iter);
        % each iter, signal should have higher consrast
        [ wav ] = nonUniformSingleIterAFCDecode( f, alpha, wav, decodeFilter);
    end
    [~, ~, spec] = mfcc( wav, 16000, ...
            Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );
    save(['F:\IFEFSR\Spec\rbs2Iter' num2str(limIter)], 'spec');
    figure(limIter), surf(spec);
end
