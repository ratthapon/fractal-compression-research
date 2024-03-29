function [wav] = MDDecode(f, FsIn, FsOut, dScale, rScale, expansion, cenAlign, inIter)
%% Multi-domain fractal-coding's decoder
% f = fractacl codes
% FsIn = input sampling rate
% FsOut = Output samplinge rate

%% facter for reconstruction buffer, recon should equal output Fs
alpha = FsOut/FsIn;

%% check initial reconstruction signal
Y = zeros(1,sum(f(:,end-1)*alpha*rScale));

%% specify maxiterration of reconstruction
maxIter = 15;
if ~isempty(inIter)
    maxIter = inIter;
end

wav = Y;
%% reconstruction process
for iter = 1:maxIter
    % each iter, signal should have higher consrast
    [ wav ] = singleIterMDDecode( f, alpha, dScale, rScale, expansion, cenAlign, wav);
end


