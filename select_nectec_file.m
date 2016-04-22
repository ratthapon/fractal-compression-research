selClass = [8 9 49 50];
selectedClassFilesList = [];
'8k_NECTEC_MR';
for cIdx=1:size(selClass,2)
    for fIdx = cIdx:wordCount:size(filesList,1)
        selectedClassFilesList = [selectedClassFilesList; filesList(fIdx)];
    end
end

