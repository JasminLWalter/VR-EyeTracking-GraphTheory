%% --------------------- step2_resampling.m------------------------

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
savepath = 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step2_resampling\';

cd 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step1_dupl_clean_smooth\'

% Participant list of all participants that participated 5 sessions x 30 min 
% in Westbrook city

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004};

% to avoid weird edge effects during the resampling at the start and end of
% the file (the function assums 0s there), we duplicate the start and end
% values of the respective variable and therefore add a costum padding to
% the data. Define the size of the data points for the padding here

paddingSize = 10; 
desiredSamplingRate = 90;
%% --------------------------------------------------------------------------

% columns with continous data that will be resampled and interpolated

columns2rs = {
    'eyeOpennessLeft'	
    'eyeOpennessRight'	
    'pupilDiameterMillimetersLeft'	
    'pupilDiameterMillimetersRight'	
    'eyePositionCombinedWorld_x'	
    'eyePositionCombinedWorld_y'	
    'eyePositionCombinedWorld_z'	
    'eyeDirectionCombinedWorld_x'	
    'eyeDirectionCombinedWorld_y'	
    'eyeDirectionCombinedWorld_z'	
    'eyeDirectionCombinedLocal_x'	
    'eyeDirectionCombinedLocal_y'	
    'eyeDirectionCombinedLocal_z'	
    'eyePositionLeftWorld_x'	
    'eyePositionLeftWorld_y'	
    'eyePositionLeftWorld_z'	
    'eyeDirectionLeftWorld_x'	
    'eyeDirectionLeftWorld_y'	
    'eyeDirectionLeftWorld_z'	
    'eyeDirectionLeftLocal_x'	
    'eyeDirectionLeftLocal_y'	
    'eyeDirectionLeftLocal_z'	
    'eyePositionRightWorld_x'	
    'eyePositionRightWorld_y'	
    'eyePositionRightWorld_z'	
    'eyeDirectionRightWorld_x'	
    'eyeDirectionRightWorld_y'	
    'eyeDirectionRightWorld_z'	
    'eyeDirectionRightLocal_x'	
    'eyeDirectionRightLocal_y'	
    'eyeDirectionRightLocal_z'	
    'hmdPosition_x'	
    'hmdPosition_y'	
    'hmdPosition_z'	
    'hmdDirectionForward_x'	
    'hmdDirectionForward_y'	
    'hmdDirectionForward_z'	
    'hmdDirectionRight_x'	
    'hmdDirectionRight_y'	
    'hmdDirectionRight_z'	
    'hmdRotation_x'	
    'hmdRotation_y'	
    'hmdRotation_z'	
    'hmdDirectionUp_x'	
    'hmdDirectionUp_y'	
    'hmdDirectionUp_z'	
    'handLeftPosition_x'	
    'handLeftPosition_y'	
    'handLeftPosition_z'	
    'handRightPosition_x'	
    'handRightPosition_y'	
    'handRightPosition_z'	
    'handRightRotation_x'	
    'handRightRotation_y'	
    'handRightRotation_z'	
    'handRightDirectionForward_x'	
    'handRightDirectionForward_y'	
    'handRightDirectionForward_z'	
    'handRightDirectionRight_x'	
    'handRightDirectionRight_y'	
    'handRightDirectionRight_z'	
    'handRightDirectionUp_x'	
    'handRightDirectionUp_y'	
    'handRightDirectionUp_z'	
    'playerBodyPosition_x'	
    'playerBodyPosition_y'	
    'playerBodyPosition_z'	
    'bodyTrackerPosition_x'	
    'bodyTrackerPosition_y'	
    'bodyTrackerPosition_z'	
    'bodyTrackerRotation_x'	
    'bodyTrackerRotation_y'	
    'bodyTrackerRotation_z'	
    'processedCollider_hitPointOnObject_x'	
    'processedCollider_hitPointOnObject_y'	
    'processedCollider_hitPointOnObject_z'	
    'processedCollider_NH_hitPointOnObject_x'	
    'processedCollider_NH_hitPointOnObject_y'	
    'processedCollider_NH_hitPointOnObject_z'	
    };

