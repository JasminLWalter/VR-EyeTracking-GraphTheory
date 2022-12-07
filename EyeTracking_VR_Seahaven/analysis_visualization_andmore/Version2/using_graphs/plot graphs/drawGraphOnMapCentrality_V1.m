%%-------------------- draw graph on map centrality------------------------
% script written by Jasmin Walter

% draws graph on map of Seahaven while color coding centrality degree values
% requires file: Map_Houses_green_edges_New.jpg
% requires file: CoordinateListNew.txt

clear all;

%-----------adjustable variables---------

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree\participant35\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\graphs\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {35};%21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


nodecolor = parula;

%------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% load map

map = imread ('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');

% load house list with coordinates

listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};



% % load node degree centrality overview
% overviewDegree= load('E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\graphs\analysis\Overview_NodeDegree.mat');
% overviewDegree = overviewDegree.overviewNodeDegree;



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_Graph.mat');
 
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
        alpha(0.1)
        hold on;
        
       
        
        %title(strcat('Graph & degree centrality values - projection on Map - participant: ',num2str(currentPart)));
    
        % add edges into map-----------------------------------------------
        
        for ee = 1:length(edgeCell)
            [Xhouse,Xindex] = ismember(edgeCell(ee,1),coordinateList.House);
            
            [Yhouse,Yindex] = ismember(edgeCell(ee,2),coordinateList.House);
            
            x1 = (coordinateList{Xindex,2});
            y1 = coordinateList{Xindex,3};
            
            x2 = coordinateList{Yindex,2};
            y2 = coordinateList{Yindex,3};
            
            line([x1,x2],[y1,y2],'Color','k','LineWidth',0.02);%,'LineStyle',':');             
            
        end
 %---------comment code until here to only show nodes without edges--------
  % mark node houses
        node = ismember(coordinateList.House,nodeTable.Name);
        x = coordinateList{node,2};
        y = coordinateList{node,3};

        
         markerND = centrality(graphy,'degree')';
         plotty = scatter(x,y,40,markerND,'filled');
         colormap(nodecolor);
         %colorbar
        
        % markerC defines color vector for colormap
        %NOTE do not forget to transpose vector such that it is oriented
        %horizontally
%         
%         varname = strcat('Part_',num2str(currentPart));
%         markerC = overviewDegree{:,varname}';
%         
%         % remove zeros
%         zeroos = markerC == 0;
%         markerC(zeroos) = [];
%         
%         plotty = scatter(x,y,60,markerC,'filled');
%         colormap jet
%         colorbar
        
      %saveas(gcf,strcat(savepath,'Graph_node_degree_map_participant_',num2str(currentPart),'.png'),'png');
  
    
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

%csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');