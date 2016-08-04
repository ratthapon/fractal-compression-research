function [ wav ] = MultiVarFixAFCDecoder(f,FsIn,FsOut,inIter)
%MULTISCALEAFCDECODER Summary of this function goes here
%   Detailed explanation goes here
% decode process


%% facter for reconstruction buffer, recon should equal output Fs
alpha = FsOut/FsIn;

%% check initial reconstruction signal
Y = zeros(1,sum(f(:,end - 1)*alpha));
n = size(f, 2) - 3;
b = f(1, end - 1) * alpha;

%% mapping helper
dStart = @(k ,s) k + (n-s) * (b/2);
dEnd = @(k ,s) k + (n+s) * (b/2) - 1;

%% specify maxiterration of reconstruction
maxIter = 15;
if ~isempty(inIter)
    maxIter = inIter;
end

wav = Y;
%% reconstruction process
for iter = 1:maxIter
    % each iter, signal should have higher consrast
    rIdx = 1; % initial range block poiter
    for fIdx = 1:size(f,1)
        % for each individual code
        % retrive S,O parameter
        C = f(fIdx, 1:n);
        dIdx = abs(f(fIdx, end - 2));
        reverse = f(fIdx, end - 2) < 0;
        w = ceil(f(fIdx, end - 1)*alpha); % scaling decode buffer to
        
        % locate domain idx
        k = round((dIdx - 1)*alpha + 1);
        if k <= 0 % exception for underflow idx
            k = 1;
        end
        if dEnd(k, n) > size(Y,2) % exception for overflow idx
            k = size(Y,2) + 1 - b*n;
        end
        X = zeros(w, n-1);
        X(:, 1) = 1; % bias
        
        % calculate multivariate input
        for s = 2:n
            % create buffer for reconstruction
            d = wav(1, dStart(k, s):dEnd(k, s));
            if reverse
                d = d(1,end:-1:1);
            end
            
            % resample domain
            d_p = (1/s) * ...
                sum( ...
                reshape(d, [s w] )... % reshape params
                ,1)'; % sum params, sum each column
            % building linear problem
            X(:, s) = d_p; % input data
        end
        
        % X = rec(1,rIdx:rIdx+decodeFs-1);
        % C_norm = C;
        % C_norm(2:end) = C(2:end)./(sum(abs(C(2:end))));
        
        r = C*X';
        Y(1,rIdx:rIdx + w - 1) = r;
        rIdx = rIdx + w; % locate next output block
    end
    if any(isnan(Y(:))) || any(isinf(Y(:)))
        break;
    else
        wav = Y;
    end
    %     figure(3),plot(wav(1,1:300));
end
end

