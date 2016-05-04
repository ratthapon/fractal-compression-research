function featwrite( outFName , MFCC)
    fid = fopen(outFName, 'w');
    fwrite(fid, size(MFCC(:),1), 'uint32');
    fwrite(fid, MFCC(:), 'float32');
    fclose(fid);
end

