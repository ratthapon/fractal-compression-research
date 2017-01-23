function [ CC ] = spec2ceps( spec )
%SPEC2CEPS Extract the cepstrum from spectrum

% Cepstral lifter routine (see Eq. (5.12) on p.75 of [1])
ceplifter = @( N, L )( 1+0.5*L*sin(pi*[0:N-1]/L) );

[ ~, ~, ~, ~, ~, L, ~, ~ ] = getMFCCSphinxParams();
[M, N] = size(spec);
N = N + 1;

% DCT matrix computation
DCT = dctm( N, M );

% Conversion of logFBEs to cepstral coefficients through DCT
CC =  DCT * log(1+spec);

% Cepstral lifter computation
lifter = ceplifter( N, L );

% Cepstral liftering gives liftered cepstral coefficients
CC = diag( lifter ) * CC; % ~ HTK's MFCCs
CC = CC(2:end,:);

end

