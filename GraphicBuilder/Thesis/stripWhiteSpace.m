function [ striped ] = stripWhiteSpace( label )
%STRIPWHITESPACE Summary of this function goes here
%   Detailed explanation goes here
striped = regexprep(label, '  ', ' ');
for i = 1:15
    striped = regexprep(striped, '  ', ' ');
end
striped = regexp(striped, ' ', 'split');
striped = striped(1:end-1);

for i = 1:length(striped)
    striped{i} = lower(striped{i});
end

end

