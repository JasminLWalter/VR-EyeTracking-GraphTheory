%% ------------------- checkNewTaskBuildings_ND_MP.m-------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

%% adjust the following variables: savepath and current folder!-----------

savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\map prep 30 min\';

imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location


cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\'

%--------------------------------------------------------------------------

overviewDegree= load('Overview_NodeDegree.mat');

overviewDegree= overviewDegree.overviewNodeDegree;
%% calculate mean over houses and sort table according to ascending mean ND of each house

meanNDofHouses = mean(overviewDegree{:,2:end},2);

% sort overview based on mean value of each house (sort columns)

overviewDegree.meanOfHouses = meanNDofHouses;

sortedbyH = sortrows(overviewDegree,'meanOfHouses');

%% sort overview based on mean value of each participant and arrange columns accordingly (ascending)
meanNDofParticipants = mean(sortedbyH{:,2:end-1});

columnN = sortedbyH.Properties.VariableNames;

partT = [array2table(meanNDofParticipants'),cell2table(columnN(2:end-1)','VariableNames',{'names'})];
sortPT = sortrows(partT,'Var1','descend');

sParts = sortPT{:,2};

sortedbyParts = sortedbyH;
for index = 1:length(sParts)  
    position = index+1;
    sortedbyParts = movevars(sortedbyParts,sParts(index),'before',position);
    
end

columnN2 = sortedbyParts.Properties.VariableNames;
sortedbyHP = [sortedbyParts; table({'meanOfPart'},'VariableNames',columnN2(1)), array2table(sortPT{:,1}','VariableNames',columnN2(2:end-1)),table(NaN,'VariableNames',columnN2(end))];


%% create plots with error bars

% calculate and add std to overviews:

stdNDofHouses = std(sortedbyHP{1:end-1,2:end-1},0,2);
stdNDofParts = std(sortedbyHP{1:end-1,2:end-1});

sortedbyHP.stdOfHouses = [stdNDofHouses;NaN];
stdNDofParts = [stdNDofParts, NaN,NaN];

columnN3 = sortedbyHP.Properties.VariableNames;

sortedbyHP = [sortedbyHP;table({'stdOfParts'},'VariableNames',columnN3(1)),array2table(stdNDofParts,'VariableNames',columnN3(2:end))];

% create error bar plots

tbIndex = zeros([height(sortedbyHP),1]);

%% identify new task building selection (4 buildings)

tbIndex = zeros([height(sortedbyHP),1]);

for index =  [31 34 41 43]
    
    taskB = strcat('TaskBuilding_', num2str(index));
    locTB = strcmp(sortedbyHP.houseNames,taskB);
    tbIndex = tbIndex | locTB;
end

sortedbyHP.IndexTaskBuildingsP2B = tbIndex;
typeBuilding = categorical(tbIndex(1:end-2,:),logical([1 0]),{'TaskBuilding','Building'});


figure(1)
x = [1:244];
for index = 1:244
    if (tbIndex(index) == 1)
        color = [0.4660 0.6740 0.1880];
        plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);

        text(x(index),-3,sortedbyHP.houseNames(index), 'interpreter', 'none','Rotation',90);
%     elseif (index == 5)
%         
%          color = [255 20 20];
%     
%     elseif (index == 39)
%         
%          color = [255 227 20];
%     
%     elseif (index == 41)
%         
%          color = [115 255 20];
%          
%     elseif (index == 42)
%         
%          color = [20 255 250];
         
    else
        color = [0.75 0.75 0.75];
        plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);


    end
     
    hold on
end

xlabel('houses')
ylabel('node degree')
xlim([-1 246])
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
% hold on

