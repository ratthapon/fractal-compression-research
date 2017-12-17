function [ cfg ] = parseSphinxCfg( cgfPath )
%PARSESPHINXCFG Load the config file from path and return the cell array of
%config
%   cgfPath - path include extension to config file 

% import cfg file
fid = fopen(cgfPath,'r');
cfg = textscan(fid, '%s','Delimiter','\n');
fclose(fid);

cfg = cfg{1};

end

