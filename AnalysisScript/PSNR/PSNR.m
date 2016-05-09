function pSNR= psnr(X,Y)
%Calculates the Peak-to-peak Signal to Noise Ratio of two images X and Y
X = X(:);
Y = Y(:);
[M] = min(size(X,1),size(Y,1));
[N] = min(size(X,2),size(Y,2));
MSE = double(0);
X = cast(X,'double');
Y = cast(Y,'double');
maxPower = 2^15; % maximun pwer of 16 bit pcm
for i=1:M
    for j=1:N
        MSE = MSE+((X(i,j)-Y(i,j))^2);
    end
end
MSE = MSE*(1 /(M*N));
pSNR = 10*log10(maxPower^2 /MSE);