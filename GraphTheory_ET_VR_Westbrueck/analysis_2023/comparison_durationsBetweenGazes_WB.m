%% ------------------ comparison_durationsBetweenGazes_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 
clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\durationsBetweenGazes\overviews\';


oldDataPath =  'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\gaze_noise_prep\';
newDataPath =  'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step3_gazeProcessing\';



% 20 participants with 90 min VR trainging less than 30% data loss
% PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
PartList = {1073 1074 1075 1077 1079 1080};

%----------------------------------------------------------------------------

Number = length(PartList);

overview_oldDataTimeStamps = [];
overview_newDataTimeStamps = [];


for ii = 1:Number
    tic
    disp(ii)
    currentPart = cell2mat(PartList(ii));
    
    % load old data
    fileOld = strcat(oldDataPath, num2str(currentPart), '_data_gazeInfo_WB.mat');

    fullData = load(fileOld);
    fullData = fullData.interpolatedData;

    lastGazeEnd = 0;
    currentGazeStart = 0;
    isFirstGaze = true;

    for index = 1:length(fullData)

        if strcmp(fullData(index).hitObjectColliderName, 'newSession')
            isFirstGaze = true;
        end

        if fullData(index).isGaze & ~strcmp(fullData(index).hitObjectColliderName, 'newSession')

            currentTS = [fullData(index).timeStampDataPointStart];
            if(isFirstGaze)
                lastGazeEnd = currentTS(end);
                isFirstGaze = false;

            else
            
                currentGazeStart = currentTS(1);
                gazeDistance = currentGazeStart - lastGazeEnd ;
                overview_oldDataTimeStamps = [overview_oldDataTimeStamps, gazeDistance];
    
                lastGazeEnd = currentTS(end);

            end

        end

    end

    save([savepath num2str(currentPart) '_oldData_durationsBetweenGazes.mat'],'overview_oldDataTimeStamps');
    clear fullData

toc

    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([newDataPath num2str(currentPart) '_Session_' num2str(indexSess) '*_data_processed_gazes.csv']);

        % sort the list to be sure
        fileNames = {dirSess.name}';
        fileNames_sorted = sortrows(fileNames, 'ascend');

        %% Main part - runs if files exist!        
        % loop over ET sessions and check data            
        for indexET = 1:length(fileNames_sorted)
            % disp(['Process file: ', fileNames_sorted{indexET}]);
            % read in the data
            % data = readtable([num2str(1004) '_Session_1_ET_1_data_correTS_mad_wobig.csv']);
            newData = readtable([newDataPath fileNames_sorted{indexET}]);

            

            lastGazeEnd = 0;
            currentGazeStart = 0;
            isFirstGaze = true;

            for indexN = 1:height(newData)
        
                if newData.events(indexN) == -2
                    lastGazeEnd = newData.timeStampRS(indexN);

                elseif newData.events(indexN) == 2
                    if(isFirstGaze)

                        isFirstGaze = false;
                    else

                        gazeDistance = newData.timeStampRS(indexN) - lastGazeEnd ;
                        overview_newDataTimeStamps = [overview_newDataTimeStamps, gazeDistance];
            
                        lastGazeEnd = newData.timeStampRS(indexN);
        

                    end

                end

                
            end


        end
    end

    save([savepath num2str(currentPart) '_newData_durationsBetweenGazes.mat'],'overview_newDataTimeStamps');

    clear newData

toc

end