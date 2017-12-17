function outResult = mulconcheck( varargin )
%CONCHECK Check the condition, then return the proper result. This function
% design for anonymous function in MATLAB.
%   varargin - if index at i is odd number, the variable(i) is condition of index i
%               and variable(i+1) is a result

if mod(nargin, 2) ~=0
    disp('Error: num inpust should be even number');
end

for i = 1:2:nargin
    if varargin{i} == true
       outResult = varargin{i+1}; 
    end
end
