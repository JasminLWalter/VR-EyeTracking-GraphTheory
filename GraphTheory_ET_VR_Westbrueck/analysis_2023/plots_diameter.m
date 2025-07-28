%% -------------------- plotsDiameter_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
savepath1min = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\tempDevelopment\1minSections\';
savepath = strcat(savepath1min, 'AnalysisDiameter\');
savepathMaxDPlots = strcat(savepath1min, 'AnalysisDiameter\maxDiameterGif\');
savepathEndDPlots = strcat(savepath1min, 'AnalysisDiameter\endDiameterGif\');

imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

cd(savepath)

pathOverviews = savepath1min;

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


map = imread (strcat(imagepath,'map_natural_white_flipped.png'));



% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);



% load overviews

overviewMaxDiameter = load('overviewMaxDiameter.mat');
overviewMaxDiameter = overviewMaxDiameter.overviewMaxDiameter;



overviewEndDiameter = load('overviewEndDiameter.mat');
overviewEndDiameter = overviewEndDiameter.overviewEndDiameter;


figure(1)
imshow(map);
alpha(0.3)
hold on;

colors1 = parula(length(overviewMaxDiameter));

for index1 = 1:length(overviewMaxDiameter)

    plot([overviewMaxDiameter(index1).BodyPosition_x]*4.2+2050, [overviewMaxDiameter(index1).BodyPosition_z]*4.2+2050, 'LineWidth',2,'color',colors1(index1,:));


end

set(gca,'xdir','normal','ydir','normal')

hold off
ax = gca;
exportgraphics(ax,strcat(savepath, 'mapWalkingPaths_duringMaxDiameterTime.png'),'Resolution',600)
hold off 



colors2_3Values = parula(3);

figure(2)

for index = 5:7

    isI = [overviewMaxDiameter(:).endDiameter] == index;
    plotty2 = scatter([overviewMaxDiameter(isI).maxDiameter], [overviewMaxDiameter(isI).NumMaxDiameters], 20,colors2_3Values(index-4,:), 'filled','DisplayName', num2str(index));
    hold on


end


xlabel('max diameter')
ylabel('number of max diameter')
title('max diameter and number of max diameter')
legend
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'maxDiameter_NumberMaxDiameter.png'),'Resolution',600)


startNodes = arrayfun(@(x) {x.StartNode.name}, overviewMaxDiameter, 'UniformOutput', false);
startNodes = [startNodes{:}];


endNodes = arrayfun(@(x) {x.EndNode.name}, overviewMaxDiameter, 'UniformOutput', false);
endNodes = [endNodes{:}];

allNodes = [startNodes',endNodes'];

% uniqueNodes = unique(allNodes);

% Find unique values and their indices
[uniqueValues, ~, idx] = unique(allNodes);

% Count occurrences of each unique value
occurrences = histc(idx, 1:numel(uniqueValues));






figure(3)

imshow(map);
alpha(0.3)
hold on;

 % plot houses
node = ismember(houseList.target_collider_name,uniqueValues);

x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);


plotty3 = scatter(x,y, 20,occurrences,'filled');

colorbar;

set(gca,'xdir','normal','ydir','normal')

hold off


ax = gca;
exportgraphics(ax,strcat(savepath, 'map_maxDiameterBuildings.png'),'Resolution',600)


pathTable = table;
counter = 0;
for indexU = 1: height(allNodes)

    if indexU == 1

        pathTable.StartNode(indexU) = allNodes(1,1);
        pathTable.EndNode(indexU) = allNodes(1,2);
        pathTable.Occurrence(indexU) = 1; 
        counter = counter +1;

    else

        node1 = allNodes(indexU,1);
        node2 = allNodes(indexU,2);

        is1 = ismember(pathTable.StartNode,node1);
        is2 = ismember(pathTable.EndNode,node2);

        is3 = ismember(pathTable.EndNode,node1);
        is4 = ismember(pathTable.StartNode,node2);


        exists = (is1 & is2) | (is3 & is4);

        if (sum(exists)== 1) % if the combination of node 1 and node 2 appears in table
            pathTable.Occurrence(exists) = pathTable.Occurrence(exists) + 1;


        else
            counter = counter +1;
            pathTable.StartNode(counter) = node1;
            pathTable.EndNode(counter) = node2;
            pathTable.Occurrence(counter) = 1; 

        end

    end


end




figure(4)

imshow(map);
alpha(0.3)
hold on;

colors4 = parula(max(pathTable.Occurrence));
% plot paths

for ee = 1:height(pathTable)
    [Xhouse,Xindex] = ismember(pathTable{ee,1},houseList.target_collider_name);

    [Yhouse,Yindex] = ismember(pathTable{ee,2},houseList.target_collider_name);

    x1 = houseList.transformed_collidercenter_x(Xindex);
    y1 = houseList.transformed_collidercenter_y(Xindex);
    
    x2 = houseList.transformed_collidercenter_x(Yindex);
    y2 = houseList.transformed_collidercenter_y(Yindex);

    line([x1,x2],[y1,y2],'Color',colors4(pathTable{ee,3},:),'LineWidth',0.5); 


