function [f ] = compressPower1(wave,fs)
dStep = 1;
sp = wave(:,1);
sp = sp(:)';
oddIdx = 1:2:fs*2;
evenIdx = 2:2:fs*2;
DIdx = 1:dStep:size(sp,2)-fs*2;
f = zeros(size(sp,2)/fs,4);

for fIdx = 1:size(sp,2)/fs % each r buffer size=frame
    bestR = Inf;
    rbIdx = ((fIdx-1)*fs)+1;
    b = sp(rbIdx:rbIdx+fs-1); % Y
    
    for dbIdx = DIdx
        d = sp(dbIdx:dbIdx+(fs*2)-1);
        a = (d(oddIdx)+d(evenIdx)) /2;
        for reverse = [true false]
            if reverse
                a = a(1,end:-1:1);
            end
            n = fs;
            X = [a; ones(size(a))]'; % coefficient matrix
            Y = X'*b'; % result for B = inv(X)Y
            B = pinv(X'*X)*Y; % beta, coefficient a b c
            %             r = X*B - b'; % residue of ax^2 + bx + c - y before power 2
            r = a'*B(1) + B(2) - b';
            R = sum(r(:).^2) / n; % sum of r square
            
            %             s = B(1);
            %             o = B(2);
            %            R = (sum(b.^2,2) + s*(s*sum(a.^2,2) - 2*sum(a.*b,2) + 2*o*sum(a,2))  +  o*(o*(n^2) -  2*sum(b,2)));
            %            R = (sum(b.^2,2) + s*s*sum(a.^2,2) - 2*s*sum(a.*b,2) + 2*s*o*sum(a,2)  +  o*o*(n^2) -  2*o*sum(b,2));
            
            %             R = R / n;
            %             nR = nR / n; % variance for measure fit
            %             nR = (X'*X)*B - Y;
            if R < bestR
                if B(1) < -1
                    B(1) = -1;
                    subX = X'*X;
                    subY = Y - B(1)*subX(:,1);
                    subX = subX(:,2);
                    subB = pinv(subX)*subY;
                    B(2) = subB;
                end
                if B(1) > 1
                    B(1) = 1;
                    subX = X'*X;
                    subY = Y - B(1)*subX(:,1);
                    subX = subX(:,2);
                    subB = pinv(subX)*subY;
                    B(2) = subB;
                end
                bestR = R;
                f(fIdx,:) = [B' reverse dbIdx];
            end
        end
    end
end

