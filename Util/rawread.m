function [ wav ] = rawread( filePath )
    fIn = fopen(filePath, 'r');
    wav = fread(fIn, 'int16');
    fclose(fIn);
end

