%% ------------------ addFRSInformation_P2BPrep_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 

savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];


%% load overview
overviewTableP2BPrep3 = readtable('overviewTable_P2B_Prep2.csv');

overviewFRS = readtable('Overview_FRS_Data.csv');


%% add FRS data
lastPart = 0;

for index = 1:height(overviewFRS)
    
    currentPart = overviewFRS.Participant(index);   
    
    
    selectionPart = currentPart == overviewTableP2BPrep3.SubjectID;
     
    overviewTableP2BPrep3.Mean_egocentric_global(selectionPart) = overviewFRS.Mean_egocentric_global(index);
    
    overviewTableP2BPrep3.Mean_survey(selectionPart) = overviewFRS.Mean_survey(index);
    
    overviewTableP2BPrep3.Mean_cardinal(selectionPart) = overviewFRS.Mean_cardinal(index);
    
    


end

%% remove the unnecessary variables

%overviewTableP2BPrep3(:,1:4) = [];

%% create overview for the data without repeting trials 
% (with mean in angle error and distancePart2TargetBuilding)

overviewTableP2BPrep3_withoutReps = overviewTableP2BPrep3;

%% add trial IDs and error difference between repeated trials

uniqueTrials = unique(overviewTableP2BPrep3(:,5:6),'rows');


for index = 1: height(uniqueTrials)
   
    uniqueTrials.RouteID(index) = {strcat('RouteID_',num2str(index))};
    
end

% save trial ID overview
save([savepath 'uniqueTrials_routeID.mat'],'uniqueTrials');
writetable(uniqueTrials, [savepath, 'uniqueTrials_routeID.csv']);

% overview Trial Rep Difference

trialRepDiffAbs = [];
trialRepDiffMean = [];
trialRepDiffStd = [];
overviewRepetitionData = table;


for indexPart = 1:length(PartList)
    
    currentPart = PartList(indexPart);
    selectionPart = overviewTableP2BPrep3.SubjectID == currentPart;   
    
    selectionTable = table;
    selectionTable.SubjectID(1:height(uniqueTrials)) = currentPart;
    
    for indexTrial = 1:height(uniqueTrials)
        currentSB = uniqueTrials{indexTrial,1};
        currentTB = uniqueTrials{indexTrial,2};
        
        selectionSB = strcmp(overviewTableP2BPrep3.StartBuildingName, currentSB);
        selectionTB = strcmp(overviewTableP2BPrep3.TargetBuildingName, currentTB);
        
        trialIndeces = selectionPart & selectionSB & selectionTB;
        
        % add the trial id to the data overviews
        overviewTableP2BPrep3.RouteID(trialIndeces) = uniqueTrials{indexTrial,3};
        overviewTableP2BPrep3_withoutReps.RouteID(trialIndeces) = uniqueTrials{indexTrial,3};
        
        % now identify which trial is the first one and which the
        % repetition
        
        locationIndex = find(trialIndeces);
        
        if length(locationIndex) == 2
            
            loc1 = locationIndex(1);
            loc2 = locationIndex(2);
            
        else
            disp('Problem - more than 2 of the same trials');
            disp(strcat(num2str(currentPart),' ',uniqueTrials(indexTrial,:)));
        end
        
        if (overviewTableP2BPrep3.TimeStampBegin(loc1) - overviewTableP2BPrep3.TimeStampBegin(loc2)) < 0
            
            overviewTableP2BPrep3.TrialOrder(loc1) = 1;
            overviewTableP2BPrep3.TrialOrder(loc2) = 2;
            
            overviewTableP2BPrep3_withoutReps.TrialOrder(loc1) = 1;
            overviewTableP2BPrep3_withoutReps.TrialOrder(loc2) = 2;
            
        elseif (overviewTableP2BPrep3.TimeStampBegin(loc1) - overviewTableP2BPrep3.TimeStampBegin(loc2)) > 0
            
            overviewTableP2BPrep3.TrialOrder(loc1) = 2;
            overviewTableP2BPrep3.TrialOrder(loc2) = 1;
            
            overviewTableP2BPrep3_withoutReps.TrialOrder(loc1) = 2;
            overviewTableP2BPrep3_withoutReps.TrialOrder(loc2) = 1;
            
        else
            disp('Something went wrong when identifying the trial order');
            
        end
        
        % update the data overview without repetitions and remove rep row
        overviewTableP2BPrep3_withoutReps.RecalculatedAngle(loc1) = mean(overviewTableP2BPrep3.RecalculatedAngle(trialIndeces));
        overviewTableP2BPrep3_withoutReps.DistancePart2TargetBuilding(loc1) = mean(overviewTableP2BPrep3.DistancePart2TargetBuilding(trialIndeces));
        overviewTableP2BPrep3_withoutReps.TrialDuration(loc1) = mean(overviewTableP2BPrep3.TrialDuration(trialIndeces));
        
%         overviewTableP2BPrep3_withoutReps(loc2,:) = []; 
        
        % calculate the difference between the error in the rep trials and
        % add to overview
        
        trialError = overviewTableP2BPrep3.RecalculatedAngle(trialIndeces); 
       
        absError = ((trialError(1)-trialError(2))^2)/4;
        meanError = mean([trialError(1), trialError(2)]);
        stdError = std([trialError(1), trialError(2)]);
        
        trialRepDiffAbs(indexPart,indexTrial) = absError;
        trialRepDiffMean(indexPart,indexTrial) = meanError;
        trialRepDiffStd(indexPart,indexTrial) = stdError;
        
        selectionTable.RouteID(indexTrial) = uniqueTrials{indexTrial,3};
        selectionTable.AbsError(indexTrial) = absError;
        selectionTable.MeanError(indexTrial) = meanError;
        selectionTable.StdError(indexTrial) = stdError;
        
    end
    
    overviewRepetitionData = [overviewRepetitionData; selectionTable];
    
end

% remove all repetition trials from the overview
reps = overviewTableP2BPrep3_withoutReps.TrialOrder == 2;
overviewTableP2BPrep3_withoutReps(reps,:) = [];


overviewTrialRepDiffAbs = table;
overviewTrialRepDiffAbs.Participants = PartList';

overviewTrialRepDiffAbs = [overviewTrialRepDiffAbs, array2table(trialRepDiffAbs, 'VariableNames', uniqueTrials.RouteID)];

%% save data overview 
save([savepath 'overviewTable_P2B_Prep_complete.mat'],'overviewTableP2BPrep3');
writetable(overviewTableP2BPrep3, [savepath, 'overviewTable_P2B_Prep_complete.csv']);

save([savepath 'overviewTable_P2B_Prep_complete_withoutReps.mat'],'overviewTableP2BPrep3_withoutReps');
writetable(overviewTableP2BPrep3_withoutReps, [savepath, 'overviewTable_P2B_Prep_complete_withoutReps.csv']);


% save other overviews
save([savepath 'trialRepDiffAbs.mat'],'trialRepDiffAbs');
save([savepath 'trialRepDiffMean.mat'],'trialRepDiffMean');
save([savepath 'trialRepDiffStd.mat'],'trialRepDiffStd');

save([savepath 'overviewTrialRepDiff_absoluteError.mat'],'overviewTrialRepDiffAbs');
writetable(overviewTrialRepDiffAbs, [savepath, 'overviewTrialRepDiff_absoluteError.csv']);

save([savepath 'overviewRepetitionData.mat'],'overviewRepetitionData');
writetable(overviewRepetitionData, [savepath, 'overviewRepetitionData.csv']);


disp('Data saved')



