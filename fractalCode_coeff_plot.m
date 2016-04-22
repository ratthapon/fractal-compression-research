clear all

for Fc = 300:250:5500
    load(['F:\IFEFSR\BasicSine_poly\BasicSin_Fc' num2str(Fc) '_Fs4_poly.mat']);
    figure(1),subplot(2,1,1),
    plot(f(:,1),'r*-');
    hold on,plot(f(:,2),'b*-');
    hold on,plot(f(:,3),'g*-');
    title('power 2');
    
    load(['F:\IFEFSR\BasicSine_p3\BasicSin_Fc' num2str(Fc) '_Fs4_poly.mat']);
    figure(1),subplot(2,1,2),
    plot(f(:,1),'r*-');
    hold on,plot(f(:,2),'b*-');
    hold on,plot(f(:,3),'g*-');
    hold on,plot(f(:,4),'k*-');
    title('power 3');
    
    saveas(gcf,['F:\IFEFSR\BasicSine_coeff_poly\BasicSin_Fc' num2str(Fc) '_Fs4_poly.jpg']);
    close all;
end