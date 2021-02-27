%% ------------------ nodeDegree_dwellingTime Version 3-------------------------------------
% script written by Jasmin Walter

clear all;

savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\gazes_vs_noise\'

pathGazes = 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\';
pathND = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree\';

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};
% 


overviewND = load(strcat(pathND, 'Overview_NodeDegree.mat'));
overviewND = overviewND.overviewNodeDegree;

overviewND.avgND = mean(overviewND{:,2:end},2);

overviewBoth = overviewND(:,1);
overviewBoth.avgND = mean(overviewND{:,2:end},2);

overviewDwellingT = load('E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\gazes\overview_summedupSamples_ofGazes_onHouses');
overviewDwellingT = overviewDwellingT.overview_summedupSamples_ofGazes_onHouses;

% overviewDwellingT.avgDwT = mean(overviewDwellingT{:,2:end},2);
overviewBoth.avgDwT = mean(overviewDwellingT{:,2:end},2);

%% code to compute dwelling time with V3 struct
overviewDwellingT_new = overviewDwellingT;

overviewDwellingT_new{:,2:end} = 0;
Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;
for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_gazes_data_V3.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
      
        %% gazes
        % load data
        gazedObjects = load(file);
        gazedObjects = gazedObjects.gazedObjects;
        % create table with necessary fields
        
     
        for indexHouse = 1:length(overviewDwellingT_new.Houses)
            
            house = overviewDwellingT.Houses(indexHouse);
            allOcc = strcmp({gazedObjects.Collider}, house);
            allSamples = [gazedObjects.Samples];
            
            dwellingT = sum(allSamples(allOcc));
            
            % dwelling T is the dwelling time of that participant on the
            % respective house
           
            overviewDwellingT_new{indexHouse,ii+1} = dwellingT;
            
        end

        
    else
        disp('something went really wrong with participant list');
    end

end
%% do the same with allGazes file (for testing)
% 
% allGazes = load(strcat(pathGazes,'gazes_allParticipants'));
% allGazes = allGazes.gazes_allParticipants;
% 
% colliders = {allGazes.Collider};
% samples = [allGazes.Samples];
% 
% noHouse = strcmp(colliders, 'noData') | strcmp(colliders, 'sky') | strcmp(colliders, 'NH');
% 
% onlyHouses = samples(~noHouse);
% onlyHousesC = colliders(~noHouse);
% 
% rmv = isnan(onlyHouses);
% onlyHouses2 = onlyHouses(~rmv);
% onlyHousesC2 = onlyHousesC(~rmv);
% 
% for index = 1: length(overviewDwellingT_new.Houses)
%     
%     house = overviewDwellingT_new.Houses(index);
%     allOcc = strcmp(onlyHousesC2, house);
%     dwellingT = onlyHouses2(allOcc);
% 
%     % dwelling T is the dwelling time of that participant on the
%     % respective house
% 
%     overviewDwellingT_new.Test{index} = sum(dwellingT);
%             
% end
%% plot it

overviewBoth.avgDwT = mean(overviewDwellingT_new{:,2:end},2);

figure(1)
plotty = scatter(overviewBoth.avgND, overviewBoth.avgDwT);
title('Node degree and dwelling time - averaged');
xlabel('avg node degree')
ylabel('avg dwelling time (samples)')

figure(2)


for hindex = 1:213
    
    plotty2 = scatter(overviewND{hindex,2:end-1}, overviewDwellingT_new{hindex,2:end});
    hold on
    
    
end
title('Node degree and dwelling time');
xlabel('node degree')
ylabel('dwelling time (samples)')


disp('done');