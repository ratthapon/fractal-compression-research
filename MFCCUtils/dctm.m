function [ dctm ] = dctm( N, M  )
%DCTM Type III DCT matrix routine (see Eq. (5.14) on p.77 of [1])
dctm = sqrt(2.0/M) * cos( repmat([0:N-1].',1,M) ...
    .* repmat(pi*([1:M]-0.5)/M,N,1) ) ;

end

