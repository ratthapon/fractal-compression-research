% aggregate
clc 
clear all;
% load('C:\Project\IFEFSR\MData\listClassLabel1');
fData = [];
cat_f = [];
outputSetName = 'sampling22k_trainfs16dstep1';
for i = 1:180%size(listClassLabel,1)
    load(['F:\IFEFSR\Output\' outputSetName '\' num2str(i)]);
    fData = [fData; {f(:,1:3)}];
%     cat_f = [cat_f; [f(:,1:2)]];
end
% dataZM = (cat_f - (ones(size(cat_f,1),1)*mean(cat_f)))./(ones(size(cat_f,1),1)*std(cat_f));
%cat_fData = dataZM;
mkdir(['F:\IFEFSR\MData\' outputSetName ]);
save(['F:\IFEFSR\MData\' outputSetName '\fData'],'fData');
% save('F:\IFEFSR\MData\sampling44k_trainfs8dstep1\cat_f','cat_f');