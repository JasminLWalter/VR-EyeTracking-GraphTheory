%% ------------------striking_image_graphPaper_Gifm-------------------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;

%% adjust the following variables: 

savepath = 'E:\WestbrookProject\Spa_Re\control_group\Analysis\visualization_graph_plots\gif_strikingImage_Paper\prep\';
imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'E:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\interpolatedColliders\'

% PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004 1005 1008 1017 1018 1021};
% PartList = {1008 1018 1022 1023};
PartList = {1008 1022 1023};

%-----------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));



% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);

% colors = lines(Number);
colorSelect = parula(20);
% colors = colorSelect([2, 8, 16],:);
colors = colorSelect([8, 16, 2],:);

colors(2,1) = colors(2,1) + 0.05;
colors(2,2) = colors(2,2) - 0.05;
colors2 = colors;

for index = 1:height(colors)
    
    hsv        = rgb2hsv(colors(index,:));     % [H S V]

    hsv(3)     = hsv(3)*0.7;     % darken by 40 % (only the Value channel)
    colors2(index,:) = hsv2rgb(hsv);   % back to RGB: 0.0814  0.3789  0.5372


end


%% load data

data1 = load('1008_interpolatedColliders_5Sessions_WB.mat');
data1 = data1.interpolatedData;

data2 = load('1022_interpolatedColliders_5Sessions_WB.mat');
data2 = data2.interpolatedData;

data3 = load('1023_interpolatedColliders_5Sessions_WB.mat');
data3 = data3.interpolatedData;

fps = 30;

%% video info
v = VideoWriter(fullfile(savepath,'gazeGraphs.mp4'),'MPEG-4');
v.FrameRate  = 30;               % play back at normal speed
open(v)



for frameI = 40:90
    figure(1)
    imshow(map);
    alpha(0.3)
    hold on;

    for ii = 1:Number

        if(ii ==1)
            data = data1;
        elseif (ii ==2)
            data = data2;
        else
            data = data3;
        end
                
            currentSum = 0;
            findIndex = 0;
            % while currentSum <= 5 * 60000 % find index to get 5 min of data
            while currentSum <= frameI * (1000/fps)
                findIndex = findIndex +1;
                currentSum = currentSum + data(findIndex).clusterDuration;
    
            end
    
            if (strcmp(data(findIndex).hitObjectColliderName, {'newSession'}))
                findIndex = findIndex-1;
            end
    
            durations = [data(1:findIndex).clusterDuration]';
            isGaze = durations > 266.6;
    
            posX = [data(1:findIndex).playerBodyPosition_x]'; 
            posZ = [data(1:findIndex).playerBodyPosition_z]'; 
    
            name = [data(1:findIndex).hitObjectColliderName]';
    
    
    
    
            %---------------------------------------------------------
            % figure(1)
            % imshow(map);
            % alpha(0.3)
            % hold on;
            % 
    
                    
            % plot(posX*4.2+2050,posZ*4.2+2050, 'LineWidth',2, 'Color',colors(ii,:));
            % scatter(posX*4.2+2050,posZ*4.2+2050, 15, colors2(ii,:),'filled');
            scatter(data(findIndex).playerBodyPosition_x(1)*4.2+2050,data(findIndex).playerBodyPosition_z(1)*4.2+2050, 15, colors2(ii,:),'filled');
    
            
    
    
    
    
    
    
            %% ------------------- gaze graph next:
    
            % remove all NH and sky elements
            gazes = name(isGaze);
            isHouse= ~strcmp(gazes,{'NH'});
            houses = gazes(isHouse);
    
            % create nodetable
            uniqueHouses= unique(houses);
            NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

    
            % create edge table
    
            fullEdgeT= cell2table(houses,'VariableNames',{'Column1'});
    
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
    
             % create edgetable in merging column 1 and 2 into one variable EndNodes
            EdgeTable= mergevars(uniqueTable,{'Column1','Column2'},'NewVariableName','EndNodes');
    
              %% create graph
    
    
            graphy = graph(EdgeTable,NodeTable);
    
    
    
            %% remove node noData and newSession from graph
    
    
            graphy = rmnode(graphy, 'newSession');
            graphy = rmnode(graphy, 'noData');
    
    
    
            %% next step
    
            nodeTable = graphy.Nodes;
            edgeTable = graphy.Edges;
            edgeCell = edgeTable.EndNodes;
    
    
            % plot houses
            node = ismember(houseList.target_collider_name,nodeTable.Name);
            x = houseList.transformed_collidercenter_x(node);
            y = houseList.transformed_collidercenter_y(node);
    
    
            if(ii == 1)
                scatter(x,y, 25, colors(ii,:), 'filled');
    
            elseif(ii==2)
                scatter(x,y, 17, colors(ii,:), 'filled');
            else
                scatter(x,y, 9, colors(ii,:), 'filled');
            end
    
            
    
    
            % add edges into map-------------------------------------------------------
    
           
    
             % add factor for visualization of all 3
            widthL = 1;
            if(ii ==2)
                widthL = 0.5;
    
            elseif(ii==3)
                widthL = 0.1;
            end
    
            for ee = 1:height(edgeCell)
                [Xhouse,Xindex] = ismember(edgeCell(ee,1),houseList.target_collider_name);
    
                [Yhouse,Yindex] = ismember(edgeCell(ee,2),houseList.target_collider_name);
    
                x1 = houseList.transformed_collidercenter_x(Xindex);
                y1 = houseList.transformed_collidercenter_y(Xindex);
    
                x2 = houseList.transformed_collidercenter_x(Yindex);
                y2 = houseList.transformed_collidercenter_y(Yindex);
    
                line([x1,x2],[y1,y2],'Color',colors(ii,:),'LineWidth', widthL);
    
            end
    
            % set(gca,'xdir','normal','ydir','normal')
            % 
            % saveas(gcf, strcat(savepath, num2str(currentPart),'_gazeGraphs_+Walking5min.jpg'));
            % hold off
    
    
    
    end
    set(gca,'xdir','normal','ydir','normal')

    % saveas(gcf, strcat(savepath, '3Parts_gazeGraphs_+Walking5min.jpg'));
    % ax = gca;
    % exportgraphics(ax,strcat(savepath, num2str(frameI),'_3Parts_test.jpg'),'Resolution',200)
    
    drawnow
    writeVideo(v,getframe(gca)) 
    hold off 

end

close(v)





       % ax = gca;
       % exportgraphics(ax,strcat(savepath, num2str(currentPart),'_gazeGraph_5min.png'),'Resolution',140)
       % hold off 







