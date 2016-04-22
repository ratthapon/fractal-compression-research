function [f inspectR fs compressTime] = fractalCompress(wave,fs,dStep)
% fs = 8; % frame size
% dStep = 1;
% [speech Fs] = audioread('C:\Project\IFEFSR\SpeechData\NECTEC\CF008_Va001\CF008_Va001_001.wav');

sp = wave(:,1)';
oddIdx = 1:2:fs*2;
evenIdx = 2:2:fs*2;
DIdx = 1:dStep:size(sp,2)-fs*2+1;
n = fs;
f = [];
fIdx = 1;
inspectR = [];
tic;
for fIdx = 1:size(sp,2)/fs % each r buffer size=frame
    bestR = Inf;
    rbIdx = ((fIdx-1)*fs)+1;
    b = sp(rbIdx:rbIdx+fs-1); % Y
    rangeR = [];
    for dbIdx = DIdx
        d = sp(dbIdx:dbIdx+(fs*2)-1);
        a = (d(oddIdx)+d(evenIdx)) /2;
        s = (n*sum(a.*b,2) - (sum(a,2).*sum(b,2)))  /  (n* sum(a.^2,2) - (sum(a,2).^2));
        o = (sum(b,2) - s.*sum(a,2)) / n;
        R = (sum(b.^2,2) + s.*(s.*sum(a.^2,2) - 2.*sum(a.*b,2) + 2.*o.*sum(a,2))  +  o.*(o.*(n^2) -  2.*sum(b,2)));
        R = R / n;
        rangeR = [rangeR; R];
        if R < bestR
            if ((n*sum(a.^2,2) - sum(a,2)^2)) == 0
                s = 0;
                o = sum(b,2) / n;
            end
            if s<-1
                s = -1;
                o = (sum(b,2) - s*sum(a,2)) /n;
            end
            if s>1
                s = 1;
                o = (sum(b,2) - s*sum(a,2)) /n;
            end
            bestR = R;
            f(fIdx,:) = [s o dbIdx];
        end
    end
    inspectR = [inspectR rangeR];
end
compressTime = toc;
