% simple regression 
X = ([1 2 3 4 5]');
Y = ([3 5 7 9 11]');

A = ([ X.^1 X.^0]);
B = pinv(A'*A)*(A'*Y)

figure(1),subplot(1,2,1)
plot(X,Y)
axis([0 15 0 15])

A = [ X.^1 X.^0]
B = (A'*A)\(A'*Y)

figure(1),subplot(1,2,2)
plot(X,Y)
axis([0 15 0 15])

% predict