plotty2a = plot(sortedbyHP.meanOfHouses(1:end-2)','b','Linewidth',2);


hold off

% saveas(gcf,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings'));
% ax = gca;
% exportgraphics(ax,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings_600dpi.png'),'Resolution',600)

%% next plot - all available task buildings in new area
tbIndex = zeros([height(sortedbyHP),1]);

for index =  [5,31,33,34,35,39,40,41,42,43,44,47]
    
    taskB = strcat('TaskBuilding_', num2str(index));
    locTB = strcmp(sortedbyHP.houseNames,taskB);
    tbIndex = tbIndex | locTB;
end

sortedbyHP.IndexTaskBuildingsP2B = tbIndex;
typeBuilding = categorical(tbIndex(1:end-2,:),logical([1 0]),{'TaskBuilding','Building'});


figure(2)
x = [1:244];
for index = 1:244
    if (tbIndex(index) == 1)
        color = [0.4660 0.6740 0.1880];
        plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);

        text(x(index),-3,sortedbyHP.houseNames(index), 'interpreter', 'none','Rotation',90);
%     elseif (index == 5)
%         
%          color = [255 20 20];
%     
%     elseif (index == 39)
%         
%          color = [255 227 20];
%     
%     elseif (index == 41)
%         
%          color = [115 255 20];
%          
%     elseif (index == 42)
%         
%          color = [20 255 250];
         
    else
        color = [0.75 0.75 0.75];
        plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);


    end
     
    hold on
end

xlabel('houses')
ylabel('node degree')
xlim([-1 246])
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
% hold on

plotty2a = plot(sortedbyHP.meanOfHouses(1:end-2)','b','Linewidth',2);


hold off

% saveas(gcf,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings'));
% ax = gca;
% exportgraphics(ax,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings_600dpi.png'),'Resolution',600)





%% original 8 task buildings with names
tbIndex = zeros([height(sortedbyHP),1]);

for index =  [1,2,3,4,5,6,7,8]
    
    taskB = strcat('TaskBuilding_', num2str(index));
    locTB = strcmp(sortedbyHP.houseNames,taskB);
    tbIndex = tbIndex | locTB;
end

sortedbyHP.IndexTaskBuildingsP2B = tbIndex;
typeBuilding = categorical(tbIndex(1:end-2,:),logical([1 0]),{'TaskBuilding','Building'});


figure(3)
x = [1:244];
for index = 1:244
    if (tbIndex(index) == 1)
        color = [0.4660 0.6740 0.1880];
        plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);

        text(x(index),20,sortedbyHP.houseNames(index), 'interpreter', 'none','Rotation',90);
%     elseif (index == 5)
%         
%          color = [255 20 20];
%     
%     elseif (index == 39)
%         
%          color = [255 227 20];
%     
%     elseif (index == 41)
%         
%          color = [115 255 20];
%          
%     elseif (index == 42)
%         
%          color = [20 255 250];
         
    else
        color = [0.75 0.75 0.75];
        plotty2 = errorbar(x(index), sortedbyHP.meanOfHouses(index), sortedbyHP.stdOfHouses(index),'b','Linewidth',2.5, 'Color',color,'CapSize',0);


    end
     
    hold on
end

xlabel('houses')
ylabel('node degree')
xlim([-1 246])
ax = gca;
ax.XTick = 0:10:244;
ax.TickDir = 'out';
ax.XMinorTick = 'on';
ax.XAxis.MinorTickValues = 1:1:244;
% hold on

plotty2a = plot(sortedbyHP.meanOfHouses(1:end-2)','b','Linewidth',2);


hold off

% saveas(gcf,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings'));
% ax = gca;
% exportgraphics(ax,strcat(savepath,'TaskBuildings_MeanND_StdError_AllBuildings_600dpi.png'),'Resolution',600)





%% plot the original 8 task buildings on map and color code them according to their mean node degree

% load map

% map = imread (strcat(imagepath,'map_natural_white_flipped.png'));
map = imread ('F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\map prep 30 min\map_newArea2_marked_flipped.png');


% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);



% plot 1 - task buildings on map

original8TaskBuildings = {'TaskBuilding_1';'TaskBuilding_2';'TaskBuilding_3';'TaskBuilding_4';'TaskBuilding_5';'TaskBuilding_6';'TaskBuilding_7';'TaskBuilding_8'};
newTaskBuildings = {'TaskBuilding_5';'TaskBuilding_39';'TaskBuilding_41';'TaskBuilding_42'};

node = ismember(houseList.target_collider_name,original8TaskBuildings);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);

x = x*(710/4096);
y = y*(710/4096);

% display map
figure(10)
imshow(map);
alpha(0.2)
hold on;

plotty10 = scatter(x, y,'filled');

set(gca,'xdir','normal','ydir','normal')
title('Original 8 Task Buildings in Westbrook')
saveas(gcf,strcat(savepath,'original8_taskBuildings_onMap.png'));

hold off


% now for the new task buildings

node = ismember(houseList.target_collider_name,newTaskBuildings);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);

x = x*(710/4096);
y = y*(710/4096);

% display map
figure(11)
imshow(map);
alpha(0.2)
hold on;

plotty11 = scatter(x, y,'filled');

set(gca,'xdir','normal','ydir','normal')
title('new Task Buildings in Westbrook')
saveas(gcf,strcat(savepath,'new_taskBuildings_onMap.png'));

%% check task building alternatives

newTaskBuildings = {'TaskBuilding_31';'TaskBuilding_34';'TaskBuilding_41';'TaskBuilding_43'};
node = ismember(houseList.target_collider_name,newTaskBuildings);
x = houseList.transformed_collidercenter_x(node);
y = houseList.transformed_collidercenter_y(node);

x = x*(710/4096);
y = y*(710/4096);

% display map
figure(12)
imshow(map);
alpha(0.2)
hold on;

plotty11 = scatter(x, y,'filled');

set(gca,'xdir','normal','ydir','normal')
title('newSelection 31 34 41 43 onMap')
saveas(gcf,strcat(savepath,'newSelection_31,34,41,43_onMap.png'));


% color code the task buildings based on performance as start buildings

locND = ismember(overviewDegree{:,1}, original8TaskBuildings);

colorCode =  overviewDegree{locND,28};

% 
% colorCode = meanSH;
% % 
% % display map
% figure(20)
% imshow(map);
% alpha(0.2)
% hold on;
% 
% plotty20 = scatter(x, y, 50, colorCode, 'filled');
% colormap(parula)
% colorbar
% set(gca,'xdir','normal','ydir','normal')
% title('Task buildings color coded to their mean node degree centrality values')
% 
% saveas(gcf,strcat(savepath,'taskBuildings_meanNodeDegreeCentrality.png'));
% 
% % color code the task buildings based on performance as start buildings
% 
% colorCode = meanTH;
% 
% % display map
% figure(21)
% imshow(map);
% alpha(0.2)
% hold on;
% 
% plotty21 = scatter(x, y, 50, colorCode, 'filled');
% colormap(flipud(parula))
% colorbar
% set(gca,'xdir','normal','ydir','normal')
% title('Task buildings color coded to mean performance as target building')
% 
% saveas(gcf,strcat(savepath,'taskBuildings_meanPerformance_targetBuilding.png'));
% 
% 
% 
% 
% 
% 









