%% --------------------- compareData_differentProcessing_vel_dur.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 

% Input: 
% uses 1004_Expl_S_1_ET_1_flattened.csv file
% Output: 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
% datapaths Westbrook harddrive
% savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processing_2023\';
% 
% cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\pre-processed_csv\'

% datapaths Living Transformation harddrive
savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\comparison\';

datapathOld_interpol =  'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\interpolatedColliders\';
datapathOld_gazes = 'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\gazes_vs_noise\';

datapathNew_gazes = 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_2023\velocity_based\step3_gazeProcessing\';



% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};

colliderList = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\building_collider_list.csv');

changedColliders = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\list_collider_changes.csv');


%% --------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;


% overviewDistanceCheck = table;

overviewSimiliarityGazes = table;



% loop code over all participants in participant list

for indexPart = 1:Number

    dataNewAll = table;
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    tic
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([datapathNew_gazes num2str(currentPart) '_Session_' num2str(indexSess) '*_data_processed_gazes.csv']);
        
        if isempty(dirSess)
            
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(dirSess)

                % read in the data
                dataNew = readtable(strcat(datapathNew_gazes, dirSess(indexET).name));

                helperT = table;

                helperT.timeStampDataPointStart = dataNew.timeStampDataPointStart;
                helperT.timeDiff = [0; diff(dataNew.timeStampDataPointStart)];
                helperT.isFix = dataNew.isFix;
                helperT.events = dataNew.events;
                helperT.cleanData = dataNew.cleanData;
                helperT.isBlink = dataNew.isBlink;


                dataNewAll = [dataNewAll;helperT];

                clear dataNew

            end
        end
    end
    

    % load old processing data

    file1 = strcat(datapathOld_interpol, num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
    interpolatedData = load(file1);
    interpolatedData = interpolatedData.interpolatedData;

    allTimeStampsOld = [interpolatedData.timeStampDataPointStart];

    clear interpolatedData
    
    allTimeStampsNew = dataNewAll.timeStampDataPointStart;

    % unfortunately due to rounding errors, we need to remove the
    % repetition timestamps manually by comparing the differences
    allTimeStampsOldwithoutReps = zeros(height(allTimeStampsNew),1);
    matchingNew2OldTS = zeros(height(allTimeStampsNew),1);
    for index = 1: height(allTimeStampsNew)
        helperList = allTimeStampsOld - allTimeStampsNew(index);
        isSame = helperList <0.001 & helperList >= 0;
        
        if(sum(isSame) == 1)
            
            allTimeStampsOldwithoutReps(index) = allTimeStampsOld(isSame);
            matchingNew2OldTS(index) = allTimeStampsNew(index);

        end

    end

    isZero = matchingNew2OldTS == 0;
    matchingNew2OldTS(isZero) = [];
    allTimeStampsOldwithoutReps(isZero) = [];
    
    
    file2 = strcat(datapathOld_gazes, num2str(currentPart),'_gazes_data_WB.mat');

    gazesData = load(file2);
    gazesData = gazesData.gazes_data;
    
    noData = strcmp([gazesData.hitObjectColliderName],{'noData'});

    gazesTS = [gazesData(not(noData)).timeStampDataPointStart];
    gazesDurations = [gazesData(not(noData)).clusterDuration];

    clear gazesData
    
    gazesWithoutReps = ismember(gazesTS,allTimeStampsOldwithoutReps);
    
    usedGazeTimeStamps = ismember(allTimeStampsOldwithoutReps,gazesTS);
    
    allTSOld_gazes = allTimeStampsOldwithoutReps(usedGazeTimeStamps);
    matchingNew2OldTS_gazes = matchingNew2OldTS(usedGazeTimeStamps);

    gazesTimeStampOld = gazesTS(gazesWithoutReps);

    % calculate the timestamps of the valid gazes in the new data

    isFix = ~isnan(dataNewAll.isFix);
    isClean = strcmp(dataNewAll.cleanData, {'True'});
    isNotBlink = strcmp(dataNewAll.isBlink, {'False'});


    validGazes = isFix & isClean & isNotBlink;

    gazesTimeStampNew = dataNewAll.timeStampDataPointStart(validGazes);


    % now compare the timestamps

    % unionGazes = union(gazesTimeStampNew, gazesTimeStampOld);
    % 
    % unionGazesNum = length(unionGazes);
    % 
    % intersectGazes = intersect(gazesTimeStampOld,gazesTimeStampNew);
    % 
    % diffGazes = setdiff(gazesTimeStampOld, gazesTimeStampNew);

    unionGazes = union(gazesTimeStampNew, matchingNew2OldTS_gazes);

    unionGazesNum = length(unionGazes);

    intersectGazes = intersect(matchingNew2OldTS_gazes,gazesTimeStampNew);

    diffGazes = setdiff(matchingNew2OldTS_gazes, gazesTimeStampNew);

    oldAlsoNew = ismember(matchingNew2OldTS_gazes, gazesTimeStampNew);
    newAlsoOld = ismember(gazesTimeStampNew,matchingNew2OldTS_gazes);

    overviewSimiliarityGazes.participant(indexPart) = currentPart;
    overviewSimiliarityGazes.numGazesOld(indexPart) = length(gazesTimeStampOld);
    overviewSimiliarityGazes.numGazesNew(indexPart) = length(gazesTimeStampNew);
    overviewSimiliarityGazes.durationsGazesOld(indexPart) = (sum(gazesDurations)/1000)/60;
    overviewSimiliarityGazes.durationsGazesNew(indexPart) = sum(dataNewAll.timeDiff(validGazes))/60;
    overviewSimiliarityGazes.numUnionGazes(indexPart) = unionGazesNum;
    overviewSimiliarityGazes.numIntersectGazes(indexPart) = length(intersectGazes);
    overviewSimiliarityGazes.perIntersectGazes(indexPart) = length(intersectGazes)/ unionGazesNum;
    overviewSimiliarityGazes.numDiffGazes(indexPart) = length(diffGazes);
    overviewSimiliarityGazes.perDiffGazes(indexPart) = length(diffGazes)/ unionGazesNum;

    overviewSimiliarityGazes.amountOldGazesAlsoNew(indexPart) = sum(oldAlsoNew);
    overviewSimiliarityGazes.perOldGazesAlsoNew(indexPart) = sum(oldAlsoNew)/ length(oldAlsoNew);
    overviewSimiliarityGazes.amountNewGazesAlsoOld(indexPart) = sum(newAlsoOld);
    overviewSimiliarityGazes.perNewGazesAlsoOld(indexPart) = sum(newAlsoOld)/ length(newAlsoOld);



toc
end

writetable(overviewSimiliarityGazes, [savepath 'overviewSimiliarityGazes.csv']);




