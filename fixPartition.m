function S = fixPartition(A,blkSize)

[M,N] = size(A);
S = zeros(M,N);
maxDim = blkSize;
minDim = blkSize/2;

% Initialize blocks
S(1:maxDim:M, 1:maxDim:N) = maxDim;

dim = maxDim;
func = 'QTDECOMP_Split';

while (dim > minDim)
    % Find all the blocks at the current size.
    [blockValues, Sind] = qtgetblk(A, S, dim);
    if (isempty(Sind))
        % Done!
        break;
    end
    doSplit = feval(func, dim, blkSize, Sind);
    
    % Record results in output matrix.
    dim = dim/2;
    Sind = Sind(doSplit);
    Sind = [Sind ; Sind+dim ; (Sind+M*dim) ; (Sind+(M+1)*dim)];
    S(Sind) = dim;
end

S = sparse(S);

%%%
%%% Subfunction QTDECOMP_Split - the default split tester
%%%
function dosplit = QTDECOMP_Split(Dim, blkSize, L)
l = length(L);
if ( Dim > blkSize )
     dosplit(:,:,1:l) = ~0;
else
     dosplit(:,:,1:l) = ~1;
end     

