%% ------------------timeline_gazes_houses_imagescale_Version 3----------------------------------------
% script written by Jasmin Walter



clear all;

savepath = 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\timeline_gazes\';

cd 'D:\Studium\NBP\Seahaven\90min_Data\newRaycast_Data\gazes_vs_noise\';


% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21};% 21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


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
        
        % load data
        gazedObjects = load(file);
        gazedObjects = gazedObjects.gazedObjects;
        
        newSess=strcmp({gazedObjects.Collider},cellstr('newSession'));
        gazedObjects(newSess) = [];
        gazedHouses = unique({gazedObjects.Collider},'stable');
        
        timelineGazes = table;
        helper = cell(1,gazedObjects(1).Samples);
        helper(1,:) = {gazedObjects(1).Collider};
        timelineGazes.Timestamps = [gazedObjects(1).TimeStamp]';
        timelineGazes.Colliders = helper';
        
        for index = 2: length(gazedObjects)
            collider = gazedObjects(index).Collider;
            sample = gazedObjects(index).Samples;
            timestamps = [gazedObjects(index).TimeStamp];
            helper = cell(1,sample);
            helper(1,:) = {collider};
            hh = table;
            hh.Timestamps = timestamps';
            hh.Colliders = helper';
            timelineGazes = [timelineGazes; hh];
      
            
        end
        
        listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
        coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
        coordinateList.Properties.VariableNames = {'House','X','Y'};
        
        colLog = zeros(height(coordinateList), height(timelineGazes));
        for index = 1: height(coordinateList)
           
            house = coordinateList{index,1};
            colLog(index,:) = strcmp(timelineGazes.Colliders, house);
            
        end
       

        figure(1)
        
        plotty1 = imagesc(colLog);
        xlabel = 'Experiment Time - 90 min';
        ylabel = 'Houses';
        title(strcat('Timeline all gazes on houses - participant: ', num2str(currentPart)));
        
        gazedHouses = unique({gazedObjects.Collider},'stable');

        
        colLog2 = zeros(length(gazedHouses), height(timelineGazes));
        for index2 = 1: length(gazedHouses)
           
            house = gazedHouses{index2};
            colLog2(index2,:) = strcmp(timelineGazes.Colliders, house);
            
        end
       
        figure(2)
        
        plotty2 = imagesc(colLog2);
        xlabel = 'Experiment Time - 90 min';
        ylabel = 'Houses';
        title(strcat('Timeline all gazes on houses - participant: ', num2str(currentPart)));

        
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');


disp('done');