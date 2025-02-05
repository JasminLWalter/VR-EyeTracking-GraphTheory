%% ------------------- repetition variance analysis.m-------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% calculates the fraction of variance attributed to the deviance in answers
% during the reptition of the trials


%% start script
clear all;

%% adjust the following variables: 


savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\P2B_controls_analysis\RepetitionAnalysis\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];




%% load data

dataP2B = readtable('overviewTable_P2B_Prep_complete.csv');
dataP2B_withoutRep = readtable('overviewTable_P2B_Prep_complete_withoutReps.csv');

dataP2B.TrialTime = dataP2B.TimeStampBegin;

% load trial id table

stCombiIds = load('uniqueTrials_routeID.mat');
stCombiIds = stCombiIds.uniqueTrials;

% overall mean in pointing error / in duration for each participant
overviewDiffReps = table;


for index = 1:height(dataP2B_withoutRep)
   
    currentPart = dataP2B_withoutRep.SubjectID(index);
    currentSTcombi = dataP2B_withoutRep.RouteID(index);
    
    selectionPart = dataP2B.SubjectID == currentPart;
    selectionSTC = strcmp(dataP2B.RouteID, currentSTcombi);
    selectionOrder1 = dataP2B.TrialOrder == 1;
    selectionOrder2 = dataP2B.TrialOrder == 2;
    
    error1 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder1);
    error2 = dataP2B.RecalculatedAngle(selectionPart & selectionSTC & selectionOrder2);

    dataP2B_withoutRep.ErrorDiff(index) = error1-error2;

end

dataP2B_withoutRep.absErrorDiff = abs(dataP2B_withoutRep.ErrorDiff);

diffQ = dataP2B_withoutRep.absErrorDiff.^2;

diffQD4 = diffQ/4;

sumDiffQD4 = sum(diffQD4);

s_trialVariance = sumDiffQD4/(height(dataP2B_withoutRep) - 1);


totalVariance = var(dataP2B.RecalculatedAngle);

fractionVarOfRepeption = s_trialVariance/totalVariance;

disp(['Total variance = ', num2str(totalVariance)]);
disp(['S_trialvariance = ', num2str(s_trialVariance)]);
disp(['percentate of repeptition variance from total variance = ', num2str(fractionVarOfRepeption*100),'%']);
disp(['percentate of remaining variance to be explained in modeling =', num2str((1-fractionVarOfRepeption)*100),'%']);


% 





