function [ cfg ] = setSphinxCfg( cfg, cfgName, cfgValue )
%SETSPHINXCFG Change the parameter in config
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
    cfg{cfgLineIndex} = ['$' cfgName ' = ' cfgValue ';'];
else
    ['set parameter ' cfgName ' failed']
end
end