% all other columns, that will be matched with the closest matching row in
% the new data (closest timestamp match)

otherColumns = {
    'timeStampDataPointStart'
    'timeStampDataPointEnd'	
    'timeStampGetVerboseData'
    'leftGazeValidityBitmask'	
    'rightGazeValidityBitmask'	
    'combinedGazeValidityBitmask'
    'hitObjectColliderName_1'	
    'ordinalOfHit_1'	
    'hitPointOnObject_x_1'	
    'hitPointOnObject_y_1'	
    'hitPointOnObject_z_1'	
    'hitObjectColliderBoundsCenter_x_1'	
    'hitObjectColliderBoundsCenter_y_1'	
    'hitObjectColliderBoundsCenter_z_1'	
    'hitObjectColliderName_2'	
    'ordinalOfHit_2'	
    'hitPointOnObject_x_2'	
    'hitPointOnObject_y_2'	
    'hitPointOnObject_z_2'	
    'hitObjectColliderBoundsCenter_x_2'	
    'hitObjectColliderBoundsCenter_y_2'	
    'hitObjectColliderBoundsCenter_z_2'	
    'DataRow'	
    'hitObjectColliderisGraffiti_1'	
    'hitObjectColliderisGraffiti_2'	
    'processedCollider_name'
    'processedCollider_hitObjectColliderBoundsCenter_x'	
    'processedCollider_hitObjectColliderBoundsCenter_y'	
    'processedCollider_hitObjectColliderBoundsCenter_z'	
    'replacedRows'	
    'processedColliderIsNH'	
    'processedCollider_NH_name'	
    'processedCollider_NH_hitObjectColliderBoundsCenter_x'	
    'processedCollider_NH_hitObjectColliderBoundsCenter_y'	
    'processedCollider_NH_hitObjectColliderBoundsCenter_z'	
    'replacedRows_NH'	
    'processedCollider_NH_IsNH'	
    'timeStampDataPointStart_converted'	
    'cleanData'	
    'isBlink'	
    'original_processedCollider_hitPointOnObject_x'	
    'original_processedCollider_hitPointOnObject_y'	
    'original_processedCollider_hitPointOnObject_z'	
    'original_processedCollider_NH_hitPointOnObject_x'	
    'original_processedCollider_NH_hitPointOnObject_y'	
    'original_processedCollider_NH_hitPointOnObject_z'	
    'removedData'	
    'interpolated'	
    'interpolatedHitPoint'
    };


%% columns that should not be interpolated (too much missing data)
columnsEyeData = {
    'eyeOpennessLeft'	
    'eyeOpennessRight'	
    'pupilDiameterMillimetersLeft'	
    'pupilDiameterMillimetersRight'	
    'eyePositionCombinedWorld_x'	
    'eyePositionCombinedWorld_y'	
    'eyePositionCombinedWorld_z'	
    'eyeDirectionCombinedWorld_x'	
    'eyeDirectionCombinedWorld_y'	
    'eyeDirectionCombinedWorld_z'	
    'eyeDirectionCombinedLocal_x'	
    'eyeDirectionCombinedLocal_y'	
    'eyeDirectionCombinedLocal_z'	
    'eyePositionLeftWorld_x'	
    'eyePositionLeftWorld_y'	
    'eyePositionLeftWorld_z'	
    'eyeDirectionLeftWorld_x'	
    'eyeDirectionLeftWorld_y'	
    'eyeDirectionLeftWorld_z'	
    'eyeDirectionLeftLocal_x'	
    'eyeDirectionLeftLocal_y'	
    'eyeDirectionLeftLocal_z'	
    'eyePositionRightWorld_x'	
    'eyePositionRightWorld_y'	
    'eyePositionRightWorld_z'	
    'eyeDirectionRightWorld_x'	
    'eyeDirectionRightWorld_y'	
    'eyeDirectionRightWorld_z'	
    'eyeDirectionRightLocal_x'	
    'eyeDirectionRightLocal_y'	
    'eyeDirectionRightLocal_z'
    'processedCollider_hitPointOnObject_x'	
    'processedCollider_hitPointOnObject_y'	
    'processedCollider_hitPointOnObject_z'	
    'processedCollider_NH_hitPointOnObject_x'	
    'processedCollider_NH_hitPointOnObject_y'	
    'processedCollider_NH_hitPointOnObject_z'	
    };




