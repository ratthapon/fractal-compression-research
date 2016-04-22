% recon
fs = 8;
rec = zeros(size(sp));
oddIdx = 1:2:fs*2;
evenIdx = 2:2:fs*2;
frameBound = 1:fs:size(rec,2);
for iter = 1:10
    for fIdx = 1:size(f,1)
        s = f(fIdx,1);
        o = f(fIdx,2);
        dIdx = f(fIdx,3);
        subRec = rec(1,dIdx:dIdx+fs*2-1);
        X = (subRec(:,oddIdx) + subRec(:,evenIdx)) /2;
        rec(1,frameBound(fIdx):frameBound(fIdx+1)-1) = s.*X + o;
    end
end
audiowrite('test_recon.wav',rec,Fs);
res = [sp;rec];
plot(res');