function [listFileName listClassLabel] = buildFileList(dirPath,environment,gender,setNumber,idList)

listFileName = [];
listClassLabel = [];
folderList = dir(dirPath);
idSize = size(idList,2);

for dirIdx = 3:size(folderList,1)
    if folderList(dirIdx).isdir
        folderNameData = textscan(folderList(dirIdx).name,'%c%c%03d_Va%03d'); 
        if  sum(environment==folderNameData{1}) > 0 && ...
            sum(gender==folderNameData{2}) > 0 && ...
            sum(setNumber==folderNameData{4}) > 0
        
            genderClassShift = (find(gender==folderNameData{2})-1) * idSize;
            prefixFilePath = [dirPath '\' folderList(dirIdx).name];
            fileList = dir(prefixFilePath);
            for fIdx = idList
                fileName = [prefixFilePath '\' folderList(dirIdx).name '_' num2str(fIdx,'%03d') '.wav'];
                listFileName = [listFileName ; {fileName}];
                classLabel = find(idList==fIdx) + genderClassShift;
                listClassLabel = [listClassLabel ; {classLabel}];
            end
        end
    end
end

                    
        
                    
                    
                    
                    
                    
                    