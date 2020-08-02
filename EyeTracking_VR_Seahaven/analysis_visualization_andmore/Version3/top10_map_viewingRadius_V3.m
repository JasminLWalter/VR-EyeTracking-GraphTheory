%% ------------------ map viewingRadius Version 3-------------------------------------
% script written by Jasmin Walter

clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\'


%houses = {'008_0','007_0', '004_0'};

disp('load data')
% load data
% 
gazes_allParts = load('gazes_allParticipants.mat');
gazes_allParts = gazes_allParts.gazes_allParticipants;

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

%% node degree top 4

housesTop4 = overviewSorted{end-3:end,1};
colours = [0.24,0.15,0.66; 0.14,0.63,0.90; 0.40,0.80,0.42 ;0.97,0.85,0.17 ];

% display map
figure(1);
imshow(map);
alpha(0.1)
hold on;

for index = 1:length(housesTop4)
    
     
    houseName = housesTop4{index};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;

    plotty = scatter(positionsG.Z, positionsG.X, 4, colours(index,:), 'filled');%, 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);%,60,markerND,'filled');   
    %saveas(gcf, strcat(savepath, houseName, '_viewingRadius.png'));
    
end


for index2 = 1:length(housesTop4)
    
    houseName = housesTop4{index2};
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    
    plottyHouse = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    text(xH+25,yH,houseName,'interpreter','none', 'fontsize',13);
    title('viewing radius top 4 houses with highest node degree ','Interpreter', 'none');

    
end

saveas(gcf, strcat(savepath, 'top4_houses_nodeDegree_viewingRadius.png'));

hold off

%% houses top 10
housesTop10 = overviewSorted{end-9:end,1};
colour10 = [0.24,0.15,0.66;
0.28,0.25,0.89;
0.18,0.51,0.98;
0.14,0.63,0.90;
0.01,0.72,0.80;
0.18,0.77,0.64;
0.40,0.80,0.42;
0.40,0.80,0.42;
0.96,0.73,0.23;
0.97,0.85,0.17];

% display map
figure(10);
imshow(map);
alpha(0.1)
hold on;

for index10 = 1:length(housesTop10)
    
     
    houseName = housesTop10{index10};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;

    plotty10 = scatter(positionsG.Z, positionsG.X, 4, colour10(index10,:), 'filled');%, 'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.2);%,60,markerND,'filled');   
        %saveas(gcf, strcat(savepath, houseName, '_viewingRadius.png'));
    
end


for index11 = 1:length(housesTop10)
    
    houseName = housesTop10{index11};
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    
    plottyHouse10 = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    text(xH+25,yH,houseName,'interpreter','none', 'fontsize',13);
    title('viewing radius top 10 houses with highest node degree ','Interpreter', 'none');

    
end

saveas(gcf, strcat(savepath, 'top10_houses_nodeDegree_viewingRadius.png'));

hold off

%% rich club

RCHouseList = readtable("E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\top10_houses\RC_HouseList.csv");

sortedRCL = sortrows(RCHouseList,'RCCount','descend');

housesTop5RC = sortedRCL{1:5,1};
colRC = {'b','c','g','y','m'};
% display map
figure(2);
imshow(map);
alpha(0.1)
hold on;

for index3 = 1:length(housesTop5RC)
        
    houseName = housesTop5RC{index3};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;

    plotty = scatter(positionsG.Z, positionsG.X, 4, colRC{index3}, 'filled');%,60,markerND,'filled');   
    %saveas(gcf, strcat(savepath, houseName, '_viewingRadius.png'));
    
end


for index4 = 1:length(housesTop5RC)
    
    houseName = housesTop5RC{index4};
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    
    plottyHouse = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    text(xH+25,yH,houseName,'interpreter','none', 'fontsize',13);
    title('viewing radius top 5 houses with highest rich club count ','Interpreter', 'none');

    
end

%saveas(gcf, strcat(savepath, 'top5_houses_richClub_viewingRadius.png'));
