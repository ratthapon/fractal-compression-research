%% All SphinTrain Batch
tic;
fid = fopen('F:\IFEFSR\ExpSphinx\SPHINX_FEAT_BATCH_2.bat','r');
cfg = textscan(fid, '%s','Delimiter','\n');
fclose(fid);

for i = 1:length(cfg{1})
    system(cfg{1}{i},'-echo')
end

time = toc