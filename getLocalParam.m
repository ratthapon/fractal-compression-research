function [localParam, comIdx] = getLocalParam(paramPool, comPool)
% this function design to assign parameter values for each of computers
% Input
%   paramPool - pool of a parameter value
%   comPool - pool of computer number
% Output
%   localParam - list of assigned values
%   comIdx - logical number of computer in comPool
% Example
%   poolV1 = (1:40)'; % we have 40 
%   comPool = (1:20)';
%   localVar = getLocalParam(poolV1, comPool)
%   for i = localVar
%       % use
%       i
%   end
%

%%
nParam = size(paramPool,1) / size(comPool,1);
% default comIdx
[~, comName] = system('hostname');
% for test 
% comName = 'test2';
comIdx = java.lang.Integer.parseInt( ...
    regexp(comName,'\d*','Match'));
comIdx = (comIdx - comPool(1));
localParamStartIdx = comIdx * nParam + 1;
localParamEndIdx = localParamStartIdx + nParam - 1;
localParam = paramPool(localParamStartIdx:localParamEndIdx);

