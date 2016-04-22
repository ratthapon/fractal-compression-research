function [f fs compressTime] = compressPower2_type2(wave,fs)
% fs = 8; % frame size
% dStep = 1;
% [speech Fs] = audioread('C:\Project\IFEFSR\SpeechData\NECTEC\CF008_Va001\CF008_Va001_001.wav');
dStep = 1;
sp = wave(:,1)';
oddIdx = 1:2:fs*2;
evenIdx = 2:2:fs*2;
DIdx = 1:dStep:size(sp,2)-fs;%*2;
n = fs;
f = [];
fIdx = 1;
tic;
for rbIdx = 1:fs:size(sp,2)-fs % each r buffer size=frame
    bestR = Inf;
    b = sp(rbIdx:rbIdx+fs-1); % Y
    G=[];
    for dbIdx = DIdx
%         d = sp(dbIdx:dbIdx+(fs*2)-1);
        a = sp(dbIdx:dbIdx+fs-1);%(d(oddIdx)+d(evenIdx)) /2;
        
        X = [a.^2; a; ones(size(a))]; % coefficient matrix
        Y = X*b'; % result for B = inv(X)Y
        B = pinv(X*X')*Y; % beta, coefficient a b c
        r = X'*B - b'; % residue of ax^2 + bx + c - y before power 2
        R = sum(r(:).^2); % sum of r square
        if R < bestR
            %             if ((n*sum(a.^2,2) - sum(a,2)^2)) == 0
            %                 s = 0;
            %                 o = sum(b,2) / n;
            %             end
            bestR = R;
            f(fIdx,:) = [B' dbIdx];
            G = a;
        end
    end
    figure(2),
    subplot(3,1,1),plot(b);
%     subplot(3,1,2),plot(wave(1010:1010+fs-1));
    subplot(3,1,3),plot(G);
    fIdx = fIdx+1;
end
compressTime = toc;
