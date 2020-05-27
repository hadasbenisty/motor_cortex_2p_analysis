function diffMapAnalysis(X, labels)

load('quest_params.mat', 'params');
init_aff = CalcInitAff(X, params.init_aff{3}, 3);
Tree = params.tree{3}.buildTreeFun(init_aff, params.tree{3});
figure;
treeplot(nodes(Tree), '.')
hold on;
nT = length(labels);

[x_layout,y_layout] = treelayout(nodes(Tree));

%-- Remove nodes and take only leafs of tree:
x_layout(1 : end - nT) = [];
y_layout(1 : end - nT) = [];

% scatter(x_layout, y_layout, 50, 1 : length(x_layout), 'fill');
scatter(x_layout(labels == 1), y_layout( labels == 1), 50, 'b', 'fill');
hold all;
scatter(x_layout(labels == 2), y_layout( labels == 2), 50, 'r', 'fill');

    







