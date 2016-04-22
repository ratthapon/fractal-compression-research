% % an4 decoder
h3 = figure(3);
set(h3, 'Visible', 'off');
fromto = [1 size(fileList,1)];
outFs = 16000;
for i = fromto(1):fromto(2)
    load([inDir fileList{i}]);
    sig = decompressAudioFC(f, outFs/a, outFs, []);
    sig = filter( 0.01, [1 0.01 - 1], sig ); 
    
    [MFCC1, FBE1, SPEC] = mfcc( sig, 16000,...
        Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L);
    
    subDir = regexp(fileList{i},'/','split');
    featDir = [outDir '/feat/' subDir{1} '/' subDir{2}];
    outFName = [outDir '/feat/' fileList{i} '.mfc'];
    mkdir(featDir);
    fid = fopen(outFName, 'w');
    fwrite(fid, size(MFCC1(:),1), 'uint32');
    fwrite(fid, MFCC1(:), 'float32');
    fclose(fid);
    
    subplot(1,3,1),imagesc(SPEC);
    subplot(1,3,2),imagesc(FBE1);
    subplot(1,3,3),imagesc(MFCC1);
    saveas(3, [outDir '/fig/' subDir{3}], 'png')
    
%     subDir = regexp(fileList{i},'/','split');
%     wavDir = [outDir '/feat/' subDir{1} '/' subDir{2}];
%     outFName = [outDir '/feat/' fileList{i} '.raw'];
%     mkdir(wavDir);
%     fid = fopen(outFName, 'w');
%     fwrite(fid, sig, 'int16');
%     fclose(fid);
    
end
