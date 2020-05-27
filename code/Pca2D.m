function Pca2D(X, labels)

for k=1:size(X,3)
    X_NT(:, k) = reshape(X(:,:,k), size(X,1)*size(X,2),1);
end

embedding = pca(X_NT);
embedding = embedding(:,1:2);


figure;
scatter(embedding(labels==1,1)  ,embedding(labels==1,2),...
    'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
hold all;
scatter(embedding(labels==2,1)  ,embedding(labels==2,2),...
    'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');


xlabel('\psi_1'), ylabel('\psi_2');
legend({'Success', 'Failure'});






