%% ------------------timeline_gazes_houses_scatter_Version 3----------------------------------------
% script written by Jasmin Walter



clear all;

savepath = 'D:\Studium\NBP\Seahaven\90min_Data\Desync_Analysis\timeline_gazes\';

cd 'D:\Studium\NBP\Seahaven\90min_Data\newRaycast_Data\gazes_vs_noise\';


% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {35};% 21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


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
        
        newSess=strcmp({gazedObjects.Session},cellstr('Session1'));
        session1 = gazedObjects(newSess);
                
        
        listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
        coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
        coordinateList.Properties.VariableNames = {'House','X','Y'};
        
        gazesOverview = struct;
        
        for index = 1: 35
           
            gazesList = table;
            house = coordinateList{index,1};
            gazesOverview(index).House = house;
            logical = strcmp({session1.Collider}, house);
            helperGazes = session1(logical);
            startPoints = [];
            endPoints = [];
            
            for index2 = 1: length(helperGazes)
                startPoints = [startPoints, helperGazes(index2).TimeStamp(1)];
                endPoints = [endPoints, helperGazes(index2).TimeStamp(end)];
            end
            if(length(startPoints) > 1)
                
                durations = startPoints(2:end) - endPoints(1:end-1);
                gazesOverview(index).Durations = durations;
                x = ones(1,length(durations));
                figure(1)
                plotty = swarmchart(index*x, durations, 10);
                hold on;
            end
            title(strcat('swarmchart of durations in between gazes on same house- part: ', num2str(currentPart)))
            
        end

        

        
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants in List'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');


disp('done');