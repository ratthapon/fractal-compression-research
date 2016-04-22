% split accuracy to class accuracy
nClass = size(unique(label),1);
ClassLabel = zeros(12,nClass) + eps;
ClassOutput = zeros(12,nClass);
CountClass = zeros(1,nClass);

for i = 1:size(outClass,2);
    CountClass(1,label(i)) = CountClass(1,label(i)) + 1;
    ClassLabel(CountClass(1,label(i)),label(i)) = label(i);
    ClassOutput(CountClass(1,label(i)),label(i)) = outClass(i);
end

ClassAcc = sum(ClassOutput==ClassLabel,1)./CountClass;
figure,bar(ClassAcc)
xlabel('Class'),ylabel('Accuracy')
title(['Accuracy rate per class (HF ' num2str(HF) ')'])
axis([1 67 0 1 ])
EXPLabel = 'UNK';
if tactic ==0
    EXPLabel = 'BASE';
elseif tactic ==3
    EXPLabel = 'FC';
end
saveas(gcf,['F:\IFEFSR\ReportPic\APC_' EXPLabel '_TEST_' ...
    num2str(floor(EFPS/1000)) 'to' num2str(floor(DFPS/1000)) ...
    '_BY_MODEL_' num2str(floor(MFPS/1000)) ...
    DATA_SET MFCC_PARAMS_STR '_HIGHBAND' '.jpg'],'jpg');