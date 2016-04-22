% continuous hmm+gmm practice by htk
% Now let use fit a mixture of M=2 Gaussians for each of the Q=2 states using K-means.
M = 32;
Q = 32;
left_right = 0;
PRIOR = ones(Q,1)/Q;
ESTTR2 = TRGUESS;
[LL, ESTPRIOR, ESTTR2, mu1, Sigma1, mixmat1] = ...
    mhmm_em(MFCCs(:,:), PRIOR, ESTTR2, GMM.mu', GMM.Sigma', GMM.PComponents', 'max_iter', 100);

% [loglik, errors] = mhmm_logprob(MFCCs(:,:), (ones(5,1)/5)', ESTTR,GMM.mu', GMM.Sigma',repmat(GMM.PComponents,5,1))


[y,logComp]=pdf(GMM,MFCCs');
