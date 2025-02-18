%% ------------------ comparison_old_new_gazeData_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 
clear all;
disp(datetime('now'))

%% adjust the following variables: savepath, current folder and participant list!-----------

savepath = 'D:\Jasmin\SpaReControlData\analysis2023\differences_old_2023_graphs\overviews\';


oldDataPath =  'D:\Jasmin\SpaReControlData\analysis2023\differences_old_2023_graphs\gaze_noise_prep\';
newDataPath =  'D:\Jasmin\SpaReControlData\pre-processing_2023\velocity_based\step3_gazeProcessing\';

colliderList = readtable('D:\Jasmin\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\building_collider_list.csv');
uniqueBuildingNames = unique(colliderList.target_collider_name);

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%----------------------------------------------------------------------------

Number = length(PartList);

overview_noDataCluster = table;
overview_gazesCluster = table;
overview_saccadeCluster = table;

overview_noDataCluster.Participants = PartList';
overview_gazesCluster.Participants = PartList';
overview_saccadeCluster.Participants = PartList';


for ii = 1:Number
    disp(ii)
    currentPart = cell2mat(PartList(ii));
    tic
    
    % load old data
    fileOld = strcat(oldDataPath, num2str(currentPart), '_data_gazeInfo_WB.mat');

    fullData = load(fileOld);
    fullData = fullData.interpolatedData;

    % Fields to keep
    fieldsToKeep = {'timeStampDataPointStart', 'clusterDuration', 'hitObjectColliderName', 'isGaze'};
    
    % Efficiently extract only selected fields for all elements

    oldData = rmfield(fullData, setdiff(fieldnames(fullData), fieldsToKeep));
    % oldData = struct2table(oldData);
    clear fullData;


    oldStartTS = oldData(1).timeStampDataPointStart(1);


    dirSess = dir([newDataPath, num2str(currentPart) '_Session_*_data_processed_gazes.csv']);
    fileNames = {dirSess.name}';
    fileNames_sorted = sortrows(fileNames, 'ascend');

    newFileIndex = 1;

    newData = readtable(strcat(newDataPath, fileNames_sorted{newFileIndex}));

    uniqueBuildingNames = unique(colliderList.target_collider_name);
    
    isInColliderList = false(height(newData),1);
    
    for indexNH = 1: length(uniqueBuildingNames)
        
        currentB = uniqueBuildingNames(indexNH);
        locBuilding1 = strcmp(currentB, newData.namesNH);
        
        isInColliderList = isInColliderList | locBuilding1;
        
    end

    newData.isNH = ~isInColliderList;
    events = newData.events;
     % Find event start and end indices
    saccade_start = find(events == 1);
    saccade_end = find(events == -1);
    
    fixation_start = find(events == 2);
    fixation_end = find(events == -2);
    
    invalid_start = find(events == 3);
    invalid_end = find(events == -3);

    no4_start = find(events == 4);
    no4_end = find(events == -4);

    if ~((length(saccade_start)==length(saccade_end)) | ...
            (length(fixation_start)==length(fixation_end))|...
            (length(invalid_start)==length(invalid_end)))
         % Generate logical masks for events
        saccade_mask = arrayfun(@(s, e) (s:e), saccade_start, saccade_end, 'UniformOutput', false);
        saccade_mask = horzcat(saccade_mask{:});
        
        fixation_mask = arrayfun(@(s, e) (s:e), fixation_start, fixation_end, 'UniformOutput', false);
        fixation_mask = horzcat(fixation_mask{:});
        
        invalid_mask = arrayfun(@(s, e) (s:e), invalid_start, invalid_end, 'UniformOutput', false);
        invalid_mask = horzcat(invalid_mask{:});
    
        if(length(no4_start) == length(no4_end))
            event4_mask = arrayfun(@(s, e) (s:e), no4_start, no4_end, 'UniformOutput', false);
            event4_mask = horzcat(event4_mask{:});
        else
            event4_mask = (1);
        end
        
        % Assign event categories
        newData.eventCategory = zeros(size(events));
        newData.eventCategory(saccade_mask) = 1;
        newData.eventCategory(fixation_mask) = 2;
        newData.eventCategory(invalid_mask) = 3;
        newData.eventCategory(event4_mask) = 4;

    else

        currentEvent = newData.events(1);
        newData.eventCategory(1) =  currentEvent;

        for indexND = 2: height(newData)
            if currentEvent ~= newData.events(indexND) 
    
                if ~((newData.events(indexND) == currentEvent*(-1)) | isnan(newData.events(indexND))) 
                    currentEvent = newData.events(indexND);                
                end
            end
            newData.eventCategory(indexND) = currentEvent;
            
        end 
    end
       
    isFirstCluster_newD = true;

    

    %% go through all clusters and analyse their counter rows
    for index = 1:length(oldData)-1
        

        currentCluster = oldData(index);

        oldData(index).eventBoundaryDifference_start = 0;
        oldData(index).eventBoundaryDifference_end = 0;
    
        oldData(index).gazeStart = false;
        oldData(index).gazeStart_NH = false;
        oldData(index).gazeStart_sameHitObject = false;
        
        oldData(index).gazeEnd = false;
        oldData(index).gazeEnd_NH = false;
        oldData(index).gazeEnd_sameHitObject = false;
    
        oldData(index).eventCounter = 0;
        oldData(index).eventList = {0};
        oldData(index).eventDurations =  {0};
    
        oldData(index).gazeCounter = 0;
        oldData(index).gazeHitPointNames = {'NaN'};
        oldData(index).gazeDurations = 0;
        oldData(index).gazeDurations_per = 0;
    
        oldData(index).numUniqueGazeBuildings = 0;
        oldData(index).uniqueBuildingNamesOfGazes ={'NaN'};
    
        oldData(index).num_sameGazeHitPoint = 0;
        oldData(index).num_sameGazeHitPoint_per = 0;
        
        oldData(index).sameGazeHitPoint_Duration = 0;
        oldData(index).sameGazeHitPoint_Duration_old = 0;


        oldData(index).sameGazeHitPoint_Duration_per = 0;
        oldData(index).sameGazeHitPoint_Duration_per_old = 0;



        %%
        if(strcmp(currentCluster.hitObjectColliderName, 'newSession')) 
            toc
            disp(datetime('now'))
            
            oldStartTS = oldData(index+1).timeStampDataPointStart(1);

            newFileIndex = newFileIndex +1;
            disp(['load new file ' fileNames_sorted{newFileIndex}])
            newData = readtable(strcat(newDataPath, fileNames_sorted{newFileIndex}));

            
    
            isInColliderList = false(height(newData),1);
            
            for indexNH = 1: length(uniqueBuildingNames)
                
                currentB = uniqueBuildingNames(indexNH);
                locBuilding1 = strcmp(currentB, newData.namesNH);
                
                isInColliderList = isInColliderList | locBuilding1;
                
            end
        
            newData.isNH = ~isInColliderList;
            events = newData.events;

            % Find event start and end indices
            saccade_start = find(events == 1);
            saccade_end = find(events == -1);
            
            fixation_start = find(events == 2);
            fixation_end = find(events == -2);
            
            invalid_start = find(events == 3);
            invalid_end = find(events == -3);

            no4_start = find(events == 4);
            no4_end = find(events == -4);
            
            if ~((length(saccade_start)==length(saccade_end)) | ...
                (length(fixation_start)==length(fixation_end))|...
                (length(invalid_start)==length(invalid_end)))
                 % Generate logical masks for events
                saccade_mask = arrayfun(@(s, e) (s:e), saccade_start, saccade_end, 'UniformOutput', false);
                saccade_mask = horzcat(saccade_mask{:});
                
                fixation_mask = arrayfun(@(s, e) (s:e), fixation_start, fixation_end, 'UniformOutput', false);
                fixation_mask = horzcat(fixation_mask{:});
                
                invalid_mask = arrayfun(@(s, e) (s:e), invalid_start, invalid_end, 'UniformOutput', false);
                invalid_mask = horzcat(invalid_mask{:});
            
                if(length(no4_start) == length(no4_end))
                    event4_mask = arrayfun(@(s, e) (s:e), no4_start, no4_end, 'UniformOutput', false);
                    event4_mask = horzcat(event4_mask{:});
                else
                    event4_mask = (1);
                end
                
                % Assign event categories
                newData.eventCategory = zeros(size(events));
                newData.eventCategory(saccade_mask) = 1;
                newData.eventCategory(fixation_mask) = 2;
                newData.eventCategory(invalid_mask) = 3;
                newData.eventCategory(event4_mask) = 4;
    
            else
    
                currentEvent = newData.events(1);
                newData.eventCategory(1) =  currentEvent;
         
                for indexND = 2: height(newData)
                    if currentEvent ~= newData.events(indexND) 
            
                        if ~((newData.events(indexND) == currentEvent*(-1)) | isnan(newData.events(indexND))) 
                            currentEvent = newData.events(indexND);                
                        end
                    end
                    newData.eventCategory(indexND) = currentEvent;
                    
                end
            end
           
            isFirstCluster_newD = true;                      


            %% in case the new session is not starting, do the main code
        else

            oldTS = [currentCluster.timeStampDataPointStart];
            oldTS = oldTS - oldStartTS;

            % oldTS_u = unique(oldTS);


            % Step 1: Find nearest matches
            [idx, dist] = knnsearch(newData.timeStampRS, oldTS');

            % now check the event boundaries
            
            if (isFirstCluster_newD)
                startIdx = 1; 
                eventChangeIdx_start = 1;
                isFirstCluster_newD = false;

            else
                startIdx = startIdx_nextCluster;
                eventChangeIdx_start = eventChangeIdx_start_nextCl;
            end

            % determine end index
            
            endIdx = max(idx);
            eventChangeIdx_end = endIdx;

            % only do this, if the current matching sample index are more
            % than 1 row
            if (endIdx-startIdx) > 2
                % if the event boundary is not at the current end index
                if strcmp([oldData(index+1).hitObjectColliderName],'newSession')
                        endIdx = height(newData);
                        eventChangeIdx_end = height(newData);
                elseif ~ (newData.eventCategory(endIdx) ~= newData.eventCategory(endIdx+1))
    
                    if endIdx+2 <= height(newData) && (newData.eventCategory(endIdx+1) ~= newData.eventCategory(endIdx+2))
                        endIdx = endIdx + 1;
                        eventChangeIdx_end = endIdx;
    
                    elseif (newData.eventCategory(endIdx) ~= newData.eventCategory(endIdx-1))
                        endIdx = endIdx - 1;
                        eventChangeIdx_end = endIdx;
    
                    % handle last cluster before a new session start
    
                    else
    
                        minusEndIdx = endIdx; 
                        plusEndIdx = endIdx;
                        
                        for check = endIdx :-1:startIdx
                            if (newData.eventCategory(endIdx) ~= newData.eventCategory(check))
                                minusEndIdx = check;
                                break;
                            end
                 
                        end
                                         
                        endTSnextCluster= fix(oldData(index+1).clusterDuration *90);
                        if (endIdx + endTSnextCluster <= height(newData))
                            boundary = endIdx + endTSnextCluster;
                        else
                            boundary = height(newData);
                        end
    
                        for check2 = endIdx : boundary
                            if (newData.eventCategory(endIdx) ~= newData.eventCategory(check2))
                                plusEndIdx = check2;
                                break;
                            end
                 
                        end
    
                        if minusEndIdx <= plusEndIdx
    
                            eventChangeIdx_end = minusEndIdx;
    
                        else
    
                            eventChangeIdx_end = plusEndIdx;
                        end
    
                    end
    
                    % if new End Idx is close enough to max(indx), use it as
                    % new end idx 
    
                end

            end

            % save end Index as new start index for the next cluster
            startIdx_nextCluster = endIdx+1;
            eventChangeIdx_start_nextCl = eventChangeIdx_end+1;

            % save event boundary information

            oldData(index).eventBoundaryDifference_start = newData.timeStampRS(eventChangeIdx_start) - newData.timeStampRS(startIdx);
            oldData(index).eventBoundaryDifference_end = newData.timeStampRS(eventChangeIdx_end) - newData.timeStampRS(endIdx);
 


            % identify matching segemtn
            currentNewData = newData(startIdx:endIdx,:);
            currentNewData_eventBased = newData(eventChangeIdx_start:eventChangeIdx_end,:);

            %% analysis with original timestamp matching
            eventL = [];
            eventDurations = [];
            gaze_hitPointName = {};
            
            for indexC = 1:height(currentNewData)
                if(indexC == 1)
                    eventCounter = 1;
                    lastEvent = currentNewData.eventCategory(1);
                    lastEventIdx = 1;

                    eventL = [eventL, lastEvent];
                    
                    % check whether first event is a gaze event
                    if(lastEvent == 2)
                        gazeCounter = 1;
                        oldData(index).gazeStart = true;
                        oldData(index).gazeStart_NH = currentNewData.isNH(1);
                        if currentNewData.isNH(1)
                           oldData(index).gazeStart_sameHitObject = strcmp('NH', currentCluster.hitObjectColliderName);
                           gaze_hitPointName = [gaze_hitPointName, {'NH'}];
                        else
                            oldData(index).gazeStart_sameHitObject= strcmp(currentNewData.namesNH(1), currentCluster.hitObjectColliderName);
                            gaze_hitPointName = [gaze_hitPointName, currentNewData.namesNH(indexC)];
                        end

                    else
                        gazeCounter = 0;
                        oldData(index).gazeStart = false;
                    end

                else
                    % if it is not the first row
                    % check if event changes
                    if ~(currentNewData.eventCategory(indexC) == lastEvent)| indexC == height(currentNewData)
                        eventCounter = eventCounter +1;

                        eventL = [eventL, currentNewData.eventCategory(indexC)];
                        eventDurations = [eventDurations, currentNewData.timeStampRS(indexC)-currentNewData.timeStampRS(lastEventIdx)];
                        
                        % check whether first event is a gaze event
                        if(currentNewData.eventCategory(indexC) == 2)
                            gazeCounter = gazeCounter+1;

                            if currentNewData.isNH(indexC)
                                gaze_hitPointName = [gaze_hitPointName, {'NH'}];
                            else
                                gaze_hitPointName = [gaze_hitPointName, currentNewData.namesNH(indexC)];
                            end
                        end

                        lastEvent = currentNewData.eventCategory(indexC);
                        lastEventIdx = indexC;

                        % if this is currently the last 
                        if indexC == height(currentNewData)
                             if(lastEvent == 2)
                                oldData(index).gazeEnd = true;
                                oldData(index).gazeEnd_NH = currentNewData.isNH(indexC);
                                
                                if currentNewData.isNH(indexC)
                                    oldData(index).gazeEnd_sameHitObject = strcmp('NH', currentCluster.hitObjectColliderName);
                                else
                                    oldData(index).gazeEnd_sameHitObject = strcmp(currentNewData.namesNH(indexC), currentCluster.hitObjectColliderName);
                                end

                            else
                                oldData(index).gazeEnd = false;
                            end

                        end

                    end

                    % save analysis into old Data
                    oldData(index).eventCounter = eventCounter;
                    oldData(index).eventList= eventL;
                    oldData(index).eventDurations = eventDurations;
                    oldData(index).gazeCounter= gazeCounter;
                    oldData(index).gazeHitPointNames = gaze_hitPointName;

                    % check how many gazes on buildings it includes
                    uniqueNames = unique(gaze_hitPointName);
                    isNH = strcmp(uniqueNames, 'NH');
                    
                    buildingNames = uniqueNames(~isNH);

                    if(length(buildingNames) > 0)
                        oldData(index).numUniqueGazeBuildings = length(buildingNames);
                        oldData(index).uniqueBuildingNamesOfGazes= buildingNames;
                    else
                        oldData(index).numUniqueGazeBuildings = 0;
                    end

                    gazeSamples = currentNewData.eventCategory ==2;
                    oldData(index).gazeDurations = sum(gazeSamples)/90;
                    oldData(index).gazeDurations_per = (sum(gazeSamples)/90)/currentCluster.clusterDuration;

                    if currentCluster.isGaze

                        if strcmp(currentCluster.hitObjectColliderName , 'NH')
                            sameName = currentNewData.isNH;
                            sameNameOld = currentNewData.isNH;
                            numSameNameGazes = strcmp(gaze_hitPointName, 'NH');
                        else
                            sameName = strcmp(currentNewData.namesNH, currentCluster.hitObjectColliderName);
                            sameNameOld = strcmp(currentNewData.processedCollider_name, currentCluster.hitObjectColliderName);
                            numSameNameGazes = strcmp(gaze_hitPointName, currentCluster.hitObjectColliderName);
                        end

                        isGaze = currentNewData.eventCategory == 2;
                        oldData(index).num_sameGazeHitPoint = sum(numSameNameGazes);
                        oldData(index).num_sameGazeHitPoint_per = sum(numSameNameGazes)/sum(eventL == 2);

                        oldData(index).sameGazeHitPoint_Duration = sum(sameName & isGaze) /90;
                        oldData(index).sameGazeHitPoint_Duration_per = (sum(sameName & isGaze) /90)/ currentCluster.clusterDuration;
                       
                        oldData(index).sameGazeHitPoint_Duration_old = sum(sameNameOld & isGaze) /90;
                        oldData(index).sameGazeHitPoint_Duration_per_old = (sum(sameNameOld & isGaze) /90)/ currentCluster.clusterDuration;
                    end
                       
                    
                end

            end

           


          
            

            end
            




    end

    save([savepath num2str(currentPart) '_gazeData_comparison.mat'],'oldData');
    toc

end

