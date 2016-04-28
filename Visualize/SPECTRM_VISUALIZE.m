F = [0 0.2500 0.5000 0.7500 1.0000];
A = [1.00 0.6667 0.3333 0 0];
Order = 511;
B = fir2(Order,F,A);
[Hx,W] = freqz(B,1,8192,'whole');
Hx = [Hx(4098:end) ; Hx(1:4097)];
omega = -pi+(2*pi/8192):(2*pi)/8192:pi;

plot(omega,abs(Hx))
xlim([-pi pi])
grid
title('Magnitude Spectrum')
xlabel('Radians/Sample')
ylabel('Magnitude')

  load chirp;                     % Load data (y and Fs) into workspace
  y = y + 0.5*rand(size(y));      % Adding noise
  f = [0 0.6 0.6 1];            % Frequency breakpoints
  m = [1 1 1 0 ];                  % Magnitude breakpoints
  b = fir2(60,f,m);               % FIR filter design
  freqz(b,1,512);                 % Frequency response of filter
  output = filter(b,1,y);       % Zero-phase digital filtering
  figure;                       
  subplot(211); plot(y,'b'); title('Original Signal')
  subplot(212); plot(output,'g'); title('Filtered Signal') 



