model = [{'c11 to w11'},{'c11 to w22'},{'c11 to w44'},{'c22 to w11'},{'c22 to w22'},...
    {'c22 to w44'},{'c44 to w11'},{'c44 to w22'},{'c44 to w44'}];
testData = [{'train c11'},{'train c22'},{'train c44'},{'test c11'},{'test c22'},...
    {'test c44'}];
plotBuffer = [];
for test = 1:6
    for train = 1:9
        for k = 3:2:49
            idx = ((test-1)*9) + train
            plotBuffer(idx,k) = KResult3d(train,test,k);
            plotName(idx) = {['model ' num2str(model{train}) ' vs ' num2str(testData{test}) ]};
        end
    end
end
plotBuffer = plotBuffer(:,3:2:49);
plotName = plotName';