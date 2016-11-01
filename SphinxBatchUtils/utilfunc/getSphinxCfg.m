function [ cfgValue ] = getSphinxCfg( cfg, cfgName)
%GETSPHINXCFG Get the parameter in config
%   cfg - Config object. May load from parseSphinxCfg()
%   cfgName - name of parameter
%   cfgValue - string value of parameter

cfgLineIndex = -1;
for i = 1:size(cfg, 1)
    if ~isempty(regexp(cfg{i},['\$' cfgName ' = '],'match'))
        cfgLineIndex = i;
    end
end
if cfgLineIndex ~= -1
    cfgValue = regexp(cfg{cfgLineIndex}, ' = ', 'split');
    cfgValue = regexprep(cfgValue, ' ', '');
    cfgValue = regexprep(cfgValue, ';', '');
else
    ['No parameter ' cfgName ' exists.']
end
end