% cmpPSNR
sel = [5 17 41 43 48 65 66 75 78 79 83 88 92 94 95 97 99 100 102 108 109 ...
    110 111 113 114 116 117 118 119 120 128 129 134 136 ];
filesList1 = importdata('F:\IFEFSR\8k_SEL_NECTEC_MR.txt');
filesList2 = importdata('F:\IFEFSR\16k_SEL_NECTEC_MR.txt');
allPSNR = zeros(size(filesList1,1),1);
for i=1:size(filesList1,1)
    w1 = audioread(filesList1{i});
    w1 = upsample(w1,2);
    w2 = audioread(filesList2{i});

    psnr_b4norm = PSNR(w1(:),w2(:));
%     psnr_afternorm = PSNR(normalize(w1),normalize(w2));
    
%     psnr_b4norm_c = PSNR(w1_c(:),w2_c(:));
%     psnr_afternorm_c = PSNR(normalize(w1_c),normalize(w2_c));
    allPSNR(i,:) = [psnr_b4norm ];
    figure(1)
    subplot(4,1,1),plot(w1);
    subplot(4,1,2),plot(w2);
%     subplot(4,1,3),plot(normalize(w1));
%     subplot(4,1,4),plot(normalize(w2));
end
mean(allPSNR)
