%% ------------------baseline_gaze_comparision_individual_V3----------------------------------------
% script written by Jasmin Walter



clear all;

savepath = 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\baseline_gaze_comparision\';

% path desync data - baseline data
cd 'D:\Studium\NBP\Seahaven\90min_Data\Desynchronization\desync_gazes_vs_noise\';

% path real data

dataPath = 'D:\Studium\NBP\Seahaven\90min_Data\newRaycast_Data\gazes_vs_noise\';

% house list
listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};
nrHouses = height(coordinateList);
        

% participant list of 90 min VR - only with participants who have lost less than 30% of
% their data (after running script cleanParticipants_V2)
%PartList = {1909 3668 8466 2151 4502 7670 8258 3377 9364 6387 2179 4470 6971 5507 8834 5978 7399 9202 8551 1540 8041 3693 5696 3299 1582 6430 9176 5602 3856 7942 6594 4510 3949 3686 6543 7205 5582 9437 1155 8547 8261 3023 7021 9961 9017 2044 8195 4272 5346 8072 6398 3743 5253 9475 8954 8699 3593};

% 20 participants with 90 min VR trainging less than 30% data loss
% PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};
PartList = {21 22};

maxShiftNr = 59;


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
countAnalysedFile= 0;



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
       
    % load real data

    realGazes = load(strcat(dataPath, num2str(currentPart),'_gazes_data_V3.mat'));
    realGazes = realGazes.gazedObjects; 
    rSession1 = strcmp({realGazes.Session}, 'Session1');
    rSession2 = strcmp({realGazes.Session}, 'Session2');
    rSession3 = strcmp({realGazes.Session}, 'Session3');

    realGazes1 = realGazes(rSession1);
    realGazes2 = realGazes(rSession2);
    realGazes3 = realGazes(rSession3);
    
    % create overview
    houseTable = coordinateList(:,1);
    overviewComparision = table2struct(houseTable);
    
    for shiftIndex = 1:maxShiftNr
        
        currentShift = shiftIndex * 30;
        file = strcat(num2str(currentPart),'_',num2str(currentShift),'sec_shift_gazes_data_V3.mat');
        % check for missing files
        if exist(file)==0
            countMissingPart = countMissingPart+1;

            noFilePartList = [noFilePartList;currentPart];
            disp(strcat(file,' does not exist in folder'));
        %% main code   
        elseif exist(file)==2
            countAnalysedFile = countAnalysedFile +1;
            % load desync data - basline
            baseline = load(file);
            baseline = baseline.gazedObjects;
            
            bSession1 = strcmp({baseline.Session}, 'Session1');
            bSession2 = strcmp({baseline.Session}, 'Session2');
            bSession3 = strcmp({baseline.Session}, 'Session3');
            
            baseline1 = baseline(bSession1);
            baseline2 = baseline(bSession2);
            baseline3 = baseline(bSession3);
            
            % create overview for every house
            for houseIndex2 = 1:nrHouses
                
                currentHouse = coordinateList{houseIndex2, 1};
                % create list of all gazes on house
                allHouseGazes1_B = baseline1(strcmp({baseline1.Collider}, currentHouse));
                allHouseGazes1_R = realGazes1(strcmp({realGazes1.Collider}, currentHouse));
                
                % go through all gazes in list
                for gazeIndex = 1 : length(allHouseGazes1_B)
                    % for each gaze identify the start point in the
                    % baseline
                    startPoint_B = allHouseGazes1_B(gazeIndex).TimeStamp(1);
                    % now check which real gazes are in the respective 30
                    % minutes window
                    lowBoarder = startPoint_B - 15;
                    highBoarder = startPoint_B + 15;
                    for gazeIndex_R = 1: length(allHouseGazes1_R)
                        currentSP = allHouseGazes1_R(gazeIndex_R).TimeStamp(1);
                        if(currentSP > lowBoarder && currentSP < highBoarder)
                            % if the gaze start points falls into window,
                            % normalize the gaze and save it into overview
                            normalisedStartPoint = currentSP - startPoint_B;
                            
                            if(houseIndex2 ==1)
                                overviewComparision(houseIndex2).StartPoints = normalisedStartPoint;
                                overviewComparision(houseIndex2).GazeLengthSamples = allHouseGazes1_R(gazeIndex_R).Samples;
                        
                            else
                                overviewComparision(houseIndex2).StartPoints = [overviewComparision(houseIndex2).StartPoints, normalisedStartPoint];
                                overviewComparision(houseIndex2).GazeLengthSamples = [overviewComparision(houseIndex2).GazeLengthSamples, allHouseGazes1_R(gazeIndex_R).Samples];
                        
                            end
                        end
                        
                    end 
                    
                end
                
                % do the same for the session 2 data
                allHouseGazes2_B = baseline2(strcmp({baseline2.Collider}, currentHouse)); 
                allHouseGazes2_R = realGazes2(strcmp({realGazes2.Collider}, currentHouse));
                
                for gazeIndex = 1 : length(allHouseGazes2_B)
                    % for each gaze identify the start point in the
                    % baseline
                    startPoint_B = allHouseGazes2_B(gazeIndex).TimeStamp(1);
                    % now check which real gazes are in the respective 30
                    % minutes window
                    lowBoarder = startPoint_B - 15;
                    highBoarder = startPoint_B + 15;
                    for gazeIndex_R = 1: length(allHouseGazes2_R)
                        currentSP = allHouseGazes2_R(gazeIndex_R).TimeStamp(1);
                        if(currentSP > lowBoarder && currentSP < highBoarder)
                            normalisedStartPoint = currentSP - startPoint_B;
                            
                            overviewComparision(houseIndex2).StartPoints = [overviewComparision(houseIndex2).StartPoints, normalisedStartPoint];
                            overviewComparision(houseIndex2).GazeLengthSamples = [overviewComparision(houseIndex2).GazeLengthSamples, allHouseGazes2_R(gazeIndex_R).Samples];
                        end
                        
                    end 
                    
                end
                
                % and do the same for session 3
                allHouseGazes3_B = baseline3(strcmp({baseline3.Collider}, currentHouse));
                allHouseGazes3_R = realGazes3(strcmp({realGazes3.Collider}, currentHouse));

                for gazeIndex = 1 : length(allHouseGazes3_B)
                    % for each gaze identify the start point in the
                    % baseline
                    startPoint_B = allHouseGazes3_B(gazeIndex).TimeStamp(1);
                    % now check which real gazes are in the respective 30
                    % minutes window
                    lowBoarder = startPoint_B - 15;
                    highBoarder = startPoint_B + 15;
                    for gazeIndex_R = 1: length(allHouseGazes3_R)
                        currentSP = allHouseGazes3_R(gazeIndex_R).TimeStamp(1);
                        if(currentSP > lowBoarder && currentSP < highBoarder)
                            normalisedStartPoint = currentSP - startPoint_B;
                            overviewComparision(houseIndex2).StartPoints = [overviewComparision(houseIndex2).StartPoints, normalisedStartPoint];
                            overviewComparision(houseIndex2).GazeLengthSamples = [overviewComparision(houseIndex2).GazeLengthSamples, allHouseGazes3_R(gazeIndex_R).Samples];
                        end
                        
                    end 
                    
                end
 
                
            end


        else
            disp('something went really wrong with participant list');
        end
    end
    
    % save overview
    
    save([savepath num2str(currentPart),'_overview_comparision_baseline_gazes_V3.mat'],'overviewComparision');

end
disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countAnalysedFile), ' files analyzed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');


disp('done');