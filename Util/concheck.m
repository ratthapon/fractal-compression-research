function outResult = concheck( con, resultIfTrue, resultIfFalse )
%CONCHECK Check the condition, then return the proper result. This function
% design for anonymous function in MATLAB.
%   con - boolean condition
%   resultIfTrue - if con is true, return this
%   resultIfFalse - if ocn is false, return this

if con
    outResult = resultIfTrue;
else
    outResult = resultIfFalse;
end

