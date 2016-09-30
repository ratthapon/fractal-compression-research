function writeSphinxCfg( cfg, cfgOutPath )
%WRITESPHINXCFG Write the sphinx config cell array to output path
%   cfgOutPath - output file include extension

fid = fopen(cfgOutPath, 'w');
fprintf(fid, '%s \r\n',cfg{:});
fclose(fid);
end

