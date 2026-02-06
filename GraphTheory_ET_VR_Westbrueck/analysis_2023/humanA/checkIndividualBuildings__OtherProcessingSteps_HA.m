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

clear all;

%% adjust the following variables: 
% savepath, imagepath, clistpath, overviewNDpath and current folder-----------------------

savepath= 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\checkBuildings\';


imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location


% location of file containing all gaze data and all interpolated of all participants
cd 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\pre-processing\velocity_based\step3_gazeProcessing\'


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


allData = table;



for indexPart = 1:length(partList)
    tic
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = partList(indexPart);
    
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

            % sort the list to be sure
            fileNames = {dirSess.name}';
            fileNames_sorted = sortrows(fileNames, 'ascend');



            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(fileNames_sorted)
                disp(['Process file: ', fileNames_sorted{indexET}]);
                % read in the data
                % data = readtable([num2str(1004) '_Session_1_ET_1_data_correTS_mad_wobig.csv']);
                data = readtable(fileNames_sorted{indexET});

                isFix = ~ismissing(data.isFix);

                dSelect = table;
               
                dSelect.processedCollider_name = data.processedCollider_NH_name(isFix);

                dSelect.processedCollider_hitPointOnObject_x = data.processedCollider_NH_hitPointOnObject_x(isFix);
                dSelect.processedCollider_hitPointOnObject_y = data.processedCollider_NH_hitPointOnObject_y(isFix);
                dSelect.processedCollider_hitPointOnObject_z = data.processedCollider_NH_hitPointOnObject_z(isFix);

                dSelect.processedCollider_hitObjectColliderBoundsCenter_x = data.processedCollider_NH_hitObjectColliderBoundsCenter_x(isFix);
                dSelect.processedCollider_hitObjectColliderBoundsCenter_y = data.processedCollider_NH_hitObjectColliderBoundsCenter_y(isFix);
                dSelect.processedCollider_hitObjectColliderBoundsCenter_z = data.processedCollider_NH_hitObjectColliderBoundsCenter_z(isFix);

                dSelect.o_processedCollider_hitPointOnObject_x = data.original_processedCollider_NH_hitPointOnObject_x(isFix);
                dSelect.o_processedCollider_hitPointOnObject_y = data.original_processedCollider_NH_hitPointOnObject_y(isFix);
                dSelect.o_processedCollider_hitPointOnObject_z = data.original_processedCollider_NH_hitPointOnObject_z(isFix);

                % dSelect.ColliderName = data.hitObjectColliderName_1;
                % 
                % dSelect.hitPoint_x = data.hitPointOnObject_x_1;
                % dSelect.hitPoint_y = data.hitPointOnObject_y_1;
                % dSelect.hitPoint_z = data.hitPointOnObject_z_1;
                % 
                % dSelect.colliderBounds_x =  data.hitObjectColliderBoundsCenter_x_1;
                % dSelect.colliderBounds_y =  data.hitObjectColliderBoundsCenter_y_1;
                % dSelect.colliderBounds_z =  data.hitObjectColliderBoundsCenter_z_1;
                % 





                allData = [allData; dSelect];
           
                
            end
        end
    end

end

writetable(allData,strcat(savepath, "combinedProcessedColliderData_fixations.csv"))

disp("done")