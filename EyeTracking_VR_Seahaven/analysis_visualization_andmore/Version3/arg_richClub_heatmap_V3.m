%% ------------------ rich club heatmap Version 3-------------------------------------
% script written by Jasmin Walter

% clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\'


%houses = {'008_0','007_0', '004_0'};

disp('load data')
% load data
% 
% gazes_allParts = load('gazes_allParticipants.mat');
% gazes_allParts = gazes_allParts.gazes_allParticipants;

disp('data loaded')

% load map

map = imread ('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');
% load house list with coordinates

listname = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};



overviewNodeDegree = load('E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree\Overview_NodeDegree.mat');
overviewNodeDegree = overviewNodeDegree.overviewNodeDegree; 

overviewNodeDegree.Mean = mean(overviewNodeDegree{:,2:end},2);
overviewSorted = sortrows(overviewNodeDegree, 'Mean', 'ascend');


%%  transformation - 2 factors (mulitply and additive factor)
xT = 6.05;
zT = 6.1;
xA = -1100;
zA = -3290;



%% rich club


RCHouseList = readtable("E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\RC_HouseList.csv");

sortedRCL = sortrows(RCHouseList,'RCCount','ascend');

housesTop10RC = sortedRCL{end-9:end,1};

houseIndex10 = ismember({gazes_allParts.Collider}, housesTop10RC);
positions10 = table;
positions10.X = [gazes_allParts(houseIndex10).PosX]'*xT+xA;
positions10.Z = [gazes_allParts(houseIndex10).PosZ]'*zT+zA;


% define grid and do hist count
[rows, columns, numberOfColorChannels] = size(map);

edgesRows = linspace(1,rows,100);
edgesCol = linspace(1,columns,90);

[countMatrix,colEdges,rowEdges] = histcounts2(positions10.Z, positions10.X, edgesCol,edgesRows);

% plot countMatrix
figure(3);
imshow(map);
%alpha(0.1)

hold on
plottyT = imagesc(colEdges,rowEdges,countMatrix', 'AlphaData', 0.7);
colorbar

figure(4)
imshow(map)
figure(5)
plottyT = imagesc(colEdges,rowEdges,countMatrix', 'AlphaData', 0.7);

figure(6)
imshow(map);
alpha(0.1)
hold on
scatty = scatter(positions10.Z, positions10.X, 4, 'filled');


%% now the real thing
fullCount = struct;

for index = 1:length(housesTop10RC)
        
    houseName = housesTop10RC{index};
    houseIndex = strcmp({gazes_allParts.Collider}, houseName);
    positions = table;
    positions.X = [gazes_allParts(houseIndex).PosX]'*xT+xA;
    positions.Z = [gazes_allParts(houseIndex).PosZ]'*zT+zA;
    
    [countMatrix,colEdges,rowEdges] = histcounts2(positions.Z, positions.X, edgesCol,edgesRows);
    fullCount(index).columnEdges = colEdges;
    fullCount(index).rowEdges = rowEdges;
    fullCount(index).countMatrix = countMatrix;
 
end

logicalCount = fullCount;

for index2 = 1:length(fullCount)

    logicalCount(index2).countMatrix = fullCount(index2).countMatrix > 0;
 
end

logicalCell = struct2cell(logicalCount);

logical3D = [];

for index3 = 1:length(fullCount)
    logical3D(:,:,index3) = logicalCell{3,1,index3};
    
end


sumAll = sum(logical3D,3);

% plot the summed matrix


figure(10)
imshow(map);
hold on
plotty10 = imagesc(colEdges,rowEdges,sumAll', 'AlphaData', 0.7);
colorbar
hold off

%% final aspect - only display 0,1,2,3 or more

more3 = sumAll >= 3;

sumAll3cut = sumAll;
sumAll3cut(more3) = 3;


figure(11)
imshow(map);
hold on
plotty11 = imagesc(colEdges,rowEdges,sumAll3cut', 'AlphaData', 0.7);
colormap(parula(4));
colorbar('Ticks',[0.4,1.1,1.9,2.6], 'TickLabels',{'0 houses','1 house','2 houses','3 or more houses'})
title('visibility of top 10 houses rich clu
hold off

% figure(12)
% imshow(map);
% hold on
% plotty12 = pcolor(colEdges,rowEdges,sumAll3cut');
% 
% hold off


% %
% display map
% figure(3);
% imshow(map);
% alpha(0.1)
% hold on;
% hold on;
% [rows, columns, numberOfColorChannels] = size(map);
% 
% stepSize = 30; % Whatever you want.
% for row = 1 : stepSize : rows
%     line([1, columns], [row, row], 'Color', 'r', 'LineWidth', 0.1);
% end
% for col = 1 : stepSize : columns
%     line([col, col], [1, rows], 'Color', 'r', 'LineWidth', 0.1);
% end
% 
% gridMatrix = zeros(100,90);
% 
% 
% 
% 
% colour = [0.24,0.15,0.66;
% 0.28,0.25,0.89;
% 0.18,0.51,0.98;
% 0.14,0.63,0.90;
% 0.01,0.72,0.80;
% 0.18,0.77,0.64;
% 0.40,0.80,0.42;
% 0.40,0.80,0.42;
% 0.96,0.73,0.23;
% 0.97,0.85,0.17];
% 
% 
% 
%         
%     houseName = housesTop5RC{index3};
%     houseIndexG = ismember({gazes_allParts.Collider}, housesTop10RC);
%     positionsG = table;
%     positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
%     positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;
% 
%     plotty = HeatMap('Z', 'X');% 4, colour(index3,:), 'filled');%,60,markerND,'filled');   
%     saveas(gcf, strcat(savepath, houseName, '_viewingRadius.png'));
%  hold off
%  
%  
% figure(5)
% testi = histogram2(positionsG.Z,positionsG.X);
% 
% 
% nbins = [100 90];
% 
% [N,Xedges,Yedges] = histcounts2(positionsG.Z, positionsG.X,nbins);
% 
% figure(6)
% 
% display map
% imshow(map);
% alpha(0.1)
% 
% figure(7)
% plottyT = imagesc(Xedges*stepSize,Yedges*stepSize,N);
% colorbar
% 
% for index4 = 1:length(housesTop10RC)
%     
%     houseName = housesTop10RC{index4};
%     hPoint = ismember(coordinateList.House,houseName);
%     xH = coordinateList{hPoint,2};
%     yH = coordinateList{hPoint,3};
%     
%     plottyHouse = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
%     text(xH+25,yH,houseName,'interpreter','none', 'fontsize',13);
%     title('viewing radius top 5 houses with highest rich club count ','Interpreter', 'none');
% 
%     
% end
% 
% saveas(gcf, strcat(savepath, 'top5_houses_richClub_viewingRadius.png'));