end

colorbar


% plot houses
node = ismember(houseList.target_collider_name,uniqueValues);

x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);


plotty4 = scatter(x,y, 20,occurrences,'filled');






set(gca,'xdir','normal','ydir','normal')

hold off


ax = gca;
exportgraphics(ax,strcat(savepath, 'map_maxDiameter_Buildings_Paths.png'),'Resolution',600)




% one final max plot with participant dependend coloring for everything




for index5 = 1:length(overviewMaxDiameter)


   startNodes = struct2table(overviewMaxDiameter(index5).StartNode);
   endNodes = struct2table(overviewMaxDiameter(index5).EndNode);

   if length(overviewMaxDiameter(index5).StartNode) == 1
        startNodes.name = {startNodes.name};
        endNodes.name = {endNodes.name};


   end

   nodes = unique([startNodes.name;endNodes.name]);

   colors5 = parula(max([overviewMaxDiameter.maxDiameter]));

    figure(5)
    imshow(map);
    alpha(0.3)
    hold on;

    plot([overviewMaxDiameter(index5).BodyPosition_x]*4.2+2050, [overviewMaxDiameter(index5).BodyPosition_z]*4.2+2050, 'LineWidth',2,'color','k');


   for ee = 1:height(startNodes)

        [Xhouse,Xindex] = ismember(startNodes{ee,1},houseList.target_collider_name);
    
        [Yhouse,Yindex] = ismember(endNodes{ee,1},houseList.target_collider_name);
    
        x1 = houseList.transformed_collidercenter_x(Xindex);
        y1 = houseList.transformed_collidercenter_y(Xindex);
        
        x2 = houseList.transformed_collidercenter_x(Yindex);
        y2 = houseList.transformed_collidercenter_y(Yindex);
    
        line([x1,x2],[y1,y2],'Color',colors5(overviewMaxDiameter(index5).maxDiameter,:),'LineWidth',0.5); 
    
    
    end

    % plot houses
    node = ismember(houseList.target_collider_name,nodes);
    
    x = houseList.transformed_collidercenter_x(node);
    y = houseList.transformed_collidercenter_y(node);
    
    
    plotty5 = scatter(x,y, 20,colors5(overviewMaxDiameter(index5).maxDiameter,:),'filled');

    clim([1 max([overviewMaxDiameter.maxDiameter])]);
    colorbar

    set(gca,'xdir','normal','ydir','normal')

    hold off
    ax = gca;
    exportgraphics(ax,strcat(savepathMaxDPlots, num2str(index5),'_map_maxDiameter.png'),'Resolution',600)


end



%% end diameter plots

legendNames = {'diameter = 5', 'diameter = 6', 'diameter = 7'};

for index6 = 1:length(overviewEndDiameter)


   startNodes = struct2table(overviewEndDiameter(index6).StartNode);
   endNodes = struct2table(overviewEndDiameter(index6).EndNode);

   if length(overviewEndDiameter(index6).StartNode) == 1
        startNodes.name = {startNodes.name};
        endNodes.name = {endNodes.name};


   end

   nodes = unique([startNodes.name;endNodes.name]);


    figure(6)
    imshow(map);
    alpha(0.3)
    hold on;


   for ee = 1:height(startNodes)

        [Xhouse,Xindex] = ismember(startNodes{ee,1},houseList.target_collider_name);
    
        [Yhouse,Yindex] = ismember(endNodes{ee,1},houseList.target_collider_name);
    
        x1 = houseList.transformed_collidercenter_x(Xindex);
        y1 = houseList.transformed_collidercenter_y(Xindex);
        
        x2 = houseList.transformed_collidercenter_x(Yindex);
        y2 = houseList.transformed_collidercenter_y(Yindex);
    
        line([x1,x2],[y1,y2],'Color',colors2_3Values((overviewEndDiameter(index6).endDiameter-4),:),'LineWidth',0.5); 
    
    
    end

    % plot houses
    node = ismember(houseList.target_collider_name,nodes);
    
    x = houseList.transformed_collidercenter_x(node);
    y = houseList.transformed_collidercenter_y(node);
    
    
    plotty6 = scatter(x,y, 20,colors2_3Values((overviewEndDiameter(index6).endDiameter-4),:),'filled');

    % Create dummy plots for the custom legend
    for i = 1:size(colors2_3Values, 1)
        legendHandles(i) = plot(nan, nan, 'o', 'MarkerFaceColor', colors2_3Values(i, :), 'MarkerEdgeColor', colors2_3Values(i, :), 'DisplayName', legendNames{i});
    end
    
    % Create custom legend
    legend(legendHandles,legendNames,'Location','southwest', 'NumColumns',1, 'FontSize', 5);

    set(gca,'xdir','normal','ydir','normal')

    hold off
    ax = gca;
    exportgraphics(ax,strcat(savepathEndDPlots, num2str(overviewEndDiameter(index6).endDiameter),'endDiameter_participant_',num2str(index6),'_map_endDiameterBuildings.png'),'Resolution',600)


