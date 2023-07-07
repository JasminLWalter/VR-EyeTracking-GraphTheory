%% ------------------ drawGraph_creation_GIF_2_WB-------------------------------------
% script written by Jasmin Walter


clear all;


savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\visualization_graph_plots\Gif2\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\gazes_vs_noise\'

PartList = {1013};%{1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};



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



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_gazes_data_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        
        % load data
        gazesData = load(file);
        gazesData = gazesData.gazes_data;
        
%         gazedTable = table;
%         gazedTable.hitObjectColliderName = [gazesData.hitObjectColliderName]';
%         gazedTable.Samples = [gazedObjects.Samples]';
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        % remove all NH and new session elements
        nohouse =strcmp([gazesData.hitObjectColliderName],{'NH'});
        newSess = strcmp([gazesData.hitObjectColliderName],{'newSession'});
        remove = nohouse | newSess;
        
        cleanData = gazesData;
        cleanData(remove)=[];
               
        lastsum = 0;
        housesYaxis = 0;
        rowsAHouses = 0;
        
        xlist = [];
        ylist = [];
        appearedHouses = table;
        appearedEdges = table;
       
        
      %% Plot map to start with
%         figure(4)
        
        for index = 1: scope 
            currentCollider = cleanData(index).hitObjectColliderName;
            
            imshow(map);
            alpha(0.3)
            hold on;
            
            if(index ==1)
            
                node = strcmp(currentCollider,houseList.target_collider_name);
                x = houseList.transformed_collidercenter_x(node);
                y = houseList.transformed_collidercenter_y(node);
                scatter(x,y, 'filled', 'black');
                        
                % plot location
                scatter([cleanData(index).playerBodyPosition_x]*4.2+2050, [cleanData(index).playerBodyPosition_z]*4.2+2050, 10,'filled','red');
                
            else
                
                % plot location
                scatter([cleanData(index).playerBodyPosition_x]*4.2+2050, [cleanData(index).playerBodyPosition_z]*4.2+2050, 10,'filled','red');
                
                %% create graph
                % create nodetable
                uniqueHouses= unique([cleanData(1:index).hitObjectColliderName])';
                NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

                % create edge table

                fullEdgeT= cell2table([cleanData(1:index).hitObjectColliderName]','VariableNames',{'Column1'});

                % prepare second column to add to specify edges
                secondColumn = fullEdgeT.Column1;
                % remove first element of 2nd column
                secondColumn(1,:)=[];  
                % remove last element of 1st column
                fullEdgeT(end,:)= [];

                % add second column to table
                fullEdgeT.Column2 = secondColumn;


                % remove all repetitions
                % 1st round- using unique

                uniqueTable= unique(fullEdgeT);

                % 2nd round using for loop

                %check if first entry is a self-reference
                %create edgetable

                if (strcmp(uniqueTable{1,1},uniqueTable{1,2}))
                    % if self-reference start noRepsTable with second entry
                     noRepsTable= uniqueTable(2,:);
                     noRepsTable.Properties.VariableNames = {'Column1','Column2'};

                     repetitions={};
                     selfReferences={};
                     start = 3;
                else

                     noRepsTable= uniqueTable(1,:);
                     noRepsTable.Properties.VariableNames = {'Column1','Column2'};

                     repetitions={};
                     selfReferences={};
                     start = 2;
                end

             for n=start:height(uniqueTable)

                    node1=uniqueTable{n,1};
                    node2=uniqueTable{n,2};
                    combi2= cell2table([node2,node1],'VariableNames',{'Column1','Column2'});

                    % check if there is a self-reference and don't add it
                    if strcmp(node1,node2)
                        selfReferences=[selfReferences;[node1,node2]];

                    % check if node is already in edgetable (should not be the case
                    % if unique worked correctly)                    
                    elseif sum(ismember(noRepsTable,uniqueTable(n,:),'rows')) == 0

                        % check if other combination of node is in edgetable
                        % if it is not as well, add first combination of node to edgetable 
                        % else, add it to repetition list

                        if sum(ismember(noRepsTable,combi2,'rows')) == 0          
                           noRepsTable=[noRepsTable;uniqueTable(n,:)]; 

                        else    
                            repetitions=[repetitions;uniqueTable(n,:)];

                        end
                    else
                        disp('something went wrong with unique');
                    end



             end


                % create edgetable in merging column 1 and 2 into one variable EndNodes
                EdgeTable= mergevars(noRepsTable,{'Column1','Column2'},'NewVariableName','EndNodes');

          %% create graph


                graphyNoData = graph(EdgeTable,NodeTable);



        %% remove node noData and newSession from graph


                graphy = rmnode(graphyNoData, 'noData');




                %% next step

                nodeTable = graphy.Nodes;
                edgeTable = graphy.Edges;
                edgeCell = edgeTable.EndNodes;

                % plot houses
                node = ismember(houseList.target_collider_name,nodeTable.Name);
                x = houseList.transformed_collidercenter_x(node);
                y = houseList.transformed_collidercenter_y(node);

                
                scatter(x,y, 'filled', 'black');

                % add edges into map-------------------------------------------------------

                for ee = 1:height(edgeCell)
                    [Xhouse,Xindex] = ismember(edgeCell(ee,1),houseList.target_collider_name);

                    [Yhouse,Yindex] = ismember(edgeCell(ee,2),houseList.target_collider_name);

                    x1 = houseList.transformed_collidercenter_x(Xindex);
                    y1 = houseList.transformed_collidercenter_y(Xindex);
                    
                    x2 = houseList.transformed_collidercenter_x(Yindex);
                    y2 = houseList.transformed_collidercenter_y(Yindex);

                    line([x1,x2],[y1,y2],'Color','k');


                end
           end

           set(gca,'xdir','normal','ydir','normal')
                        
    %                         saveas(gcf, strcat(savepath, num2str(currentPart),'_gif_graph_creation_', num2str(index),'.jpg'));
           ax = gca;
           exportgraphics(ax,strcat(savepath, num2str(currentPart),'_gif2_graph_creation_', num2str(index),'.png'),'Resolution',140)
           hold off 
            
            
            
        end
            

    else
        disp('something went really wrong with participant list');
    end
end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

%csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');