% y = 1:10;
% X = 1:0.5:5.5;
% B = inv(X'*X)*X'*y;

A = [707 153 35;...
    153 35 9;...
    35 9 3];
B = [218 56 18]';
ainv = pinv(A);
out = ainv*B

X = [1 3 5]';
Y = [5 7 6]';
a = out(1);
b = out(2);
c = out(3);
y = a*(X.^2) + b.*X + c;
% 
 %%
% %close all,clear all,clc;
%  out2 = pinv(X'*X)*X'*Y
 out2 = pinv(A'*A)*A'*B
 
 
 % convert ot matrix
 a = [1 3 5];
b = [5 7 6];
        X = [a.^2; a; ones(size(a))]'; % coefficient matrix
        Y = X'*b'; % result for B = inv(X)Y
        B = pinv(X'*X)*Y % beta, coefficient a b c
        r = X*B - b'; % residue of ax^2 + bx + c - y before power 2
        R = sum(r(:).^2); % sum of r square