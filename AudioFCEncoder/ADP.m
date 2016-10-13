function [ p ] = ADP(X, C, thresh)
%% partition input vector X with chuck set C, determine with thresh.
% binary partition
% depth  = n(C)

%% ensure shappe of data
X = X(:)';
C = C(:)';
t = thresh;
minRBS = C(1);
maxRBS = C(end);

L = size(X,2);
p = maxRBS * ones(1, floor(L/maxRBS)); % parts
cp = zeros(1, floor(L/maxRBS)); % completed parts
N = length(p);

%% define expression
% check if input has variance greater than thresh t
isHighVar = @(X, t) var(X/(2^15)) > t ;
isLarger = @(p, c) p > c ;
isNotMin = @(p) p > minRBS ;
isLargerThanMax = @(p) p > maxRBS ;
isSplitable = @(X, t, p, c) (isHighVar(X, t) && isLarger(p, c) && isNotMin(p)) ...
    || isLargerThanMax(p);

%% for each chunk size
for c = C(end-1:-1:1)
    location = 1;
    % for each partition k
    k = 1;
    while k < N 
        if location + p(k) - 1 > L
            break;
        end
        x_k = X(location : location + p(k) - 1);
        location = location + p(k) - 1;
        
        % check if need to partition
        if isSplitable(x_k, t, p(k), c) && cp(k) == false
            % increase part
            N = N + 1;
            
            % shift parts
            for i = N:-1:k+2
                p(i) = p(i-1);
                cp(i) = cp(i-1);
            end
            
            % assign new partition
            p(k) = c;
            p(k+1) = c;
            cp(k) = false;
            cp(k+1) = false;
            k = k + 2;
        else
            cp(k) = true;
            k = k + 1;
        end
    end
end

