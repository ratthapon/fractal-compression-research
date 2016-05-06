function [ MFCC ] = featread( filePath , nDimension)
    fid = fopen(filePath, 'r');
    header = fread(fid,1,'uint32')
    feat = fread(fid, 'float32');
    fclose(fid);
    if isempty(nDimension)
        nDimension= 13;
    end
    MFCC = reshape(feat, nDimension, header/nDimension);

end

