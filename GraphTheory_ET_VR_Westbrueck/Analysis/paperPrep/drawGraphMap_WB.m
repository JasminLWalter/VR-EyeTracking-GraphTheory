%% ------------------- drawGraphMap_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% Creates a visualization of the graph on top of the map of Westbrook

% Input: 
% Graph_WB.mat           = the gaze graph object for every participant
% map_natural_white_flipped.png = flipped image of the map of Westbrook 
% building_collider_list.csv  = csv list of the building collider information                corresponding to the map of Seahaven

% Output: 
% Graph_visualizationMap  = image of the graph visualization on top of the 
%                           map for each participant
%                                       
%                                         
%                                         
% Missing_Participant_Files.mat    = contains all participant numbers where the
%                                    data file could not be loaded


clear all;


%% adjust the following variables: 
% savepath, imagepath, clistpath, current folder and participant list!-----

savepath = 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\visualizations_graph_plots\graph_plots\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

cd 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs\';


% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

% can be also adjusted to change the color map for the node degree
% visualization
nodecolor = parula; % colormap parula

%--------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


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




for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_Graph_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2

        % load graph      
        graphy = load(file);
        graphy= graphy.graphy;
        
        nodeTable = graphy.Nodes;
        edgeTable = graphy.Edges;
        edgeCell = edgeTable.EndNodes;
                
        % display map
        figure(1)
        imshow(map);
        alpha(0.3)
        hold on;
            
        title(strcat('Graph & degree centrality values - participant: ',num2str(currentPart)));
    
        % add edges into map-----------------------------------------------
        
        for ee = 1:length(edgeCell)
            [Xhouse,Xindex] = ismember(edgeCell(ee,1),houseList.target_collider_name);
            
            [Yhouse,Yindex] = ismember(edgeCell(ee,2),houseList.target_collider_name);
            

            
            x1 = houseList.transformed_collidercenter_x(Xindex);
            y1 = houseList.transformed_collidercenter_y(Xindex);
            
            x2 = houseList.transformed_collidercenter_x(Yindex);
            y2 = houseList.transformed_collidercenter_y(Yindex);
            
            line([x1,x2],[y1,y2],'Color','k','LineWidth',0.1);             
            
        end
 %---------comment code until here to only show nodes without edges--------
  %% visualize nodes color coded according to the node degree values
  
        node = ismember(houseList.target_collider_name,nodeTable.Name);

        x = houseList.transformed_collidercenter_x(node);
        y = houseList.transformed_collidercenter_y(node);
        
         % plot visualization
%          plotty = scatter(x,y,40,'filled','YDataMode','manual');
         plotty = scatter(x, y, 15 ,'k','filled');
         
         set(gca,'xdir','normal','ydir','normal')
%          ax.ydir=normal;
        
        
%         saveas(gcf,strcat(savepath,num2str(currentPart),'_Graph_visualizationMap.png'),'png');
        saveas(gcf,strcat(savepath,num2str(currentPart),'_Graph_visualizationMap'));
        ax = gca;
        exportgraphics(ax,strcat(savepath,num2str(currentPart),'_Graph_nodeDegree_600dpi.png'),'Resolution',600)
        
        hold off
        
    
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');