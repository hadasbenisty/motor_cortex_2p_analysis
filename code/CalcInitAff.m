function [ aff_mat, slices ] = CalcInitAff( data, params, dim )
% Calculates the affinity between slices by columns of the data as thresholded
% cosine similarity between columns, or as a Gaussian kernel of width
% eps*(median distance between 5 nearest neighbors of all points).
%
% Inputs:
%     data - M-by-N-by-nT matrix
%     params - struct array with user parameters
%
% Output:
%     aff_mat - N-by-N symmetric matrix of non-negative affinities
%--------------------------------------------------------------------------
dimLen = length(size(data));


data   = permute(data, [setdiff(1:dimLen, dim), dim]);
slices = reshape(data, [], size(data, dimLen));


switch params.metric
    case {'euc','L2'}
        euc_dist = squareform(pdist(slices.'));
        nn_dist = sort(euc_dist.').';
        params.knn = min(params.knn, size(nn_dist, 2));
        sigma = params.eps * median(reshape(nn_dist(:, 1:params.knn), size(nn_dist,1)*params.knn,1));
        if sigma == 0
            sigma = params.eps * mean(reshape(nn_dist(:, 1:params.knn), size(nn_dist,1)*params.knn,1));
        end
        aff_mat = exp(-euc_dist.^2/(2*sigma^2));
        
    otherwise
        error('params.metric is not well define, please fix it');
        
end



