function [ cfg ] = setSphinxCfg( cfg, cfgName, cfgValue )
%SETSPHINXCFG Change the parameter in config
%   Detailed explanation goes here

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