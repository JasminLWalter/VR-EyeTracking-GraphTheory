%% ------------------ dwellingTime_alternatingIndex_analysis_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 

savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\gazes_vs_noise\';


overviewTableP2BPrep2 = readtable('F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\overviewTable_P2B_Prep_stage1.csv');


lastPart = 0;
for index = 1:height(overviewTableP2BPrep2)
    
    currentPart = overviewTableP2BPrep2.SubjectID(index);   
   
    if not(currentPart == lastPart)
        
        %load new participant data
        disp(currentPart)
        
        gazesData = load(strcat(num2str(currentPart),'_gazes_data_WB.mat'));
        gazesData = gazesData.gazes_data;
        
    end
    
    %% calculate the alternating index for each task building pair
    houseA = overviewTableP2BPrep2.StartBuildingName(index);
    houseB = overviewTableP2BPrep2.TargetBuildingName(index);
    
    alternatingIndex = 0;
    start = true;
    b2a = false;
    a2b = false;
    
    for index2 = 1: length(gazesData)
        
        currentGaze = gazesData(index2).hitObjectColliderName;
        
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
    
    startHouse = strcmp([gazesData.hitObjectColliderName], houseA);
    
    overviewTableP2BPrep2.StartBuildingDwellingTime(index) = sum([gazesData(startHouse).clusterDuration])/1000;
    
    targetHouse = strcmp([gazesData.hitObjectColliderName], houseB);
    
    overviewTableP2BPrep2.TargetBuildingDwellingTime(index) = sum([gazesData(targetHouse).clusterDuration]/1000);
    
    %% add distance between houses
    
    
    
    lastPart = currentPart;

    
end



% save overview
save([savepath 'overviewTable_P2B_Prep2.mat'],'overviewTableP2BPrep2');
writetable(overviewTableP2BPrep2, [savepath, 'overviewTable_P2B_Prep2.csv']);

disp('Data saved')











