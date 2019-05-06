%% ---------------------- drawGraph_MapTransparent ----------------------------------
% script written by Jasmin Walter

% draws graphs on half transparent map image of Seahaven

% requires file: Map_Houses_transparent.png
% requires file: CoordinateListNew.txt

clear all;

savepath = 'D:\BA Backup\Data_after_Script\approach3-graphs\plots\map_transparent\';

cd 'D:\BA Backup\Data_after_Script\approach3-graphs\graphs\'


%PartList = {1809,5699,6525,2907,5324,4302,7561,4060,6503,7535,1944,2637,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,8864,8517,2051,4444,5311,5625,9430,2151,3251,6468,4502,5823,8466,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,9364,5583};
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
        
%         % to plot all houses on map use this code
%         plotty = scatter(coordinateList.X,coordinateList.Y,'filled','b');
        
        % mark node houses
        node = ismember(coordinateList.House,nodeTable.Name);
        x = coordinateList{node,2};
        y = coordinateList{node,3};


        plotty = scatter(x,y,'filled','b');
        
        title({strcat('Graph projected on map - Participant: ',num2str(currentPart))});
    
        % add edges into map---------------------------------------------
        
        for ee = 1:length(edgeCell)
            [Xhouse,Xindex] = ismember(edgeCell(ee,1),coordinateList.House);
            
            [Yhouse,Yindex] = ismember(edgeCell(ee,2),coordinateList.House);
            
            x1 = (coordinateList{Xindex,2});
            y1 = coordinateList{Xindex,3};
            
            x2 = coordinateList{Yindex,2};
            y2 = coordinateList{Yindex,3};
            
            line([x1,x2],[y1,y2],'Color','b');
                
            
       end
%---------comment code until here to only show nodes without edges--------
        
      saveas(gcf,strcat(savepath,'Graph projected on Map for Participant ',num2str(currentPart),'.png'),'png');
  
    
    else
        disp('something went really wrong with participant list');
    end

end
disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');