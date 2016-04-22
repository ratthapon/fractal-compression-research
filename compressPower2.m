function [f fs compressTime] = compressPower2(wave,fs)
% fs = 8; % frame size
% dStep = 1;
% [speech Fs] = audioread('C:\Project\IFEFSR\SpeechData\NECTEC\CF008_Va001\CF008_Va001_001.wav');
dStep = 1;
sp = wave(:,1)';
oddIdx = 1:2:fs*2;
evenIdx = 2:2:fs*2;
DIdx = 1:dStep:size(sp,2)-fs*2;
f = [];
% tic;
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
            X = [a.^2; a; ones(size(a))]'; % coefficient matrix
            Y = X'*b'; % result for B = inv(X)Y
            B = pinv(X'*X)*Y; % beta, coefficient a b c
            r = X*B - b'; % residue of ax^2 + bx + c - y before power 2
            R = sum(r(:).^2) / fs; % sum of r square / n = variance of fit
            if R < bestR
                %             if ((n*sum(a.^2,2) - sum(a,2)^2)) == 0
                %                 s = 0;
                %                 o = sum(b,2) / n;
                %             end
                if B(1) < -1
                    B(1) = -1;
                    subX = X'*X;
                    subY = Y - B(1)*subX(:,1);
                    subX = subX(:,2:3);
                    subB = pinv(subX)*subY;
                    B(2:3) = subB;
                end
                if B(1) > 1
                    B(1) = 1;
                    subX = X'*X;
                    subY = Y - B(1)*subX(:,1);
                    subX = subX(:,2:3);
                    subB = pinv(subX)*subY;
                    B(2:3) = subB;
                end
                if B(2) < -1
                    B(2) = -1;
                    subX = X'*X;
                    subY = Y - B(1)*subX(:,1) - B(2)*subX(:,2);
                    subX = subX(:,3);
                    subB = pinv(subX)*subY;
                    B(3) = subB;
                end
                if B(2) > 1
                    B(2) = 1;
                    subX = X'*X;
                    subY = Y - B(1)*subX(:,1) - B(2)*subX(:,2);
                    subX = subX(:,3);
                    subB = pinv(subX)*subY;
                    B(3) = subB;
                end
                %             if B(1) < -1.2
                %                 B(1) = -1.2;
                %                 B(2) = (sum(b,2) - n*B(3) - B(1)*sum(a.^2,2)) / sum(a,2);
                %                 if B(2) < -1.2
                %                     B(2) = -1.2;
                %                     B(3) = (sum(b,2) - B(1)*sum(a.^2,2) - B(2)*sum(a,2)) / n;
                %                 end
                %                 if B(2) > 1.2
                %                     B(2) = 1.2;
                %                     B(3) = (sum(b,2) - B(1)*sum(a.^2,2) - B(2)*sum(a,2)) / n;
                %                 end
                %             end
                %             if B(1) > 1.2
                %                 B(1) = 1.2;
                %                 B(2) = (sum(b,2) - n*B(3) - B(1)*sum(a.^2,2)) / sum(a,2);
                %                 if B(2) < -1.2
                %                     B(2) = -1.2;
                %                     B(3) = (sum(b,2) - B(1)*sum(a.^2,2) - B(2)*sum(a,2)) / n;
                %                 end
                %                 if B(2) > 1.2
                %                     B(2) = 1.2;
                %                     B(3) = (sum(b,2) - B(1)*sum(a.^2,2) - B(2)*sum(a,2)) / n;
                %                 end
                %             end
                bestR = R;
                f(fIdx,:) = [B' reverse dbIdx];
            end
        end
    end
    %     figure(2),
    %     subplot(3,1,1),plot(b);
    % %     subplot(3,1,2),plot(wave(1010:1010+fs-1));
    %     subplot(3,1,3),plot(G);
end
% compressTime = toc;
