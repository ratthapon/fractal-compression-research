%% feat reader
for i = 1:length(data)
    diffFeat = sum(sum(data(i).originMfcc - data(i).reconMRBSMfcc) );
    
    mesures1 = 0;
    figure(i), subplot(2,3,1), imagesc(data(i).originMfcc);
    title('Original MFCC');
    
    mesures2 = img_qi(data(i).originMfcc, data(i).reconMfcc{1});
    figure(i), subplot(2,3,4), imagesc(data(i).reconMfcc{1});
    title(['RBS 8 QI=' sprintf('%03f', mesures2)]);
    
    mesures3 = img_qi(data(i).originMfcc, data(i).reconMfcc{2});
    figure(i), subplot(2,3,5), imagesc(data(i).reconMfcc{2});
    title(['RBS 4 QI=' sprintf('%03f', mesures3)]);
    
    mesures4 = img_qi(data(i).originMfcc, data(i).reconMfcc{3});
    figure(i), subplot(2,3,6), imagesc(data(i).reconMfcc{3});
    title(['RBS 2 QI=' sprintf('%03f', mesures4)]);
    
    
    mesures5 = img_qi(data(i).originMfcc, data(i).reconMRBSMfcc);
    figure(i), subplot(2,3,2), imagesc(data(i).reconMRBSMfcc);
    title(['MRBS QI=' sprintf('%03f', mesures5)]);
    
    mesures6 = img_qi(data(i).originMfcc, data(i).reconADPMfcc);
    figure(i), subplot(2,3,3), imagesc(data(i).reconADPMfcc);
    title(['ADP QI=' sprintf('%03f', mesures6)]);
end









