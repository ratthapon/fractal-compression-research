function [r1, r2] = pearsoncorrelation(dat1,dat2)

X = dat1;
Y = dat2;
n = size(X,1);
r1 = (sum(X.*Y,1) - (sum(X,1).*sum(Y,1))./n ) ...
    ./ sqrt((sum(X.^2,1) - (sum(X,1).^2)./n).*(sum(Y.^2,1) - (sum(Y,1).^2)./n));

X = dat1(:);
Y = dat2(:);
n = size(X,1);
r2 = (sum(X.*Y) - (sum(X)*sum(Y))/n ) ...
    / sqrt((sum(X.^2) - (sum(X)^2)/n)*(sum(Y.^2) - (sum(Y)^2)/n));

