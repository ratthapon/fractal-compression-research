%% correlation analysis

% % an4 decoder
dir8kFC = 'F:\IFEFSR\ExpSphinx\FC816_LOWPASS_001\feat\';
dir16kFC = 'F:\IFEFSR\ExpSphinx\FC1616_LOWPASS_001\feat\';
fileList = importdata('F:\IFEFSR\AudioFC\an4traintest.txt');
corrValues = {};
speechCorr = [];
allCorr = [];

fromto = [1 size(fileList,1)];
for i = fromto(1):fromto(2)
    speechCorr = [];
    
    inFName = [dir8kFC fileList{i} '.mfc'];
    fid = fopen(inFName, 'r');
    header = fread(fid,1,'uint32');
    cc = fread(fid, 'float32');
    fclose(fid);
    c = 30;
    nMFCC1 = header/c;
    cc_p_1 = reshape(cc,c,nMFCC1);
    cc_p_1 = (cc_p_1 - repmat(mean(cc_p_1, 2), 1, nMFCC1)) ...
        ./(max(cc_p_1, 2) - min(cc_p_1, 2));
    % figure(1),subplot(2,1,1),imagesc(cc_p_1)
    
    inFName = [dir16kFC fileList{i} '.mfc'];
    fid = fopen(inFName, 'r');
    header = fread(fid,1,'uint32');
    cc = fread(fid, 'float32');
    fclose(fid);
    c = 30;
    nMFCC2 = header/c;
    cc_p_2 = reshape(cc,c,nMFCC2);
    cc_p_2 = (cc_p_2 - repmat(mean(cc_p_2, 2), 1, nMFCC2)) ...
        ./(max(cc_p_2, 2) - min(cc_p_2, 2));
    % figure(1),subplot(2,1,2),imagesc(cc_p_2)
    
    minNMFCC = min(nMFCC1, nMFCC2);
    for col = 1:minNMFCC
        speechCorr(col) = corr(cc_p_1(:,col), cc_p_2(:,col));
        allCorr = [allCorr; speechCorr(col)];
    end
    corrValues(i) = {speechCorr};
    avgPerfile(i) = mean(speechCorr);
    stdPerfile(i) = std(speechCorr);
end
mean(allCorr)
std(allCorr)


















