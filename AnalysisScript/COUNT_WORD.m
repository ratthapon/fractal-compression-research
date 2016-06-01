transcritptFile = 'F:\IFEFSR\ExpSphinx\etc\an4_train.transcription';
transcript  = importdata(transcritptFile); 
wordCount = zeros(size(transcript));
for i = 1:size(transcript, 1)
   word = regexp(transcript{i}, ' ', 'split');
   wordCount(i) = size(word, 2) - 1;
end