end




figure(7)

for index = 5:7

    isI = [overviewEndDiameter(:).endDiameter] == index;
    plotty7 = scatter([overviewEndDiameter(isI).endDiameter], [overviewEndDiameter(isI).NumMaxDiameters], 20,colors2_3Values(index-4,:), 'filled','DisplayName', num2str(index));
    hold on


end


xlabel('end diameter')
ylabel('number of end diameters')
title('end diameter and number of end diameter')
legend
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'endDiameter_NumberEndDiameter.png'),'Resolution',600)


labels = cell(3, 1);

figure(8)

for index = 1:3

    endDiameterValue = index + 4;
    isI = [overviewEndDiameter(:).endDiameter] == endDiameterValue;
    plotty7 = boxplot([overviewEndDiameter(isI).NumMaxDiameters], 'Positions', index);
    labels{index} = num2str(endDiameterValue);
    hold on


end

set(gca, 'XTick', 1:3, 'XTickLabel', labels);
xlabel('end diameter')
ylabel('number of end diameters')
title('Boxplot end diameter and number of end diameter')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'endDiameter_NumberEndDiameter_boxplot.png'),'Resolution',600)

%%

for index9 = 5:7

    filter = [overviewEndDiameter.endDiameter] == index9;

    filteredStruct = overviewEndDiameter(filter);


    startNodes = arrayfun(@(x) {x.StartNode.name}, filteredStruct, 'UniformOutput', false);
    startNodes = [startNodes{:}];
    
    
    endNodes = arrayfun(@(x) {x.EndNode.name}, filteredStruct, 'UniformOutput', false);
    endNodes = [endNodes{:}];
    
    allNodes = [startNodes',endNodes'];
    
    % uniqueNodes = unique(allNodes);
    
    % Find unique values and their indices
    [uniqueValues, ~, idx] = unique(allNodes);
    
    % Count occurrences of each unique value
    occurrences = histc(idx, 1:numel(uniqueValues));


    figure(9)
    
    imshow(map);
    alpha(0.3)
    hold on;
    
     % plot houses
    node = ismember(houseList.target_collider_name,uniqueValues);
    
    x = houseList.transformed_collidercenter_x(node);
    y = houseList.transformed_collidercenter_y(node);
    
    
    plotty9 = scatter(x,y, 20, occurrences,'filled');
    
    colorbar    
    set(gca,'xdir','normal','ydir','normal')
    
    hold off
    
    
    ax = gca;
    exportgraphics(ax,strcat(savepath, num2str(index9), '_endDiameter_Buildings_map.png'),'Resolution',600)


    % next plot
    figure(10)
    imshow(map);
    alpha(0.3)
    hold on;


   for ee = 1:height(allNodes)

        [Xhouse,Xindex] = ismember(allNodes{ee,1},houseList.target_collider_name);
    
        [Yhouse,Yindex] = ismember(allNodes{ee,2},houseList.target_collider_name);
    
        x1 = houseList.transformed_collidercenter_x(Xindex);
        y1 = houseList.transformed_collidercenter_y(Xindex);
        
        x2 = houseList.transformed_collidercenter_x(Yindex);
        y2 = houseList.transformed_collidercenter_y(Yindex);
    
        line([x1,x2],[y1,y2],'Color','k','LineWidth',0.001,'LineStyle',':'); 
    
    
    end

    % plot houses
    node = ismember(houseList.target_collider_name,uniqueValues);
    
    x = houseList.transformed_collidercenter_x(node);
    y = houseList.transformed_collidercenter_y(node);

    plotty10 = scatter(x,y, 20, occurrences,'filled');


    colorbar    
    set(gca,'xdir','normal','ydir','normal')
    
    hold off
    
    
    ax = gca;
    exportgraphics(ax,strcat(savepath, num2str(index9), '_endDiameter_Buildings_Paths_map.png'),'Resolution',600)






end




%% 
st7 = [overviewMaxDiameter(is7).StartNode];
st8 = [overviewMaxDiameter(is8).StartNode];
st9 = [overviewMaxDiameter(is9).StartNode];
e7 = [overviewMaxDiameter(is7).EndNode];
e8 = [overviewMaxDiameter(is8).EndNode];
e9 = [overviewMaxDiameter(is9).EndNode];

st7 = struct2table(st7);
st8 = struct2table(st8);
st9 = struct2table(st9);
e9 = struct2table(e9);
e8 = struct2table(e8);
e7 = struct2table(e7);

unique7 = unique([st7;e7]);
unique8 = unique([st8;e8]);
unique9 = unique([st9;e9]);
% 
% isDiff79 = setdiff(unique7, unique9);
% isDiff97 = setdiff(unique9, unique7);
inters79 = intersect(unique7, unique9);
inters78 = intersect(unique7, unique8);
inters98 = intersect(unique9, unique8);

inters7978 = intersect(inters79,inters78);
inters7998 = intersect(inters79, inters98);
inters9878 = intersect(inters98, inters87);



