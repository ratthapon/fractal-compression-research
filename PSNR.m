function pSNR= psnr(X,Y)
%Calculates the Peak-to-peak Signal to Noise Ratio of two images X and Y
X = X(:);
Y = Y(:);
[M]=min(size(X,1),size(Y,1));
[N]=min(size(X,2),size(Y,2));
m=double(0);
X=cast(X,'double');
Y=cast(Y,'double');
for i=1:M
    for j=1:N
        m=m+((X(i,j)-Y(i,j))^2);
    end
end
m=m*(1/(M*N));
pSNR=10*log10(1/m);