function tree = BuildGenericTdTreesViaClustering(data, params)

[vecs, vals] = CalcEigs(data, params.eigs_num);
embeddings = vecs*vals; 
    

%initialize root (top-most level):
N = size(embeddings, 1);
rev_tree{1}.folder_count = 1;
rev_tree{1}.folder_sizes = N;
rev_tree{1}.clustering = ones(1, N);
rev_tree{1}.super_folders = [];
if length(params.splitsNum) == 1
    splitsNum = params.splitsNum*ones(min(params.treeDepth,100), 1);
else
    splitsNum = params.splitsNum;
end
clustering = feval(params.clusteringAlgo, embeddings, splitsNum(1), params);
clustering = sortClustersByData(embeddings, clustering);


rev_tree{2}.folder_count = numel(unique(clustering));
rev_tree{2}.clustering = clustering;
for ki = 1:rev_tree{2}.folder_count
    rev_tree{2}.folder_sizes(ki) = sum(rev_tree{2}.clustering == ki);
end
rev_tree{2}.super_folders = ones(1, rev_tree{2}.folder_count);
currLevel = 3;
MAX_ITERS = 1e6;
for iter = 1:MAX_ITERS
    if params.treeDepth <= currLevel
        break;
    end
    rev_tree{currLevel}.super_folders = [];
    clusters = unique(rev_tree{currLevel-1}.clustering);
    maxCluster = 0;finished=[];
    for ci = 1:length(clusters)
        curr_cluster_inds2data = find(rev_tree{currLevel-1}.clustering == clusters(ci));
%         supFolders(curr_cluster_inds2data) = ci;
        if numel(curr_cluster_inds2data) > params.min_cluster
%             if params.verbose > 1
%                 disp(['Tree level ' num2str(currLevel) ' cluster num ' num2str(ci)]);
%             end
            clustering = feval(params.clusteringAlgo, embeddings(curr_cluster_inds2data,:), splitsNum(currLevel-1), params);
            clustering = sortClustersByData(embeddings(curr_cluster_inds2data, :), clustering);

            rev_tree{currLevel}.clustering(curr_cluster_inds2data) = clustering + maxCluster;
            if max(clustering) == 1  
                finished(ci) = 1;
            else
                finished(ci) = 0;
            end
        else
           finished(ci) = 1;
           rev_tree{currLevel}.clustering(curr_cluster_inds2data) = maxCluster + 1;
        end
        maxCluster = max(rev_tree{currLevel}.clustering);
        if  finished(ci)
           rev_tree{currLevel}.super_folders = [rev_tree{currLevel}.super_folders ci];
       else
           rev_tree{currLevel}.super_folders = [rev_tree{currLevel}.super_folders ci*ones(1, numel(unique(clustering)))];
       end
    end
    
%     for ci = 1:length(finished)
%        if  finished(ci)
%            rev_tree{currLevel}.super_folders = [rev_tree{currLevel}.super_folders ci];
%        else
%            rev_tree{currLevel}.super_folders = [rev_tree{currLevel}.super_folders ci*ones(1, numel(unique(clustering)))];
%        end
%     end
    rev_tree{currLevel}.folder_count = numel(unique(rev_tree{currLevel}.clustering));
    for ki = 1:rev_tree{currLevel}.folder_count
        rev_tree{currLevel}.folder_sizes(ki) = sum(rev_tree{currLevel}.clustering == ki);
    end
%     % this is for sequential ordering
%     for ki = 1:rev_tree{currLevel}.folder_count
%         meanind(ki) = mean(find(rev_tree{currLevel}.clustering==ki));
%     end
%     [~, ic] = sort(meanind);
%     for ki = 1:rev_tree{currLevel}.folder_count
%         rev_tree{currLevel}.clustering(rev_tree{currLevel}.clustering==ki) = ic(ki)*100;
%     end
%     rev_tree{currLevel}.clustering=rev_tree{currLevel}.clustering/100;
    
    if all(finished)
        break;
    end
    currLevel = currLevel + 1;
end
% last level - each data point is a leaf

if rev_tree{end}.folder_count < N
    rev_tree{end+1}.folder_count = N;
    rev_tree{end}.folder_sizes = ones(1,N);
    rev_tree{end}.clustering = 1:N;
    rev_tree{end}.super_folders = rev_tree{currLevel-1}.clustering;
else
    if rev_tree{end-1}.folder_count == N
        rev_tree = rev_tree(1:end-1);
    end
end
tree = fliplr(rev_tree);
for k=1:length(tree)
    tree{k}.super_folders = transpose(tree{k}.super_folders(:));
end

