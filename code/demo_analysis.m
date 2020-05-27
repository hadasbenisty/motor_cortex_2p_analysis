%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main script for analysis published in:
% Levy, Lavzin, Benisty et al., "Cell-type-specific outcome representation 
% in primary motor cortex", Neuron, 2020.
%
% Code written by:
%  Hadas Benisty, Yale University, hadas.benisty@gmail.com
%  Shay Ahvat, Technion, shay.achvat@campus.technion.ac.il
%  May 2020
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data of a single session (one animal, layer 2/3)
load('../data/layer23_animal1.mat');
sf_labels = ones(size(BehaveData.success.indicatorPerTrial));
sf_labels(BehaveData.failure.indicatorPerTrial==1) = 2;

%% Figure 4 A
% 2D projection of trials by PCA
Pca2D(imagingData.samples, sf_labels);
% Tree partition of trials by Diffusion Map
diffMapAnalysis(imagingData.samples, sf_labels);
%% Figure 4 C+E 
pcaTrajectories(imagingData.samples, sf_labels, BehaveData);
%% Figure 4 F 
svmAccuracyAnalysis(imagingData.samples, sf_labels);
%% GLM Analysis
glmAnalysis(generalProperty, imagingData, BehaveData, 'glmres.mat');