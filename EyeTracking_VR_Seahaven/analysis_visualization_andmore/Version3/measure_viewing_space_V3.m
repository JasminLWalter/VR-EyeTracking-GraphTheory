%% ------------------ measure viewing space Version 3-------------------------------------
% script written by Jasmin Walter

% measures viewing space by applying the same method of richClub_heatmap 
% (divide map with grid and check whether house was visible in grid square,
% also kernel smoothing (2d convolution) is applied)
% counts visibility of houses grid squares and saves them in overview

clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\viewingSpace\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\'


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


%%  transformation of position data to match map coordinates - 2 factors (mulitply and additive factor)
xT = 6.05;
zT = 6.1;
xA = -1100;
zA = -3290;

gazesTF = gazes_allParts;

positions = table;
positions.X = [gazes_allParts.PosX]'*xT+xA;
positions.Z = [gazes_allParts.PosZ]'*zT+zA;

%% define the grid for counting
% define grid and do hist count
[rows, columns, numberOfColorChannels] = size(map);

% % ca 5m x 5m
% edgesRows = linspace(1,rows,100);
% edgesCol = linspace(1,columns,90);

% ca 4m x 4m
edgesRows = linspace(1,rows,125);
edgesCol = linspace(1,columns,112);

%[countMatrix,colEdges,rowEdges] = histcounts2(positions.Z, positions.X, edgesCol,edgesRows);


%% count for each house the number of squares it is visible
overviewVS = table;
overviewVS.House = coordinateList.House;

% fullCount = struct;

for index = 1: height(coordinateList)
        
    houseName = coordinateList.House(index);
    houseIndex = strcmp({gazes_allParts.Collider}, houseName);

    
    [countMatrix,colEdges,rowEdges] = histcounts2(positions.Z(houseIndex), positions.X(houseIndex), edgesCol,edgesRows);
%     fullCount(index).columnEdges = colEdges;
%     fullCount(index).rowEdges = rowEdges;
%     fullCount(index).countMatrix = countMatrix;
 

    % apply kernal smoothing / convolution
    kernel  = [1,1,1;1,1,1;1,1,1];

    convCount = conv2(countMatrix,kernel,'same');
  
    logicalCount = convCount > 0;
 
    sumVS = sum(logicalCount,'all');
    overviewVS.allSessions_VS(index) = sumVS;

end

%% do the same now for each session

sessions = {'Session1','Session2','Session3'};
helper = [];

for indexS = 1:length(sessions)
    
    sessionIdx = strcmp({gazes_allParts.Session}, sessions{indexS});

    for indexH = 1: height(coordinateList)

        houseName = coordinateList.House(indexH);
        houseIndex = strcmp({gazes_allParts.Collider}, houseName);
        
        selection = sessionIdx & houseIndex;

        [countMatrix,colEdges,rowEdges] = histcounts2(positions.Z(selection), positions.X(selection), edgesCol,edgesRows);
        kernel  = [1,1,1;1,1,1;1,1,1];

        convCount = conv2(countMatrix,kernel,'same');

        logicalCount = convCount > 0;

        sumVS = sum(logicalCount,'all');
        helper(indexH,indexS) = sumVS;

    end
end

overviewVS.Session1_VS = helper(:,1);
overviewVS.Session2_VS = helper(:,2);

overviewVS.Session3_VS = helper(:,3);

%% count all grid squares that were possible in VS

helperAll = [];
for indexAP = 2:5

    selecA = 0;
    if indexAP == 2
        selecA = logical(ones(1,length(gazes_allParts)));
    else
        selecA = strcmp({gazes_allParts.Session}, sessions{indexAP-2});
    end

    [countMatrix,colEdges,rowEdges] = histcounts2(positions.Z(selecA), positions.X(selecA), edgesCol,edgesRows);
    kernel  = [1,1,1;1,1,1;1,1,1];

    convCount = conv2(countMatrix,kernel,'same');

    logicalCount = convCount > 0;

    sumAll = sum(logicalCount,'all');
    helperAll = [helperAll, sumAll];

end

overviewVS(end+1,:) = table({'all_gridSquares'},helperAll(1),helperAll(2),helperAll(3),helperAll(4));



save(strcat(savepath,'overview_ViewingSpaceV3.mat'),'overviewVS');