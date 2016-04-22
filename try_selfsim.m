% signal = randi([1 10],1,20)
frameSize = 4;
% signal = x;
[speech Fs] = audioread('C:\Project\IFEFSR\SpeechData\NECTEC\CF008_Va001\CF008_Va001_001.wav');
signal = speech(:,1)';
tic
d = [];
for i = 1:size(signal,2)-frameSize*2 + 1
    d(i,:) = signal(1,i:i+frameSize*2 - 1);
end

frameCount = 0;
Rs=[];
for i = 1:size(signal,2)-frameSize+1
    Rs(i,:) = signal(1,i:i+frameSize - 1);
    frameCount = frameCount +1;
end

oddIdx = 1:2:size(d,2);
evenIdx = 2:2:size(d,2);
a = (d(:,oddIdx) + d(:,evenIdx)) /2;

f=[];
for range = 1:frameCount
    
    b = repmat(Rs(range,:),size(d,1),1);
    
    n = size(a,2);
    
    s = (n*sum(a.*b,2) - (sum(a,2).*sum(b,2)))  ./  (n* sum(a.^2,2) - (sum(a,2).^2));
    
    o = (sum(b,2) - s.*sum(a,2)) / n;
    
    %if;
    exVal = (n.*sum(a.^2,2) - sum(a,2).^2);
    exIdx = find(exVal==0);
    s(exIdx) = 0;
    o(exIdx) = sum(b(exIdx)./(n^2),2);
    
    R = (sum(b.^2,2) + s.*(s.*sum(a.^2,2) - 2.*sum(a.*b,2) + 2.*o.*sum(a,2))  +  o.*(o.*(n^2) -  2.*sum(b,2)));
    R = R / n;
    
    [val bestIdx] = min(R);
    f(range,:) = [s(bestIdx),o(bestIdx),bestIdx];
    
end
time = toc
save testselfsim
