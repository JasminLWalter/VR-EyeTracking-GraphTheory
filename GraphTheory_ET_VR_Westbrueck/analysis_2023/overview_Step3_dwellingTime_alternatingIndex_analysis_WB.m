%% ------------------ dwellingTime_alternatingIndex_analysis_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 

savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\P2B_analysis\data_overviews\';

cd 'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step3_gazeProcessing\';


overviewTableP2BPrep2 = readtable('E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\P2B_analysis\data_overviews\overviewTable_P2B_Prep_stage1.csv');


lastPart = 0;
for index = 1:height(overviewTableP2BPrep2)
    
    currentPart = overviewTableP2BPrep2.SubjectID(index); 
   
    if not(currentPart == lastPart)
        toc
        tic
        %load new participant data
        disp([index, currentPart])
        

        gazesData = table;
    
        % loop over recording sessions (should be 5 for each participant)
        for indexSess = 1:5
            
            % get eye tracking sessions and loop over them (amount of ET files
            % can vary
            dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_processed_gazes.csv']);

            if isempty(dirSess)
                
                disp('missing session file !!!!!!!!!!!!')
                hMF = table;
                hMF.Participant = currentPart;
                hMF.Session = indexSess;
                missingFiles = [missingFiles; hMF];
            
            else
                %% Main part - runs if files exist!        
                % loop over ET sessions and check data            
                for indexET = 1:length(dirSess)
                    disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                    % read in the data
                    % data = readtable([num2str(1004) '_Session_1_ET_1_data_processed_gazes.csv']);
                    data = readtable(dirSess(indexET).name);
                    fixations = data.events == 2.0;
                    gazesTable = table;
                    gazesTable.name = data.namesNH(fixations);
                    gazesTable.length = data.length(fixations);
   
                    gazesData = [gazesData; gazesTable];
    
                end
            end
        end
            
        
    end
    
    %% calculate the alternating index for each task building pair
    houseA = overviewTableP2BPrep2.StartBuildingName(index);
    houseB = overviewTableP2BPrep2.TargetBuildingName(index);
    
    alternatingIndex = 0;
    start = true;
    b2a = false;
    a2b = false;
    
    for index2 = 1: height(gazesData)
        
        currentGaze = gazesData.name(index2);
        
        if start
            if(strcmp(currentGaze, houseA))
                a2b = true;
                start = false;
            elseif(strcmp(currentGaze, houseB))
                b2a = true;
                start = false;
            end
                 
        elseif(a2b)
            if(strcmp(currentGaze, houseB))
                alternatingIndex = alternatingIndex +1;
                a2b = false;
                b2a = true;
            end
        elseif(b2a)
            if(strcmp(currentGaze, houseA))
                alternatingIndex = alternatingIndex +1;
                b2a = false;
                a2b = true;
            end
            
        end
        
    end
    
    overviewTableP2BPrep2.AlternatingIndex(index) = alternatingIndex;
    
    %% add dwelling time
    
    startHouse = strcmp(gazesData.name, houseA);
    
    overviewTableP2BPrep2.StartBuildingDwellingTime(index) = sum([gazesData.length(startHouse)]);
    
    targetHouse = strcmp(gazesData.name, houseB);
    
    overviewTableP2BPrep2.TargetBuildingDwellingTime(index) = sum(gazesData.length(targetHouse));
    
    %% add distance between houses
    
    
    
    lastPart = currentPart;

    
end



% save overview
save([savepath 'overviewTable_P2B_Prep2.mat'],'overviewTableP2BPrep2');
writetable(overviewTableP2BPrep2, [savepath, 'overviewTable_P2B_Prep2.csv']);

disp('Data saved')











