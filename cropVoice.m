function wav = cropVoice(inWav)
inWav = inWav(:);
% startIdx = 1;
% stopIdx = size(inWav,1);
% thresh = 1e-4;
% for i = 1:256:size(inWav,1)-256*3
%     var1 = var(inWav(i:i+256-1));
%     var2 = var(inWav(i+256:i+256+256-1));
%     var3 = var(inWav(i+256+256:i+256+256+256-1));
%     startIdx = i;
%     if var1 > thresh || var2 > thresh || var3 > thresh
%         break;
%     end
% end
% for i = size(inWav,1):-256:256*3
%     var1 = var(inWav(i-256+1:i));
%     var2 = var(inWav(i-256-256+1:i-256));
%     var3 = var(inWav(i-256-256-256+1:i-256-256));
%     stopIdx = i;
%     if var1 > thresh || var2 > thresh || var3 > thresh
%         break;
%     end
%     
% end
figure(1),
subplot(2,1,1),plot(inWav)
title('y 1');
[startIdx y] = ginput(1)
title('y 2');
[stopIdx y] = ginput(1)
wav = inWav(startIdx:stopIdx);
subplot(2,1,2),plot(wav)