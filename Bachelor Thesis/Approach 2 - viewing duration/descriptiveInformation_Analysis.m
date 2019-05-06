%% ------------------ descriptiveInformation_Analysis --------------
% written by Jasmin Walter

% analyses fixations on objects individually for all participants listed in PartList

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach2-fixations\analysisFixations\';

cd 'D:\BA Backup\Data_after_Script\fixated_vs_noise\'

PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};


noFilePartList = [];
countMissingPart = 0;


%% analyse fixations
overviewFixations = array2table(zeros(length(PartList),9),'VariableNames',{'Participant','allFix','allTime','houseFix','houseTime','nhFix','nhTime','skyFix','skyTime'});


houseList= load('D:\BA Backup\Data_after_Script\HouseList.mat');
houseList= houseList.houseList;

overviewFixationHousesNr = table;
overviewFixationHousesNr.Houses = houseList;

overviewFixationHousesDuration = table;
overviewFixationHousesDuration.Houses = houseList;


for ii = 1:length(PartList)
    currentPart = cell2mat(PartList(ii));
    
    file = strcat('fixated_objects_',num2str(currentPart),'.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        fixatedObjects = load(file);
        fixatedObjects = fixatedObjects.fixatedObjects;
        allFixations = height(fixatedObjects);
        
        noHouses = strcmp(fixatedObjects.House(:),'NH');
        nhTable = fixatedObjects(noHouses,:);
        nhFixations = height(nhTable);
        
        sky = strcmp(fixatedObjects.House(:),'sky');
        skyTable = fixatedObjects(sky,:);
        skyFixations = height(skyTable);
        
        house = not(noHouses | sky);
        houseTable = fixatedObjects(house,:);
        houseFixation = height(houseTable);
        
        % update overview Fixations
        overviewFixations.Participant(ii) = currentPart;
        
        overviewFixations.allFix(ii) = allFixations;
        overviewFixations.allTime(ii) = sum(fixatedObjects.Looks);
        
        overviewFixations.houseFix(ii) = houseFixation;
        overviewFixations.houseTime(ii) = sum(houseTable.Looks);
        
        overviewFixations.nhFix(ii) = nhFixations;
        overviewFixations.nhTime(ii) = sum(nhTable.Looks);
        
        overviewFixations.skyFix(ii) = skyFixations;
        overviewFixations.skyTime(ii) = sum(skyTable.Looks);
        
        % update overview FixationHouses
        
        NrFixations= array2table(zeros(213,1),'VariableNames',{strcat('Part_',num2str(currentPart))});
        timeFixations= array2table(zeros(213,1),'VariableNames',{strcat('Part_',num2str(currentPart))});
       
        
        for index = 1: 213
            findHouse = strcmp(houseList(index),houseTable.House(:));
            numHouse = sum(findHouse);
            
            NrFixations{index,1} = numHouse;
            
            timeFixations{index,1} = sum(houseTable.Looks(findHouse));
            
        end
        
        overviewFixationHousesNr = [overviewFixationHousesNr,NrFixations];
        overviewFixationHousesDuration = [overviewFixationHousesDuration,timeFixations];
        
       
    else
        disp('something went really wrong with participant list');
    end

end

save([savepath 'overviewFixations.mat'],'overviewFixations');

save(strcat(savepath,'overviewFixationHouseNr'),'overviewFixationHousesNr');
save(strcat(savepath,'overviewFixationHouseDuration'),'overviewFixationHousesDuration');


% create summary
summaryFixations = array2table(zeros(2,8),'VariableNames',{'avgAllFix','avgAllTime','avgHouseFix','avgHouseTime','avgNhFix','avgNhTime','avgSkyFix','avgSkyTime'});

summaryFixations.avgAllFix(1) = mean(overviewFixations.allFix);
summaryFixations.avgAllTime(1) = mean(overviewFixations.allTime);

summaryFixations.avgHouseFix(1) = mean(overviewFixations.houseFix);
summaryFixations.avgHouseTime(1) = mean(overviewFixations.houseTime);

summaryFixations.avgNhFix(1) = mean(overviewFixations.nhFix);
summaryFixations.avgNhTime(1) = mean(overviewFixations.nhTime);

summaryFixations.avgSkyFix(1) = mean(overviewFixations.skyFix);
summaryFixations.avgSkyTime(1) = mean(overviewFixations.skyTime);

% calculating percentage
summaryFixations.avgHouseFix(2) = (summaryFixations.avgHouseFix(1)*100) / summaryFixations.avgAllFix(1);
summaryFixations.avgHouseTime(2) =(summaryFixations.avgHouseTime(1)*100) / summaryFixations.avgAllTime(1);

summaryFixations.avgNhFix(2) = (summaryFixations.avgNhFix(1)*100) / summaryFixations.avgAllFix(1);
summaryFixations.avgNhTime(2) =(summaryFixations.avgNhTime(1)*100) / summaryFixations.avgAllTime(1);

summaryFixations.avgSkyFix(2) = (summaryFixations.avgSkyFix(1)*100) / summaryFixations.avgAllFix(1);
summaryFixations.avgSkyTime(2) =(summaryFixations.avgSkyTime(1)*100) / summaryFixations.avgAllTime(1);

% save it
save([savepath 'SummaryFixations.mat'],'summaryFixations');


disp(strcat(num2str(length(PartList)), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');