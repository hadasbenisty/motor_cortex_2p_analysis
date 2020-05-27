function [x, x0, R2Tr, R2Te] = LassoCV(Atr, btr, foldsNum, Ate, bte)
[B,FitInfo] = lasso(Atr,btr,'CV',foldsNum,  'NumLambda',10);
x = B(:, FitInfo.IndexMinMSE);
x0 = FitInfo.Intercept(FitInfo.IndexMinMSE);
R2Tr = var(Atr*x + x0)/var(btr);
R2Te = var(Ate*x + x0)/var(bte);
% b = glmfit(Atr,btr, 'normal');
% x = b(2:end);
% x0 =  b(1);
% var(Ate*b(2:end) + b(1) - bte)/var(bte)
