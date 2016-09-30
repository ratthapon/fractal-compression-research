function nonUniformMRBS()
%NONUNIFORMMRBS Non uniform iterative decoding experiments
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
RBS = [128 64 32 16 8 4];

% limit iter
for limIter = 0:30
    iterControl = [limIter limIter limIter 15 15 15 ];
    
    wav = Y;
    for codeIdx = 1:6
        %% load code at specific size
        codePath = ['F:\IFEFSR\AudioFC\FC\TEST\AN48_FP_RBS' ...
            num2str(RBS(codeIdx)) '\an4_clstk\fash\an251-fash-b.mat'];
        data = load(codePath);
        f = data.f;
        
        maxIter = iterControl(codeIdx);
        
        %% reconstruction process
        for iter = 1:maxIter
            % each iter, signal should have higher consrast
            [ wav ] = singleIterAFCDecode( f, alpha, wav);
        end
    end
    
    [~, ~, spec] = mfcc( wav, 16000, ...
        Tw, Ts, preemAlpha, @hamming, [LF HF], M, C+1, L );
    save(['F:\IFEFSR\Spec\mrbs4t128 rev Iter' num2str(limIter)], 'spec');
    figure(limIter + 1), surf(spec);
end
