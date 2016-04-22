figure
w1 = audioread('F:\IFEFSR\WavOut\11k2f1_decode44100_to_11025fs8dStep1.wav');
subplot(4,1,1)
plot(w1);
w2 = audioread('F:\IFEFSR\WavOut\none2f1_decode44100_to_11025fs8dStep1.wav');
subplot(4,1,2)
plot(w2);
w3 = audioread('F:\IFEFSR\WavOut\none2f1_decode44100_to_44100fs8dStep1.wav');
subplot(4,1,3)
plot(w3);
w4 = f(:,1:2);
subplot(4,1,4)
plot(data);