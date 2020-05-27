function doGlmAnalysisHist(BehaveData, timesegments, t, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputfile)




for time_seg_i = 1:size(timesegments,2)
    
    timeinds = find(t >= timesegments(1,time_seg_i) & t <= timesegments(2,time_seg_i));
    for fold_i = 1:foldsNum
        test_i = INDICES == fold_i;
        train_i = ~test_i;
       
        Y_train{fold_i} = imagingData.samples(:, :, train_i == true);
        Y_train{fold_i} = Y_train{fold_i}(:,timeinds,:);
        Y_test{fold_i} = imagingData.samples(:, :, test_i == true);
        Y_test{fold_i} = Y_test{fold_i}(:,timeinds,:);
        [X_train{fold_i}, x_train{fold_i}] = getFilteredBehaveData(generalProperty.successLabel,...
            BehaveData, eventsNames, eventsTypes, splinesFuns, train_i, timeinds, generalProperty);
        [X_test{fold_i}, x_test{fold_i}] = getFilteredBehaveData(generalProperty.successLabel, ...
            BehaveData, eventsNames, eventsTypes, splinesFuns, test_i, (timeinds), generalProperty);
        
        types = unique(X_train{fold_i}.type);
        
        
        
    end
    
    
    for nrni = 1:size(imagingData.samples, 1)
        
        
        for fold_i = 1:foldsNum
            
            Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
            Yte = squeeze(Y_test{fold_i}(nrni, :, :));
            
            [ glmmodelfull{time_seg_i}.x(:, nrni, fold_i ), glmmodelfull{time_seg_i}.x0(nrni, fold_i ), ...
                R2full_tr{time_seg_i}(nrni, fold_i ), R2full_te{time_seg_i}(nrni, fold_i)] = LassoCV(x_train{fold_i}, Ytr(:), foldsNum, x_test{fold_i}, Yte(:));
        end
        
    
        for fold_i = 1:foldsNum
            
            Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
            Yte = squeeze(Y_test{fold_i}(nrni, :, :));
            
            for type_i = 1:length(types)
                binds = setdiff(1:size(x_train{fold_i},2), find(X_train{fold_i}.type==types(type_i)));
                [ glmmodelpart{time_seg_i, type_i}.x(:, nrni, fold_i ), glmmodelpart{time_seg_i}.x0(nrni, fold_i,type_i ), R2p_train{time_seg_i}(nrni, type_i, fold_i), R2p_test{time_seg_i}(nrni, type_i, fold_i)] = ...
                    LassoCV(x_train{fold_i}(:, binds), Ytr(:), foldsNum, x_test{fold_i}(:, binds), Yte(:));
            end
            
        end
        
        
    end
end 
save(outputfile, 'R2p_test','glmmodelpart','glmmodelfull','R2full_te','R2full_tr','timesegments','eventsNames', 'eventsTypes', 'INDICES');    