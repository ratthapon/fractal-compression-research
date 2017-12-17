function [ isMatch ] = matchSpeech( word, label1, label2  )
%MATCHSPEECH Summary of this function goes here
%   Detailed explanation goes here

striped_1 = stripWhiteSpace(label1);
striped_2 = stripWhiteSpace(label2);

isMatch = false;
for i = 1:length(striped_1)
    if lower(striped_1{i}) == lower(word) && lower(striped_2{i}) == lower(word)
        isMatch = true
    end
end

