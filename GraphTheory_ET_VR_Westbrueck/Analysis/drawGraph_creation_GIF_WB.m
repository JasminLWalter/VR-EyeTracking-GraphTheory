%% ------------------ drawGraph_creation GIF WB-------------------------------------
% script written by Jasmin Walter


clear all;


savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\visualization_graph_plots\Gif1\';
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
        % create table with necessary fields
        
%         gazedTable = table;
%         gazedTable.hitObjectColliderName = [gazesData.hitObjectColliderName]';
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        lastsum = 0;
        housesYaxis = 0;
        rowsAHouses = 0;
        
        xlist = [];
        ylist = [];
        appearedHouses = table;
        appearedEdges = table;
        lastHouse = {};
        

      %% Plot map to start with
        figure(4)

        imshow(map);
        alpha(0.3)
        hold on;
        
        for index = 1: scope
            currentCollider = gazesData(index).hitObjectColliderName;
            

                        
            % what is the data point? noData? NH/Sky? House?
            
            noData = strcmp(currentCollider,'noData');
            other = strcmp(currentCollider,'NH');
            lastHouse = strcmp(currentCollider, lastHouse);
            house = not(noData | other | lastHouse);
             

                % else if object is a house    
                 if house 
                    lastHouse = currentCollider;        
                        
                    node = strcmp(currentCollider,houseList.target_collider_name);
                    x = houseList.transformed_collidercenter_x(node);
                    y = houseList.transformed_collidercenter_y(node);
                    
                    % if it is the first item in the appeaerdHouses List
                    if height(appearedHouses) == 0
                    % if it is the first house to occur, just add house - 
                    % and just and plot it
                        
                        scatter(x,y, 'filled', 'black');
                        hold on
                        
                        % plot location
%                         scatter(gazedTable(index).PosZ'*zT+zA, gazedTable(index).PosX'*xT+xA, 'filled','green');
                        
                        
                        rowsAHouses = rowsAHouses +1;
                        appearedHouses.Name(rowsAHouses) = currentCollider;          
                        
                    else                        
                    % check whether it is a new house or it was already
                    % seen to see whether to draw only the edge or also the
                    % node
                    
                            % if the house was already seen 
                            if any(strcmp(currentCollider,appearedHouses.Name))
                                % & is not identical to the last one
                                if not(strcmp(currentCollider, appearedHouses.Name(rowsAHouses)))
                                
                                    % check if edge is new - if it new, add it
                                    check1 = ismember(table(appearedHouses.Name(rowsAHouses), currentCollider, 'VariableNames',{'Var1','Var2'}),appearedEdges);
                                    check2 = ismember(table(currentCollider,appearedHouses.Name(rowsAHouses), 'VariableNames',{'Var1','Var2'}),appearedEdges);
                                    
                                    if not(check1 | check2)

                                        % add edge to appearedEdges in both
                                        % variations
                                        appearedEdges = [appearedEdges; appearedHouses.Name(rowsAHouses), currentCollider; currentCollider, appearedHouses.Name(rowsAHouses)];

                                        % plus draw it into image
                                        
                                        node2 = strcmp(appearedHouses.Name(rowsAHouses),houseList.target_collider_name);
                                        x2 = houseList.transformed_collidercenter_x(node2);
                                        y2 = houseList.transformed_collidercenter_y(node2);


                                        line([x,x2],[y,y2],'Color','k');
                                         % plot location
%                                         scatter(gazedObjects(index).PosZ'*zT+zA, gazedObjects(index).PosX'*xT+xA, 'filled','green');
                                        
                                    end
                                end

                            else
                                % loop if the house was not yet seen
                                % add edge to appearedEdges in both
                                % variations
                                appearedEdges = [appearedEdges; appearedHouses.Name(rowsAHouses), currentCollider; currentCollider, appearedHouses.Name(rowsAHouses)];
                                
                                % plus draw it into image
                                node2 = strcmp(appearedHouses.Name(rowsAHouses),houseList.target_collider_name);
                                x2 = houseList.transformed_collidercenter_x(node2);
                                y2 = houseList.transformed_collidercenter_y(node2);


                                line([x,x2],[y,y2],'Color','k');
                                
                                % and add the house and draw it
                                scatter(x,y, 'filled', 'black');
                                
                                % plot location
%                                 scatter(gazedObjects(index).PosZ'*zT+zA, gazedObjects(index).PosX'*xT+xA, 'filled','green');

                                rowsAHouses = rowsAHouses +1;
                                appearedHouses.Name(rowsAHouses) = currentCollider;
                                
                            end

                    end
                    
                        set(gca,'xdir','normal','ydir','normal')
                        
%                         saveas(gcf, strcat(savepath, num2str(currentPart),'_gif_graph_creation_', num2str(index),'.jpg'));
                        ax = gca;
                        exportgraphics(ax,strcat(savepath, num2str(currentPart),'_gif_graph_creation_', num2str(index),'.png'),'Resolution',140)
                 end
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