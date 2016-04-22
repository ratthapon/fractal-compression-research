upp = [];
for i =1:size(x(:),1)-2
    if x(i) < x(i+1) && x(i+1) > x(i+2) && x(i) > 0 && x(i+2) > 0
        upp = [upp x(i+1)];
    end
end

lpp = [];
for i =1:size(x(:),1)-2
    if x(i) > x(i+1) && x(i+1) < x(i+2) && x(i) < 0 && x(i+2) < 0
        lpp = [lpp x(i+1)];
    end
end

figure(1),plot(x)
figure(2),plot(upp)
hold on,plot(repmat(sum(upp),size(x(:),1),size(x(:),2)))
figure(3),plot(lpp)
hold on,plot(mean(lpp))