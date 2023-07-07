%% ------------------ draw_walkingPaths_GIF_WB_Part1-------------------------------------
% script written by Jasmin Walter


clear all;


savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\visualization_graph_plots\Gif_walkingPaths\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\interpolatedColliders\'

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

scope = 600;

% load map
% !!! Note: the map matches the default coordinate system in python only
% Matlab uses a different coordinate system, therefore, the map needs to be
% flipped on the vertical axis for the coordniates to be correct in Matlab
% plots. Before saving, the image then needs to be flipped back!
% there are more complicated transformations of the coordinates possible,
% but this is the easiest workaround to receive a correct map visualization
% plot!!!

% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));



% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);


overviewWalkingPathsX = [];
overviewWalkingPathsZ = [];


for ii = 1:Number
    
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        
        % load data
        data = load(file);
        data = data.interpolatedData;
        
        for index = 1:1000
            overviewWalkingPathsX(index,ii) = [data(index).playerBodyPosition_x(1)]'; 
            overviewWalkingPathsZ(index,ii) = [data(index).playerBodyPosition_z(1)]'; 
        
        end     
     
    end            

end
  

save([savepath 'overviewWalkingPathsX'],'overviewWalkingPathsX');
save([savepath 'overviewWalkingPathsZ'],'overviewWalkingPathsZ');

disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));



disp('done');