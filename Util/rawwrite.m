function rawwrite( outFName , signal)
    [directory, ~, ~] = fileparts(outFName);
    mkdir(directory);
    fid = fopen(outFName, 'w');
    fwrite(fid, signal, 'int16');
    fclose(fid);

end

