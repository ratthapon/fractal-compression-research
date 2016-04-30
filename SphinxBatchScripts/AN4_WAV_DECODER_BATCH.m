%% wav coppy
% % an4 decoder
inDirS = [{'F:\IFEFSR\AudioFC\FC\QR\AN4_DECIMATION_QR_GPU\'}, ...
    {'F:\IFEFSR\AudioFC\FC\QR\AN4_16K\'}]; %AN4_16K\'}];
a = 2;
inDir = inDirS{3-a};
fileList = importdata('F:\IFEFSR\AudioFC\an4test.txt');
outDir = ['F:\IFEFSR\ExpSphinx\FC' num2str(16/a) '16_FIR8\'];
fromto = [1 size(fileList,1)];
outFs = 16000;
for i = fromto(1):fromto(2)
    load([inDir fileList{i}]);
    sig = decompressAudioFC(f, outFs/a, outFs, []);
%     sig = filter( 0.001, [1 0.001 - 1], sig ); 
%     f = [0 0.3 0.3 1];            % Frequency breakpoints
%     m = [1 1 1 0 ];                  % Magnitude breakpoints
%     b = fir2(60,f,m);               % FIR filter design
%     % freqz(b,1,512);                 % Frequency response of filter
%     sig = filtfilt(b,1,sig);       % Zero-phase digital filtering
    
    subDir = regexp(fileList{i},'/','split');
    wavDir = [outDir '/wav/' subDir{1} '/' subDir{2}];
    outFName = [outDir '/wav/' fileList{i} '.raw'];
    mkdir(wavDir);
    
    fid = fopen(outFName, 'w');
    fwrite(fid, sig, 'int16');
    fclose(fid);
    
end








