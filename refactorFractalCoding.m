% refactor selsim
fs = 8; % frame size
dStep = 1;
[speech Fs] = audioread('C:\Project\IFEFSR\SpeechData\NECTEC\CF008_Va001\CF008_Va001_001.wav');
sp = speech(:,1)';
oddIdx = 1:2:fs*2;
evenIdx = 2:2:fs*2;
DIdx = 1:dStep:size(sp,2)-fs*2;
n = fs;
f = [];
fIdx = 1;
tic
for rbIdx = 1:fs:size(sp,2)-fs % each r buffer size=frame
    bestR = Inf;
    b = sp(rbIdx:rbIdx+fs-1);
    for dbIdx = DIdx
        d = sp(dbIdx:dbIdx+(fs*2)-1);
        a = (d(oddIdx)+d(evenIdx)) /2;
        s = (n*sum(a.*b,2) - (sum(a,2).*sum(b,2)))  /  (n* sum(a.^2,2) - (sum(a,2).^2));
        o = (sum(b,2) - s.*sum(a,2)) / n;
        R = (sum(b.^2,2) + s.*(s.*sum(a.^2,2) - 2.*sum(a.*b,2) + 2.*o.*sum(a,2))  +  o.*(o.*(n^2) -  2.*sum(b,2)));
        R = R / n;
        if R < bestR
            if ((n*sum(a.^2,2) - sum(a,2)^2)) == 0
                s = 0;
                o = sum(b,2) / n;
            end
            bestR = R;
            f(fIdx,:) = [s o dbIdx];
        end
    end
    fIdx = fIdx+1;
end
time = toc
save testselfsim

