%% ------------------ plot_graph_creation GIF_2 _V3-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\GIF_graphcreation_V3\2ndTry\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {35};%21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};



Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

scope = 1000;

% load map

map = imread ('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_New.png');



% load house list with coordinates

listname = 'D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};



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
        
        % remove all NH and sky elements
        
        gazedTable = table;
        gazedTable.Collider = {gazedObjects.Collider}';
        gazedTable.Samples = [gazedObjects.Samples]';
        gazedTable.TimeStamp = {gazedObjects.TimeStamp}';
        
        nohouse=strcmp(gazedTable.Collider(:),cellstr('NH')) | strcmp(gazedTable.Collider(:),cellstr('sky'));
        housesTable = gazedTable;
        housesTable(nohouse,:)=[];
        housesTable(1,:) = []; % watch out, personalized content, needs to be removed if other participant is used (laze way to deal with self-reference)
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        lastsum = 0;
        housesYaxis = 0;
        rowsAHouses = 0;
        
        xlist = [];
        ylist = [];
        appearedHouses = table;
        appearedEdges = table;
        
        %%  transformation of position coordinates so they match the map image
        %   consists of 2 factors (mulitply and additive factor)
        xT = 6.05;
        zT = 6.1;
        xA = -1100;
        zA = -3290;
        
        
      %% Plot map to start with
        figure(4)
        
        for index = 1: scope 
            
            imshow(map);
            alpha(0.1)
            hold on;
            if(index ==1)
            
                hlocation= strcmp(housesTable.Collider(index),coordinateList{:,1});
                scatter(coordinateList{hlocation,2},coordinateList{hlocation,3}, 'filled', 'black');
                        
                % plot location
                scatter(gazedObjects(index).PosZ'*zT+zA, gazedObjects(index).PosX'*xT+xA, 10, 'filled','red');
                
            else
                
                % plot location
                scatter(gazedObjects(index).PosZ'*zT+zA, gazedObjects(index).PosX'*xT+xA, 10, 'filled','red');
            
                %% create graph
                % create nodetable
                uniqueHouses= unique(housesTable.Collider(1:index));
                NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

                % create edge table

                fullEdgeT= cell2table(housesTable.Collider(1:index),'VariableNames',{'Column1'});

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
                graphy = rmnode(graphy, 'newSession');




                %% next step

                nodeTable = graphy.Nodes;
                edgeTable = graphy.Edges;
                edgeCell = edgeTable.EndNodes;

                % plot houses
                node = ismember(coordinateList.House,nodeTable.Name);
                x = coordinateList{node,2};
                y = coordinateList{node,3};


                plotty = scatter(x,y,'filled','k');

                % add edges into map-------------------------------------------------------

                for ee = 1:height(edgeCell)
                    [Xhouse,Xindex] = ismember(edgeCell(ee,1),coordinateList.House);

                    [Yhouse,Yindex] = ismember(edgeCell(ee,2),coordinateList.House);

                    x1 = (coordinateList{Xindex,2});
                    y1 = coordinateList{Xindex,3};

                    x2 = coordinateList{Yindex,2};
                    y2 = coordinateList{Yindex,3};

                    line([x1,x2],[y1,y2],'Color','k');


                end
           end

           saveas(gcf, strcat(savepath, 'img_', num2str(index),'.png')); 
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