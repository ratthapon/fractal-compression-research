function [ output_path ] = normpath( path )
%NORMPATH Summary of this function goes here
%   Detailed explanation goes here
    output_path = regexprep(path, '\', '/');

end

