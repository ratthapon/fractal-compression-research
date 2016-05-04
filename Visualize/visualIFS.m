% visualize IFS 
% close all
dat = load('F:\IFEFSR\AudioFC\FC\LS_ANALYZE_INV_QR\an4_clstk\fash\an253-fash-b.mat');
f3 = dat.f;

nIter = 20;
a = f3(1,2);
b = f3(1,1);
x = 0;
y = 0;
X = zeros(1,nIter);
figure(3);
subplot(1,2,1);
title('Value of y = ax+b');
xlabel('x');
ylabel('y');
axis([0 9 0 9]);

figure(3);
subplot(1,2,2);
title('Value of y = ax+b every iteration');
xlabel('iteration');
ylabel('y');
axis([0 nIter 0 9]);
for i =1:nIter
    y = a*x + b;
    
    subplot(1,2,1);
    hold on;
    scatter(x, y);
    text(x + 0.2,y- 0.2, ['iter' num2str(i)]);
    hold off;
    
    subplot(1,2,2);
    plot(X(1:i));
    
    x = y;
    X(i) = y;
    pause(0.5);
end
subplot(1,2,2);
plot(X(1:i));
title('Value of y = ax+b every iteration');
xlabel('iteration');
ylabel('y');
