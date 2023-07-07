%% ------------------ variance_analysis_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 

savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];


%% load data

dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
dataP2B_withoutRep_pred = readtable(' dataP2B_withoutReps_predictions.csv');


% load trial id table

stCombiIds = load('uniqueTrials_routeID.mat');
stCombiIds = stCombiIds.uniqueTrials;


% dataP2B_stCombi_means
mean_stCombi_overview = table;

dataP2B_stCombi_means = table;

for index = 1:height(stCombiIds)
    
    currentStCombi = stCombiIds{index,3};
    selectionPart_56 = strcmp(dataP2B_withoutRep_pred.RouteID, currentStCombi);
    selectionPart_112 = strcmp(dataP2B.RouteID, currentStCombi);
    
%     mean_stCombi_overview.stC_Mean_112(index) =  mean(dataP2B.RecalculatedAngle(selectionPart_112));
    
    mean_stCombi_overview.stC_Mean_112(index) = mean(dataP2B.RecalculatedAngle(selectionPart_112));
    mean_stCombi_overview.stC_Mean_56(index) = mean(dataP2B_withoutRep_pred.RecalculatedAngle(selectionPart_56));

    
    mean_stCombi_overview.stC_Mean_Predictions_Mfull_112(index) = mean(dataP2B_withoutRep_pred.Predictions_full_112(selectionPart_56));
    mean_stCombi_overview.stC_Mean_Predictions_Mfull_56(index) = mean(dataP2B_withoutRep_pred.Predictions_full_56(selectionPart_56));
    
    mean_stCombi_overview.stC_Mean_Predictions_M2(index) = mean(dataP2B_withoutRep_pred.Predictions_M2(selectionPart_56));
    mean_stCombi_overview.stC_Mean_Predictions_M3(index) = mean(dataP2B_withoutRep_pred.Predictions_M3(selectionPart_56));
    mean_stCombi_overview.stC_Mean_Predictions_M4(index) = mean(dataP2B_withoutRep_pred.Predictions_M4(selectionPart_56));

    
    
    
    dataP2B_stCombi_means.stCombiID(index) = currentStCombi;
    dataP2B_stCombi_means.AngularError(index) = mean(dataP2B.RecalculatedAngle(selectionPart_112));
    dataP2B_stCombi_means.DistancePart2TargetBuilding(index) = mean(dataP2B{selectionPart_112,8});
    dataP2B_stCombi_means.NodeDegreeStartBuilding(index) = mean(dataP2B{selectionPart_112,9});
    dataP2B_stCombi_means.NodeDegreeTargetBuilding(index) = mean(dataP2B{selectionPart_112,10});
    dataP2B_stCombi_means.NodeDegreeWeightedStartBuilding(index) = mean(dataP2B{selectionPart_112,11});
    dataP2B_stCombi_means.NodeDegreeWeightedTargetBuilding(index) = mean(dataP2B{selectionPart_112,12});
    dataP2B_stCombi_means.MaxFlowS(index) = mean(dataP2B{selectionPart_112,13});
    dataP2B_stCombi_means.MaxFlowWeighted(index) = mean(dataP2B{selectionPart_112,14});
    dataP2B_stCombi_means.ShortestPathDistance(index) = mean(dataP2B{selectionPart_112,15});
    dataP2B_stCombi_means.AlternatingIndex(index) = mean(dataP2B{selectionPart_112,16});
    dataP2B_stCombi_means.StartBuildingDwellingTime(index) = mean(dataP2B{selectionPart_112,17});
    dataP2B_stCombi_means.TargetBuildingDwellingTime(index) = mean(dataP2B{selectionPart_112,18});
    
end

dataP2B_stCombi_means = [dataP2B_stCombi_means, mean_stCombi_overview];
% save new dataP2B_stCombi_means

save([savepath 'dataP2B_stCombi_means.mat'],'dataP2B_stCombi_means');
writetable(dataP2B_stCombi_means, [savepath, 'dataP2B_stCombi_means.csv']);


