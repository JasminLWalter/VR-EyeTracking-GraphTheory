%% ------------------ check_individual_buildings_HA----------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% Script analyses how many gaze-graph-defined landmarks were viewed from 
% each location participants visited in the city. In addition, it analyses
% how much of the total experiment time participants spend in these areas 
% where the theoretical basis for triangulation would be given. 
% The analysis is performed with a spatial resolution of 4x4m and an 
% additional smoothing with a 3x3 unity kernel. 


% Input: 
% gazes_allParticipants.mat        = data file containing all gazes from all
%                                    participants
%                                    - created when running script...

% interpolData_allParticipants.mat = data file containing all interpolated
%                                    data from all participants
%                                    - created when running script

% Overview_NodeDegree.mat  =  table consisting of all node degree values
%                             for all participants (alternatively the list
%                             of the rich club count for all houses)
%                          
% Map_Houses_New.png       = image of the map of Seahaven 
% CoordinateListNew.txt    = csv list of the house names and x,y coordinates
%                            corresponding to the map of Seahaven


% Output: 
% Figure 1: visibility of top 10 houses - rich club and node degree
% = map plot color coded for all top 10 houses

% Figure 2: Visibility of top 10 houses - rich club & node degree'
% = like figure 1, but here the map is only color coded to differentiate
% areas where 0 top 10 houses, 1 top 10 house, and 2 or more top 10 houses
% were viewed (Fig. 9 of the paper)

% Figure 3: grid size_vibility plots.png
% = visualization of the 4x4 grid dividing the city

% Figure 20: Percentage of possibility to triangulate in walked area
% = pie plot of the percentages of the different city areas participants 
% were located in

% Figure 21: Percentage of times triangulation was possible
% = pie plot of the percentages of experiment time participants spend in
% triangulation areas (same visualization as Figure 20, but different data)

% table_percentage_triangulation.mat
% = table listing the percentages of the areas in the city where participants
% viewed 0, 1, 2 or more houses

% table_times_triangulation_possible.mat
% = table listing the percentage of experiment time participants spend in
% areas where 0, 1, 2 or more houses where visible

% clear all;

%% adjust the following variables: 
% savepath, imagepath, clistpath, overviewNDpath and current folder-----------------------

cd 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\checkBuildings\'


imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

createDiffList = false;
saveFigures = true;

%------------------------------------------------------------------------

% load map

map_flipped = imread (strcat(imagepath,'map_natural_white_flipped.png'));
map_normal = imread (strcat(imagepath,'map_natural_white.png'));

% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);


partList = [365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7412 7842 8007 8469 8673 9472 9502 9586 9601];


% allData = readtable(strcat(savepath, "combinedProcessedColliderData"));



% identify all relevant samples

uniqueBuildings = unique(houseList.target_collider_name);
currentBuilding = uniqueBuildings(10);
% currentBuilding = {'Crane_59'};

listBuilding = currentBuilding;
% listBuilding  = {'crane_2'};

selection = strcmp(currentBuilding, allData.processedCollider_name);
% selection = strcmp(currentBuilding, allData.ColliderName);


figure(1)

disp(currentBuilding)
imshow(map_flipped);
alpha(0.3)
hold on

scatter(allData.processedCollider_hitPointOnObject_x(selection)*4.2+2050,...
    allData.processedCollider_hitPointOnObject_z(selection)*4.2+2050, 15, 'k','filled');

scatter(allData.processedCollider_hitObjectColliderBoundsCenter_x(selection)*4.2+2050,...
    allData.processedCollider_hitObjectColliderBoundsCenter_z(selection)*4.2+2050, 25, 'b','filled');

scatter(allData.o_processedCollider_hitPointOnObject_x(selection)*4.2+2050,...
    allData.o_processedCollider_hitPointOnObject_z(selection)*4.2+2050, 15, 'g','filled');
% 
% 
% 
% scatter(allData.hitPoint_x(selection)*4.2+2050,...
%     allData.hitPoint_z(selection)*4.2+2050, 15, 'k','filled');
% 
% scatter(allData.colliderBounds_x(selection)*4.2+2050,...
%     allData.colliderBounds_z(selection)*4.2+2050, 25, 'b','filled');



 % plot houses
node = ismember(houseList.target_collider_name, listBuilding);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);


scatter(x,y, 30, 'r', 'filled');

set(gca,'xdir','normal','ydir','normal')


hold off

if saveFigures

    disp ("save figures")

    if iscell(currentBuilding);  currentBuilding  = currentBuilding{1};  end
    if iscell(listBuilding);     listBuilding     = listBuilding{1};     end
    
    % Save the current figure
    saveas(gcf, sprintf('%s_%s_colliderHits_coordinates.png', ...
                       currentBuilding, listBuilding));          % extension ".png" tells MATLAB to write a PNG
    
    savefig(gcf, sprintf('%s_%s_colliderHits_coordinates.fig', ...
                       currentBuilding, listBuilding));      % or:  savefig('mySinePlot.fig')  (uses gcf)

end







% create list of building differences between HumanA and SpaRe version!
if createDiffList

    disp("create diff list")
    nameDiffList = table;
    
    nameDiffList.SpaRe_BuildingName(1) = {'Building_57'};
    nameDiffList.HumanA_BuildingName(1) = {'Building_237'};
    
    nameDiffList.SpaRe_BuildingName(2) = {'Building_58'};
    nameDiffList.HumanA_BuildingName(2) = {'Building_238'};
    
    nameDiffList.SpaRe_BuildingName(3) = {'Building_59'};
    nameDiffList.HumanA_BuildingName(3) = {'Building_239'};
    
    nameDiffList.SpaRe_BuildingName(4) = {'crane_2'};
    nameDiffList.HumanA_BuildingName(4) = {'Crane_59'};
    
    
    writetable(nameDiffList,strcat(clistpath, "differencesBuildingNames_SpaRe_HumanA.csv"))

end


disp("done")


