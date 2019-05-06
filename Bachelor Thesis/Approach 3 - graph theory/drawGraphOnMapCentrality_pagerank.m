%%-------------------- draw graph on map centrality_ pagerank------------------------
% script written by Jasmin Walter

% draws graph on map of Seahaven while color coding centrality degree values
% requires file: Map_Houses_green_edges_New.jpg
% requires file: CoordinateListNew.txt

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\centrality\onMapPlots\pagerank\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\graphs\'


%PartList = {9471,1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};
PartList = {8580,1809,9471};

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% load map

map = imread ('D:\BA Backup\Data_after_Script\Map, CoordinateList\Map_Houses_transparent.png');

% load house list with coordinates

listname = 'D:\BA Backup\Data_after_Script\Map, CoordinateList\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};



% load node degree centrality overview




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
        hold on;
        
        % mark node houses
        node = ismember(coordinateList.House,nodeTable.Name);
        x = coordinateList{node,2};
        y = coordinateList{node,3};

        % load overview 6468
        overviewCentrality=load(strcat('D:\BA Backup\Data_after_Script\approach3-graphs\centrality\centralityScript\overviewCentrality_Participant_',num2str(currentPart)));
        overviewCentrality = overviewCentrality.overviewCentrality;
        
        % markerC defines color vector for colormap
        %NOTE do not forget to transpose vector such that it is oriented
        %horizontally
        markerC = overviewCentrality{:,5}';

        
        plotty = scatter(x,y,60,markerC,'filled');
        colormap jet
        colorbar
        
        title({strcat('Graph - pagerank centrality - Participant- ',num2str(currentPart),' - on map'),'    '});
    
        % add edges into map-----------------------------------------------
        
        for ee = 1:length(edgeCell)
            [Xhouse,Xindex] = ismember(edgeCell(ee,1),coordinateList.House);
            
            [Yhouse,Yindex] = ismember(edgeCell(ee,2),coordinateList.House);
            
            x1 = (coordinateList{Xindex,2});
            y1 = coordinateList{Xindex,3};
            
            x2 = coordinateList{Yindex,2};
            y2 = coordinateList{Yindex,3};
            
            line([x1,x2],[y1,y2],'Color','black');             
            
        end
 %---------comment code until here to only show nodes without edges--------
        
      saveas(gcf,strcat(savepath,'Graph_centralityPagerank_on_Map_Participant_',num2str(currentPart),'.png'),'png');
  
    
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');