% % check the differences between the different means based on the 56 or
% 112 data rows for each participant
% testMeans = mean_stCombi_overview.stC_Mean_112 == mean_stCombi_overview.stC_Mean_56;
% 
% mean_stCombi_overview.test56_112 = testMeans;
meanError = mean(mean_stCombi_overview.stC_Mean_112);
mean_stCombi_overview.Error_minus_Mean = mean_stCombi_overview.stC_Mean_112 - meanError;

mean_stCombi_overview.Error_minus_Pred_MF = mean_stCombi_overview.stC_Mean_112 - mean_stCombi_overview.stC_Mean_Predictions_Mfull_112;

mean_stCombi_overview.Error_minus_Pred_M2 = mean_stCombi_overview.stC_Mean_112 - mean_stCombi_overview.stC_Mean_Predictions_M2;
mean_stCombi_overview.Error_minus_Pred_M3 = mean_stCombi_overview.stC_Mean_112 - mean_stCombi_overview.stC_Mean_Predictions_M3;
mean_stCombi_overview.Error_minus_Pred_M4 = mean_stCombi_overview.stC_Mean_112 - mean_stCombi_overview.stC_Mean_Predictions_M4;

meanError56 = mean(mean_stCombi_overview.stC_Mean_56);
mean_stCombi_overview.Error_minus_Mean_2 = mean_stCombi_overview.stC_Mean_56 - meanError56;
mean_stCombi_overview.Error_minus_Pred_MF_2 = mean_stCombi_overview.stC_Mean_56 - mean_stCombi_overview.stC_Mean_Predictions_Mfull_56;



% calculate variances and R²

overviewR2 = table;

overviewR2.Var_MF = var(mean_stCombi_overview.Error_minus_Pred_MF)/var(mean_stCombi_overview.Error_minus_Mean);
overviewR2.Var_MF_56 = var(mean_stCombi_overview.Error_minus_Pred_MF_2)/var(mean_stCombi_overview.Error_minus_Mean_2);

overviewR2.Var_M2= var(mean_stCombi_overview.Error_minus_Pred_M2)/var(mean_stCombi_overview.Error_minus_Mean);
overviewR2.Var_M3 = var(mean_stCombi_overview.Error_minus_Pred_M3)/var(mean_stCombi_overview.Error_minus_Mean);
overviewR2.Var_M4 = var(mean_stCombi_overview.Error_minus_Pred_M4)/var(mean_stCombi_overview.Error_minus_Mean);

overviewR2.R2_MF = 1- overviewR2.Var_MF;
overviewR2.R2_MF_56 = 1- overviewR2.Var_MF_56;
overviewR2.R2_M2 = 1- overviewR2.Var_M2;
overviewR2.R2_M3 = 1- overviewR2.Var_M3;
overviewR2.R2_M4 = 1- overviewR2.Var_M4;


save([savepath 'overviewR2_s-t-combi_means.mat'],'overviewR2');
writetable(overviewR2, [savepath, 'overviewR2_s-t-combi_means.csv']);


varA = var(mean_stCombi_overview.Error_minus_Pred_MF);
varB = var(mean_stCombi_overview.Error_minus_Mean);

varQuotient = varA/varB;
disp('--------------------------------------------------------------------');
disp(strcat('varA / varB = ', num2str(varQuotient)));

r2_var = 1- varQuotient;
disp(strcat('R2 = 1- (varA/varB) = ', num2str(r2_var)));


% calculate R2 based on the sum of squared residuals

ssA = sum(mean_stCombi_overview.Error_minus_Pred_MF.^2);
ssB = sum(mean_stCombi_overview.Error_minus_Mean.^2);

ssQuotient = ssA/ssB;
disp('--------------------------------------------------------------------');
disp(strcat('ss2A / ss2B = ', num2str(ssQuotient)));

r2_ss = 1- ssQuotient;
disp(strcat('R2 = 1- (ss²A/ss²B) = ', num2str(r2_var)));





% 
% var112 = var(mean_stCombi_overview.stC_Mean_112);
% var56 = var(mean_stCombi_overview.stC_Mean_56);
% varPred = var(mean_stCombi_overview.stC_Mean_Predictions);
% 
% testVars = var112 == var56;
% 
% explainedVar112 = varPred/var112;
% 
% explainedVar56 = varPred/var56;
% 
% 
% 
% 
% 



