function pcaTrajectories(X, labels, BehaveData)
% analysis
for k=1:size(X,1)
    X_NT(:, k) = reshape(X(k,:,:), size(X,3)*size(X,2),1);
end
[pcaTrajres.kernel, pcaTrajres.mu, pcaTrajres.eigs] = mypca(X_NT);
th = 0.95;
inds=find(cumsum(pcaTrajres.eigs.^2)/sum(pcaTrajres.eigs.^2)>th);
if isempty(inds)
    effectiveDim = length( vals);
else
    effectiveDim = inds(1);
end

[recon_m, projeff] = linrecon(X_NT, pcaTrajres.mu, pcaTrajres.kernel, 1:effectiveDim);

for l=1:size(recon_m,2)
    pcaTrajres.recon(l,:,:) = reshape(recon_m(:,l),size(X,2),size(X,3));
end
for l=1:size(projeff,2)
    pcaTrajres.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));
    
end


startBehaveTime = 120;
endBehaveTime = 180;

% BehaveDatagrab
t = linspace(0, 12, size(X,2)) - 4;

[dprimeSmoothed, dprimeNextSmoothed] = evalDprime(pcaTrajres.recon, labels);
plotDprime(t, dprimeSmoothed, dprimeNextSmoothed, ...
    14, -2.5, ...
    0);

b = fir1(10,.3);
trajSmooth = filter(b,1, pcaTrajres.projeff, [], 2);
trajSmooth=trajSmooth(:,6:end,:);

allTimemean = mean(trajSmooth,3).';



color_mat     = colormap('jet');
t1 = t(6:end);
colorparam_c1 = 1 + floor((length(color_mat)-1) * (t1 - min(t1)) / (max(t1) - min(t1)));

color_mat     = color_mat(colorparam_c1, :);


scatter3(allTimemean(:,1), allTimemean(:,2), allTimemean(:,3), 30, color_mat, 'Fill');
c=colorbar;
set(c,'Location','EastOutside');
%         title(title_str);
xlabel('\psi_1', 'FontSize',14);
ylabel('\psi_2', 'FontSize',14); zlabel('\psi_3', 'FontSize',14);
clrs = [0     0     1; 1     0     0];
figure;
plotTrajMeanRBstartMove({'success'   'failure'}, clrs, trajSmooth, labels,1, ...
    240, [], [], 14);





end

function [U, mu, eigvals] = mypca(x)
mu= mean(x);
x_cent = bsxfun(@minus, x, mean(x));
[U, p, eigvals] = pca(x_cent);
end

function [recon_m, proj] = linrecon(x, mu, KernelMat, dim)
x_cent = bsxfun(@minus, x, mu);

proj = x_cent*KernelMat(:,dim);
recon = proj*KernelMat(:,dim)';
recon_m = bsxfun(@plus,recon,mu);

end