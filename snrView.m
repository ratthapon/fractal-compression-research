bFiles  = importdata('F:\IFEFSR\11k_train_rawResampling.txt');
cFiles  = importdata('F:\IFEFSR\11k_train_rawResampling_fs16_code.txt');
FPC = 16;
for i=1:180
    [signal,FPS] = audioread(bFiles{i});
    load(cFiles{i});
    de_signal = fractalDecode(f,FPS,16,1,FPS,[],[]);
    de_signal = ((de_signal - mean(de_signal)) / std(de_signal));
    de_signal = de_signal / norm(de_signal);
    de_signal = de_signal * 0.15;
    signal = ((signal - mean(signal)) / std(signal));
    signal = signal / norm(signal);
    signal = signal * 0.15;
    s(i) = snr(de_signal,signal);
end