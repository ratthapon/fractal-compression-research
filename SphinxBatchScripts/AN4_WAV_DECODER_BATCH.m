%% wav coppy
% % an4 decoder
inDirS = [{'F:\IFEFSR\AudioFC\FC\AN4_8K_CURVEFIT_LM\'}, ...
    {'F:\IFEFSR\AudioFC\FC\QR\AN4_16K\'}];
inDir = inDirS{1};
a = 2;
fileList = importdata('F:\IFEFSR\AudioFC\an4traintest.txt');
outDir = 'F:\IFEFSR\ExpSphinx\FC816_LOWPASS_2\';
fromto = [1 size(fileList,1)];
outFs = 16000;
for i = fromto(1):fromto(2)
    load([inDir fileList{i}]);
    sig = decompressAudioFC(f, outFs/a, outFs, []);
    sig = filter( 0.95, [1 0.95 - 1], sig ); 
    
    subDir = regexp(fileList{i},'/','split');
    wavDir = [outDir '/wav/' subDir{1} '/' subDir{2}];
    outFName = [outDir '/wav/' fileList{i} '.raw'];
    mkdir(wavDir);
    
    fid = fopen(outFName, 'w');
    fwrite(fid, sig, 'int16');
    fclose(fid);
    
end