%% run resampling process for all files in the participant list

Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;


for indexPart = 1:Number
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));
    
    tic
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_dupl_clean_smooth.csv']);
        

        if isempty(dirSess)
            
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(dirSess)
                tic
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                data = readtable(dirSess(indexET).name);

                %% resample the continuous data

                % add padding to the timestamp used for the resampling 
                sR = 1/desiredSamplingRate;
                        
                startTS = data.timeStampDataPointStart_converted(1);
                endTS = data.timeStampDataPointStart_converted(end);
                paddingTSStart= nan(paddingSize,1);
                paddingTSEnd = nan(paddingSize,1);
                
                for i = 1:paddingSize
                    paddingTSStart(i,1) = startTS - (i*sR);
                    paddingTSEnd(i,1) =  endTS + (i*sR);
                
                end
                
                timeStamp = [paddingTSStart(:,1); data.timeStampDataPointStart_converted; paddingTSEnd(:,1)];
                
                dataRS = table;
                
                % for each continous data variable, do the resampling
                for indexRS = 1: height(columns2rs)
                
                    currentVar = columns2rs{indexRS};
                
                    % add the padding to the start and end of the variable
                    paddingStart = nan(paddingSize ,1);
                    paddingStart(:,1) = data.(currentVar)(1);   
                    
                    
                    paddingEnd = nan(paddingSize ,1);
                    paddingEnd(:,1) = data.(currentVar)(end);  
                
                  
                    
                    [resampledData, newTimestamp] = resample([paddingStart(:,1);data.(currentVar); paddingEnd(:,1)],timeStamp, desiredSamplingRate,3,3);
                
                    if (indexRS == 1)
                        dataRS.timeStampRS = newTimestamp;
                
                    end
                
                
                    if ~ (dataRS.timeStampRS == newTimestamp)
                        disp('BIG PROBLEM!!!!!!!!! DIFFERENT TIMESTAMPS!!!!!!!!!')
                    end    
                
                    dataRS.(currentVar) = resampledData;  
                
                end
                
                % remove padding - find closest matching new timestamp to start and end TS
                
                % Calculate the absolute differences between target and list timestamps
                differencesStart = abs(dataRS.timeStampRS - startTS);
                
                % Find the index of the minimum difference
                [minValS, minIndexS] = min(differencesStart);
                
                % for some cleaner data - remove rounding error to 0 (start only)
                if(minValS)< 0.000001
                    dataRS.timeStampRS(minIndexS) = 0;
                end
                
                % remove all data before start of data file
                % when removing the data - be inclusive, leave the closest timestamp within
                % the data
                dataRS(1:(minIndexS-1),:) = [];
                
                
                % do the same for the end values
                differencesEnd = abs(dataRS.timeStampRS - endTS);
                
                % Find the index of the minimum difference
                [~, minIndexE] = min(differencesEnd);
                
                % when removing the data - be inclusive, leave the closest timestamp within
                % the data
                dataRS((minIndexE+1):end,:) = [];
                
                
                % now add the other data rows by matching the data to the closest new timestamp
                
                % 
                % for indexOldTS = 1:length(data.timeStampDataPointStart_converted)
                % 
                %     currentTS = data.timeStampDataPointStart_converted(indexOldTS);
                % 
                %     differencesTS = abs(dataRS.timeStampRS - currentTS);
                % 
                %     % Find the index of the minimum difference
                %     [~, minIndexTS] = min(differencesTS);
                % 
                %     % now go through all remaining vars and add them to the data
                % 
                %     for indexCols = 1: height(otherColumns)
                % 
                %         currentCol = otherColumns{indexCols};
                % 
                %         % if it is the first time - fill all vars with NaNs
                %         if(indexOldTS == 1 && ~iscell(data.(currentCol)))
                % 
                %             dataRS.(currentCol) = nan(height(dataRS),1);
                % 
                %         end
                % 
                %         dataRS.(currentCol)(minIndexTS) = data.(currentCol)(indexCols);
                % 
                %     end
                % 
                % end
                
                
                %% try optimization
                % Pre-allocate NaNs for numeric data and cell arrays for cell data
                for indexCols = 1:height(otherColumns)
                    currentCol = otherColumns{indexCols};
                    if isnumeric(data.(currentCol))
                        dataRS.(currentCol) = nan(height(dataRS), 1);
                    else
                        dataRS.(currentCol) = cell(height(dataRS), 1);
                        % dataRS.(currentCol)(:) = {NaN}; % Assuming NaN is a suitable placeholder for cell data
                        dataRS.(currentCol)(:) = {[]}; % Use empty strings instead of NaN
                    end
                end
                
                % Find the closest timestamps in one go using knnsearch
                indices = knnsearch(dataRS.timeStampRS, data.timeStampDataPointStart_converted);
                
                % Now assign the data using the matched indices
                for indexCols = 1:height(otherColumns)
                    currentCol = otherColumns{indexCols};
                    dataRS.(currentCol)(indices) = data.(currentCol); % Direct assignment for numeric data
                
                end
                
                
                
                % final step, reorder the columns to the desired order
                % here, the desired order is the original order plus the new timestampRS
                % column at the very start of data
                
                desiredColumnsOrder = {'timeStampRS' 'timeStampDataPointStart_converted' 'timeStampDataPointStart'	'timeStampDataPointEnd'	'timeStampGetVerboseData'	'eyeOpennessLeft'	'eyeOpennessRight'	'pupilDiameterMillimetersLeft'	'pupilDiameterMillimetersRight'	'leftGazeValidityBitmask'	'rightGazeValidityBitmask'	'combinedGazeValidityBitmask'	'eyePositionCombinedWorld_x'	'eyePositionCombinedWorld_y'	'eyePositionCombinedWorld_z'	'eyeDirectionCombinedWorld_x'	'eyeDirectionCombinedWorld_y'	'eyeDirectionCombinedWorld_z'	'eyeDirectionCombinedLocal_x'	'eyeDirectionCombinedLocal_y'	'eyeDirectionCombinedLocal_z'	'eyePositionLeftWorld_x'	'eyePositionLeftWorld_y'	'eyePositionLeftWorld_z'	'eyeDirectionLeftWorld_x'	'eyeDirectionLeftWorld_y'	'eyeDirectionLeftWorld_z'	'eyeDirectionLeftLocal_x'	'eyeDirectionLeftLocal_y'	'eyeDirectionLeftLocal_z'	'eyePositionRightWorld_x'	'eyePositionRightWorld_y'	'eyePositionRightWorld_z'	'eyeDirectionRightWorld_x'	'eyeDirectionRightWorld_y'	'eyeDirectionRightWorld_z'	'eyeDirectionRightLocal_x'	'eyeDirectionRightLocal_y'	'eyeDirectionRightLocal_z'	'hmdPosition_x'	'hmdPosition_y'	'hmdPosition_z'	'hmdDirectionForward_x'	'hmdDirectionForward_y'	'hmdDirectionForward_z'	'hmdDirectionRight_x'	'hmdDirectionRight_y'	'hmdDirectionRight_z'	'hmdRotation_x'	'hmdRotation_y'	'hmdRotation_z'	'hmdDirectionUp_x'	'hmdDirectionUp_y'	'hmdDirectionUp_z'	'handLeftPosition_x'	'handLeftPosition_y'	'handLeftPosition_z'	'handRightPosition_x'	'handRightPosition_y'	'handRightPosition_z'	'handRightRotation_x'	'handRightRotation_y'	'handRightRotation_z'	'handRightDirectionForward_x'	'handRightDirectionForward_y'	'handRightDirectionForward_z'	'handRightDirectionRight_x'	'handRightDirectionRight_y'	'handRightDirectionRight_z'	'handRightDirectionUp_x'	'handRightDirectionUp_y'	'handRightDirectionUp_z'	'playerBodyPosition_x'	'playerBodyPosition_y'	'playerBodyPosition_z'	'bodyTrackerPosition_x'	'bodyTrackerPosition_y'	'bodyTrackerPosition_z'	'bodyTrackerRotation_x'	'bodyTrackerRotation_y'	'bodyTrackerRotation_z'	'hitObjectColliderName_1'	'ordinalOfHit_1'	'hitPointOnObject_x_1'	'hitPointOnObject_y_1'	'hitPointOnObject_z_1'	'hitObjectColliderBoundsCenter_x_1'	'hitObjectColliderBoundsCenter_y_1'	'hitObjectColliderBoundsCenter_z_1'	'hitObjectColliderName_2'	'ordinalOfHit_2'	'hitPointOnObject_x_2'	'hitPointOnObject_y_2'	'hitPointOnObject_z_2'	'hitObjectColliderBoundsCenter_x_2'	'hitObjectColliderBoundsCenter_y_2'	'hitObjectColliderBoundsCenter_z_2'	'DataRow'	'hitObjectColliderisGraffiti_1'	'hitObjectColliderisGraffiti_2'	'processedCollider_name'	'processedCollider_hitPointOnObject_x'	'processedCollider_hitPointOnObject_y'	'processedCollider_hitPointOnObject_z'	'processedCollider_hitObjectColliderBoundsCenter_x'	'processedCollider_hitObjectColliderBoundsCenter_y'	'processedCollider_hitObjectColliderBoundsCenter_z'	'replacedRows'	'processedColliderIsNH'	'processedCollider_NH_name'	'processedCollider_NH_hitPointOnObject_x'	'processedCollider_NH_hitPointOnObject_y'	'processedCollider_NH_hitPointOnObject_z'	'processedCollider_NH_hitObjectColliderBoundsCenter_x'	'processedCollider_NH_hitObjectColliderBoundsCenter_y'	'processedCollider_NH_hitObjectColliderBoundsCenter_z'	'replacedRows_NH'	'processedCollider_NH_IsNH'	'cleanData'	'isBlink'	'original_processedCollider_hitPointOnObject_x'	'original_processedCollider_hitPointOnObject_y'	'original_processedCollider_hitPointOnObject_z'	'original_processedCollider_NH_hitPointOnObject_x'	'original_processedCollider_NH_hitPointOnObject_y'	'original_processedCollider_NH_hitPointOnObject_z'	'removedData'	'interpolated'	'interpolatedHitPoint'};
                
                dataRS = dataRS(:, desiredColumnsOrder);


                %% now go through all the data segments 
                % and remove the interpolated data that should not have
                % been interpolated (missing data cluster > 250ms)

                lastRemD = 'False';
                lastInterp = 'False';
                
                for index2 = 1: height(dataRS)

                    if isempty(dataRS.removedData{index2})
                        dataRS.removedData(index2) = {lastRemD};
                        dataRS.interpolated(index2) = {lastInterp};

                    else
                        if ~(strcmp(lastRemD, dataRS.removedData{index2}) & strcmp(lastInterp, dataRS.interpolated{index2})) 

                            lastRemD = dataRS.removedData{index2};
                            lastInterp = dataRS.interpolated{index2};
                        end
                    end
                end
                
                interp2big = strcmp(dataRS.removedData,'True') & strcmp(dataRS.interpolated, 'False');

                % only remove the eye data columns
                for index3 = 1:length(columnsEyeData)

                    currentC = columnsEyeData{index3};
                    dataRS.(currentC)(interp2big) = NaN;

                end

                writetable(dataRS, [savepath num2str(currentPart) '_Session_' num2str(indexSess) '_ET_' num2str(indexET) '_data_resampled.csv']);

        
            end
        end
    end
end






