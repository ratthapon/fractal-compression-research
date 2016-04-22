% pdf
rng('default')  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-1 -2];
sigma2 = [2 0; 0 1];
X = [mvnrnd(mu1,sigma1,200);mvnrnd(mu2,sigma2,100)];

scatter(X(:,1),X(:,2),10,'ko')

options = statset('Display','final');
gm = gmdistribution.fit(X,2,'Options',options);

hold on
% ezcontour(@(x,y)pdf(gm,[x y]))
ezcontour(@(x,y)pdf(gmm1,[x y]))

idx = cluster(gm,X);
cluster1 = (idx == 1);
cluster2 = (idx == 2);

hold on
scatter(X(cluster1,1),X(cluster1,2),10,'r+');
scatter(X(cluster2,1),X(cluster2,2),10,'bo');
legend('Cluster 1','Cluster 2','Location','NW')

