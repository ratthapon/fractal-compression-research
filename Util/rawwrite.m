function rawwrite( outFName , signal)
    fid = fopen(outFName, 'w');
    fwrite(fid, signal, 'int16');
    fclose(fid);

end

