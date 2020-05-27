function glmAnalysis(generalProperty, imagingData, BehaveData, outputfile)

splinesFile{1} = 'splines0.5.csv';
splinesFile{2} = 'splines2.csv';

for f_i = 1:length(splinesFile)
    
    splinesFuns{f_i}=xlsread(splinesFile{f_i});
    splinesFuns{f_i} = splinesFuns{f_i}(2:end, :);
    splinesFuns{f_i} = splinesFuns{f_i}(:, 2:end);
end

eventsNames = {'tone' 'lift' 'grab' 'atmouth' 'success' };
eventsTypes = {'tone' 'movement' 'movement' 'atmouth' 'reward' };
timesegments = generalProperty.glmSeg;
energyTh = generalProperty.glm_energyTh;
foldsNum = 2;
t = linspace(0, generalProperty.Duration, size(imagingData.samples,2)) - generalProperty.ToneTime;

INDICES = crossvalind('Kfold',size(imagingData.samples, 3),foldsNum);


doGlmAnalysisHist(BehaveData, timesegments, t,  foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputfile);

