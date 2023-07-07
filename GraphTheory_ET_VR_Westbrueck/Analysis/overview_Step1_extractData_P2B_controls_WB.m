%% ------------------ extractData_PTB_control_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

cd 'D:\WestbrookData\';
%--------------------------------------------------------------------------

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


% allData = readtable('df_PTB_Ctrl_Preprocessed.csv');
allData_unix = readtable('F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\ df_PTB_Ctrl_Preprocessed_UnixTS.csv');
% allData_unix2 = readtable('F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\df_PTB_Ctrl_Preprocessed_TimeStamp_09.05.csv');


selectedData = table;
selectedData.SubjectID = allData_unix.SubjectID;
selectedData.TimeStampBegin = allData_unix.TimeStampBegin;
selectedData.TrialDuration = allData_unix.TrialDuration;
selectedData.StartingPositionIndex = allData_unix.StartingPositionIndex;
selectedData.StartBuildingName = cellstr(strcat('TaskBuilding_', num2str(selectedData.StartingPositionIndex+1)));
selectedData.TargetBuildingName = allData_unix.TargetBuildingName;
selectedData.RecalculatedAngle = allData_unix.RecalculatedAngle;


%%calculate distance
selectedData.DistancePart2TargetBuilding = sqrt((allData_unix.ParticipantPosition_x - allData_unix.ParticipantPosition_z).^2 + (allData_unix.TargetBuildingPosition_x - allData_unix.TargetBuildingPosition_z).^2);


save([savepath 'selectedData_P2B_control.mat'],'selectedData');
writetable(selectedData, [savepath 'selectedData_P2B_control.csv']);









