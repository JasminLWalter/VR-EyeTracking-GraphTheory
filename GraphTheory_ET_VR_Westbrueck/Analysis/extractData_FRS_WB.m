%% ------------------ extractData_FRS_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

cd 'F:\Westbrueck Data\SpaRe_Data\2_PointingTasks_GHP\';



allData = readtable('FRS_Data_Complete_flattened.csv');



control = strcmp(allData.Condition, 'Control');
controlData = allData(control,:);


% 26 participants
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

% sanity check - are the participants identical to the ones in the FRS
% data?

checkParts = unique(controlData.Participant_ID);

check2 = cell2mat(PartList)';

testParts = sum(checkParts == check2);

if(testParts ==26)
    disp('participant list and participants ids in data are identical');
end

% prepare data structure
overviewFRSData = cell2table(PartList', 'VariableName', {'Participant'});

% extract the relevant data

Number = length(PartList);
noFilePartList = [];

for ii = 1:Number
    currentPart = cell2mat(PartList(ii));   
    
    % find all data of current participant
    selection = controlData.Participant_ID == currentPart;
    currentData = controlData(selection,:);
    
    % calculate mean and std for each scale
    
    % scale 1
    selectionScale1 = strcmp(currentData.Scale, 'Egocentric/global');
    questionData1 = currentData(selectionScale1,:);    
    
    overviewFRSData.Mean_egocentric_global(ii) = mean(questionData1.Answer);
    overviewFRSData.STD_egocentric_global(ii) = std(questionData1.Answer);
    overviewFRSData.NrAnswers_egocentric_global(ii) = sum(selectionScale1);
    
    % scale 2
    selectionScale2 = strcmp(currentData.Scale, 'Survey');
    questionData2 = currentData(selectionScale2,:);    
    
    overviewFRSData.Mean_survey(ii) = mean(questionData2.Answer);
    overviewFRSData.STD_survey(ii) = std(questionData2.Answer);
    overviewFRSData.NrAnswers_survey(ii) = sum(selectionScale2);
    
    % scale 3
    selectionScale3 = strcmp(currentData.Scale, 'Cardinal');
    questionData3 = currentData(selectionScale3,:);    
    
    overviewFRSData.Mean_cardinal(ii) = mean(questionData3.Answer);
    overviewFRSData.STD_cardinal(ii) = std(questionData3.Answer);
    overviewFRSData.NrAnswers_cardinal(ii) = sum(selectionScale3);

end

% 
% save overview
save([savepath 'Overview_FRS_Data.mat'],'overviewFRSData');
writetable(overviewFRSData, [savepath, 'Overview_FRS_Data.csv']);

disp('Data saved')

