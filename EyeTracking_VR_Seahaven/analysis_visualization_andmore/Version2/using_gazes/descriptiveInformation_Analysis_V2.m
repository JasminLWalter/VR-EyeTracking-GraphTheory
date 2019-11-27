%% ------------------ descriptiveInformation_Analysis_V2 --------------
% written by Jasmin Walter

% analyses gazes on objects individually for all participants listed in PartList

clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


noFilePartList = [];
countMissingPart = 0;


%% analyse fixations
overviewGazes = array2table(zeros(length(PartList),9),'VariableNames',{'Participant','nr_all_gazes','combinedTime_allGazes','nr_gazes_on_house','combinedTime_gazes_on_houses','nr_gazes_on_NH','combinedTime_gazes_on_NH','nr_gazes_on_sky','combinedTime_gazes_on_sky'});
        

houseList= load('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\HouseList.mat');
houseList= houseList.houseList;

overview_nr_gazes_onHouses = table;
overview_nr_gazes_onHouses.Houses = houseList;

overview_summedupSamples_ofGazes_onHouses = table;
overview_summedupSamples_ofGazes_onHouses.Houses = houseList;


for ii = 1:length(PartList)
    currentPart = cell2mat(PartList(ii));
    
    file = strcat('gazes_data_',num2str(currentPart),'.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
                
        gazedObjectsRaw = load(file);
        gazedObjectsRaw = gazedObjectsRaw.gazedObjects;
        
        % remove noData rows:
        noData = strcmp(gazedObjectsRaw.House(:),'noData');
        
        gazedObjects = gazedObjectsRaw;
        gazedObjects(noData,:) = [];
        
        nr_of_Gazes = height(gazedObjects);
        
        noHouses = strcmp(gazedObjects.House(:),'NH');
        nhTable = gazedObjects(noHouses,:);
        nhNrGazes = height(nhTable);
        
        sky = strcmp(gazedObjects.House(:),'sky');
        skyTable = gazedObjects(sky,:);
        skyNrGazes = height(skyTable);
        
        house = not(noHouses | sky);
        houseTable = gazedObjects(house,:);
        houseNrGazes = height(houseTable);
        
    
        % update overview Fixations
        overviewGazes.Participant(ii) = currentPart;
        
        overviewGazes.nr_all_gazes(ii) = nr_of_Gazes;
        overviewGazes.combinedTime_allGazes(ii) = sum(gazedObjects.Samples);
        
        overviewGazes.nr_gazes_on_house(ii) = houseNrGazes;
        overviewGazes.combinedTime_gazes_on_houses(ii) = sum(houseTable.Samples);
        
        overviewGazes.nr_gazes_on_NH(ii) = nhNrGazes;
        overviewGazes.combinedTime_gazes_on_NH(ii) = sum(nhTable.Samples);
        
        overviewGazes.nr_gazes_on_sky(ii) = skyNrGazes;
        overviewGazes.combinedTime_gazes_on_sky(ii) = sum(skyTable.Samples);
        
        % update overview gazes on Houses
        
        NrGazes= array2table(zeros(213,1),'VariableNames',{strcat('Part_',num2str(currentPart))});
        combinedTime_Gazes= array2table(zeros(213,1),'VariableNames',{strcat('Part_',num2str(currentPart))});
       
        
        for index = 1: 213
            findHouse = strcmp(houseList(index),houseTable.House(:));
            numHouse = sum(findHouse);
            
            NrGazes{index,1} = numHouse;
            
            combinedTime_Gazes{index,1} = sum(houseTable.Samples(findHouse));
            
        end
        
        overview_nr_gazes_onHouses = [overview_nr_gazes_onHouses,NrGazes];
        overview_summedupSamples_ofGazes_onHouses = [overview_summedupSamples_ofGazes_onHouses,combinedTime_Gazes];
        
       
    else
        disp('something went really wrong with participant list');
    end

end

save([savepath 'overviewGazes.mat'],'overviewGazes');
writetable(overviewGazes,strcat(savepath,'overviewGazes_Summary.csv'));
        

save(strcat(savepath,'overview_nr_gazes_onHouses'),'overview_nr_gazes_onHouses');
writetable(overview_nr_gazes_onHouses,strcat(savepath,'overview_nr_gazes_onHouses.csv'));
        
save(strcat(savepath,'overview_summedupSamples_ofGazes_onHouses'),'overview_summedupSamples_ofGazes_onHouses');
writetable(overview_summedupSamples_ofGazes_onHouses,strcat(savepath,'overview_summedupSamples_ofGazes_onHouses.csv'));
        

% create summary
overviewGazes_Statistics = array2table(zeros(2,8),'VariableNames',{'avg_nr_allGazes','avg_allsummedupTime_ofGazes','avg_Nr_gazes_onHouses','avg_summedupTime_gazes_onHouses','avg_nr_gazes_on_NH','avg_summedupTime_gazes_onNH','avg_nr_gazes_on_sky','avg_summedupTime_gazes_onsky'});

overviewGazes_Statistics.avg_nr_allGazes(1) = mean(overviewGazes.nr_all_gazes);
overviewGazes_Statistics.avg_allsummedupTime_ofGazes(1) = mean(overviewGazes.combinedTime_allGazes);

overviewGazes_Statistics.avg_Nr_gazes_onHouses(1) = mean(overviewGazes.nr_gazes_on_house);
overviewGazes_Statistics.avg_summedupTime_gazes_onHouses(1) = mean(overviewGazes.combinedTime_gazes_on_houses);

overviewGazes_Statistics.avg_nr_gazes_on_NH(1) = mean(overviewGazes.nr_gazes_on_NH);
overviewGazes_Statistics.avg_summedupTime_gazes_onNH(1) = mean(overviewGazes.combinedTime_gazes_on_NH);

overviewGazes_Statistics.avg_nr_gazes_on_sky(1) = mean(overviewGazes.nr_gazes_on_sky);
overviewGazes_Statistics.avg_summedupTime_gazes_onsky(1) = mean(overviewGazes.combinedTime_gazes_on_sky);

% calculating percentage
overviewGazes_Statistics{2,3} = (overviewGazes_Statistics{1,3}*100) / overviewGazes_Statistics{1,1};
overviewGazes_Statistics{2,4} =(overviewGazes_Statistics{1,4}*100) / overviewGazes_Statistics{1,2};

overviewGazes_Statistics{2,5} = (overviewGazes_Statistics{1,5}*100) / overviewGazes_Statistics{1,1};
overviewGazes_Statistics{2,6} =(overviewGazes_Statistics{1,6}*100) / overviewGazes_Statistics{1,2};

overviewGazes_Statistics{2,7} = (overviewGazes_Statistics{1,7}*100) / overviewGazes_Statistics{1,1};
overviewGazes_Statistics{2,8} =(overviewGazes_Statistics{1,8}*100) / overviewGazes_Statistics{1,2};

% save it
save([savepath 'overviewGazes_Statistics.mat'],'overviewGazes_Statistics');
writetable(overviewGazes_Statistics,strcat(savepath,'summaryGazes_overall.csv'));



disp(strcat(num2str(length(PartList)), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');