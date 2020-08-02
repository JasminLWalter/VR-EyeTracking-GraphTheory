%% ------------------ position coordinate transformation Version 3-------------------------------------
% script written by Jasmin Walter

%clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\coordinate_transformation\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\'


houses = {'008_0','007_0', '004_0'};

disp('load data')
% load data

gazes_allParts = load('gazes_allParticipants.mat');
gazes_allParts = gazes_allParts.gazes_allParticipants;


interpolData_allParts = load('interpolData_allParticipants.mat');
interpolData_allParts = interpolData_allParts.interpolData_allParticipants;

disp('data loaded')
% load map

map = imread ('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');
% load house list with coordinates

listname = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};

oldListName = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\analysis_visualization_andmore\Version3\OldCoordinateHouseList.txt';
oldcList = readtable(oldListName,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);



for index0 = 1:length(houses)
    
    % gazes
    houseName = houses{index0};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]';
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]';
%     positionsG.X = [gazes_allParts(1:1500).PosX]';
%     positionsG.Z = [gazes_allParts(1:1500).PosZ]';
    
    % interpol

    houseIndexI = strcmp({interpolData_allParts.Collider}, houseName);
    
    positionsI = table;
    positionsI.X = [interpolData_allParts(houseIndexI).PosX]';
    positionsI.Z = [interpolData_allParts(houseIndexI).PosZ]';

    % display map
    figure(index0)
    imshow(map);
    alpha(0.1)
    hold on;
    
    %startPlotty = scatter(startX(1),startZ(1),'g', 'filled');
    %markerND = centrality(graphy,'degree')';
    %plotty0 = scatter(positionsI.X,positionsI.Z, 'g', 'filled');%,60,markerND,'filled');
    plotty = scatter(positionsG.X,positionsG.Z, 5,'b', 'filled');%,60,markerND,'filled');
   
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    plotty2 = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat('H ',houseName,' viewing positions (all participants)' ),'Interpreter', 'none');
    
    %saveas(gcf, strcat(savepath,num2str(index0), 'positionPlot.png'));
%     figure(index+10)
%     map2 = imread('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\map5.png'); 
%     map2 = imresize(map2,[500 450]);
%     % mapC = map;
%     imshow(map2);
%     alpha(0.1)
%     hold on;
%     plotty3 = scatter(positions.X,positions.Z, 'b', 'filled');%,60,markerND,'filled');


end


%% first transformation - mulitply the x z values with 1 factor

startX = interpolData_allParts(1).PosX*2.64;
startZ = interpolData_allParts(1).PosZ*2.26;
overviewNrgazes = struct;


for index = 1:length(houses)
    
    % gazes
    houseName = houses{index};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*2.64;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*2.26;
%     positionsG.X = [gazes_allParts(1:1500).PosX]'*2.64;
%     positionsG.Z = [gazes_allParts(1:1500).PosZ]'*2.26;
    
    % interpol

    houseIndexI = strcmp({interpolData_allParts.Collider}, houseName);
    
    positionsI = table;
    positionsI.X = [interpolData_allParts(houseIndexI).PosX]'*(2.64);
    positionsI.Z = [interpolData_allParts(houseIndexI).PosZ]'*(2.26);
%     positionsI.X = [interpolData_allParts(1:4500).PosX]'*(2.64);
%     positionsI.Z = [interpolData_allParts(1:4500).PosZ]'*(2.26);


    % display map
    figure(index+10)
    imshow(map);
    alpha(0.1)
    hold on;
    
    startPlotty = scatter(startX(1),startZ(1),'g', 'filled');
    %markerND = centrality(graphy,'degree')';
    plotty0 = scatter(positionsI.X,positionsI.Z,10, 'g', 'filled');%,60,markerND,'filled');
    plotty = scatter(positionsG.X,positionsG.Z, 5,'b', 'filled');%,60,markerND,'filled');
   
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    plotty2 = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat('H ',houseName,' viewing positions (all participants)' ),'Interpreter', 'none');
    %saveas(gcf, strcat(savepath,num2str(index+10), 'positionPlot.png'));
    hold off
    
%     figure(index+10)
%     map2 = imread('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\map5.png'); 
%     map2 = imresize(map2,[500 450]);
%     % mapC = map;
%     imshow(map2);
%     alpha(0.1)
%     hold on;
%     plotty3 = scatter(positions.X,positions.Z, 'b', 'filled');%,60,markerND,'filled');

    if(index == 1)
        overviewNrgazes.House =  houseName;
        overviewNrgazes.NrGazes = sum(houseIndexG);
        overviewNrgazes.NrSamples = sum([gazes_allParts(houseIndexG).Samples]);
    else
        overviewNrgazes.House = [overviewNrgazes.House; houseName];
        overviewNrgazes.NrGazes = [overviewNrgazes.NrGazes; sum(houseIndexG)];
        overviewNrgazes.NrSamples = [overviewNrgazes.NrSamples; sum([gazes_allParts(houseIndexG).Samples])];
    end

end


map2 = imrotate(map, 90);
map3 = flip(map2 ,1);

% xT = 2.64;
% zT = 2.26;

%% 2nd transformation - 2 factors (mulitply and additive factor)
xT = 6.05;
zT = 6.1;
xA = -1350;
zA = -3290;
% xA = -1100;
% zA = -3290;
startX = interpolData_allParts(1).PosX*xT+xA;
startZ = interpolData_allParts(1).PosZ*zT+zA;



for index2 = 1:length(houses)
    
    % gazes
    houseName = houses{index2};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;
%     positionsG.X = [gazes_allParts(houseIndexG).PosX]'*2.64;
%     positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*2.26;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;
    
    % interpol

    houseIndexI = strcmp({interpolData_allParts.Collider}, houseName);
    
    positionsI = table;
    positionsI.X = [interpolData_allParts(1:5500).PosX]'*xT+xA;
    positionsI.Z = [interpolData_allParts(1:5500).PosZ]'*zT+zA;

    % display map
    figure(index2+20)
    imshow(map);
    alpha(0.1)
    hold on;
    
    
    %markerND = centrality(graphy,'degree')';
    plotty0 = scatter(positionsI.Z,positionsI.X, 5,'g', 'filled');%,60,markerND,'filled');
    plotty = scatter(positionsG.Z, positionsG.X, 10, 'b', 'filled');%,60,markerND,'filled');
    startPlotty = scatter(startX(1),startZ(1),'y', 'filled');
   
    hPoint = ismember(oldcList.Var1,houseName);
    xHO = oldcList{hPoint,2}*xT+xA;
    yHO = oldcList{hPoint,3}*zT+zA;
    plottyHouse = scatter(xHO,yHO, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat('H ',houseName,' viewing positions (all participants)' ),'Interpreter', 'none');
    %saveas(gcf, strcat(savepath,num2str(index2+20), 'positionPlot.png'));
    

end

%% now with adapted map (flipped and turned)
for index22 = 1:length(houses)
    
    % gazes
    houseName = houses{index22};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;
%     positionsG.X = [gazes_allParts(houseIndexG).PosX]'*2.64;
%     positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*2.26;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;
    
    % interpol

    houseIndexI = strcmp({interpolData_allParts.Collider}, houseName);
    
    positionsI = table;
    positionsI.X = [interpolData_allParts(1:5500).PosX]'*xT+xA;
    positionsI.Z = [interpolData_allParts(1:5500).PosZ]'*zT+zA;

    % display map
    figure(index22+30)
    imshow(map3);
    alpha(0.1)
    hold on;
    
    
    %markerND = centrality(graphy,'degree')';
    plotty0 = scatter(positionsI.X,positionsI.Z, 5,'g', 'filled');%,60,markerND,'filled');
    plotty = scatter(positionsG.X,positionsG.Z, 10, 'b', 'filled');%,60,markerND,'filled');
    startPlotty = scatter(startX(1),startZ(1),'y', 'filled');
   
    hPoint = ismember(oldcList.Var1,houseName);
    xHO = oldcList{hPoint,2}*xT+xA;
    yHO = oldcList{hPoint,3}*zT+zA;
    plottyHouse = scatter(xHO,yHO, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat('H ',houseName,' viewing positions (all participants)' ),'Interpreter', 'none');
    %saveas(gcf, strcat(savepath,num2str(index22+30), 'positionPlot.png'));
    

end


%% correct transformation

allPositions = table;
allPositions.X = [interpolData_allParts.PosX]';%*xT +xA;
allPositions.Z = [interpolData_allParts.PosZ]';%*zT +zA;



% positionTransform= allPositions;
% positionTransform.X = (positionTransform.X - 1500)*(-1);
% positionTransform.Z = (positionTransform.Z - 1350)*(-1);
% 
% q1= ((positionTransform.X > 0) & (positionTransform.Z >0)*(-2))+1;
% q2= ((positionTransform.X > 0) & (positionTransform.Z <0)*(-2))+1;
% q3= ((positionTransform.X < 0) & (positionTransform.Z <0)*(-2))+1;
% q4= ((positionTransform.X < 0) & (positionTransform.Z >0)*(-2))+1;
% 
% 
% positionTransform.Z = positionTransform.Z .* q1;
% positionTransform.X = positionTransform.X .* q2;
% positionTransform.Z= positionTransform.Z .* q3;
% positionTransform.X = positionTransform.X .* q4;

%% flipped 
for index5 = 1:length(houses)
    
    % gazes
    houseName = houses{index5};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;
%     positionsG.X = [gazes_allParts(houseIndexG).PosX]'*2.64;
%     positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*2.26;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;
    
    % interpol

    houseIndexI = strcmp({interpolData_allParts.Collider}, houseName);
    
    %% norm values
    positionsI = table;
    positionsI.X = [interpolData_allParts(1:5500).PosX]'*xT+xA;
    positionsI.Z = [interpolData_allParts(1:5500).PosZ]'*zT+zA;

    positionTransformI= positionsI;
    positionTransformI.X = (positionTransformI.X - 1500);
    positionTransformI.Z = (positionTransformI.Z - 1350);


    %% flipping transformation

    q1= (positionTransformI.X > 0) & (positionTransformI.Z >0);
    q2= (positionTransformI.X > 0) & (positionTransformI.Z <0);
    q3= (positionTransformI.X < 0) & (positionTransformI.Z <0);
    q4= (positionTransformI.X < 0) & (positionTransformI.Z >0);

    positionTransformI{q1,2} = positionTransformI{q1,2}* (-1);
    positionTransformI{q2,2} = positionTransformI{q2,2}* (-1);
    positionTransformI{q3,2} = positionTransformI{q3,2}* (-1);
    positionTransformI{q4,2} = positionTransformI{q4,2}* (-1);

    %% rotating values 90 degrees
%     theta= 90;
     posRotI = positionTransformI;
% 
%     posRotI.X = cosd(theta)*(positionTransformI.X) - sind(theta)*(positionTransformI.Z);
%     posRotI.Z = sind(theta)*(positionTransformI.X) + cosd(theta)*(positionTransformI.Z);
    posRotI.X = posRotI.X + 1350;
    posRotI.Z = posRotI.Z + 1500;
%% same with gazes:
    %% norm values
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;

    positionTransformG= positionsG;
    positionTransformG.X = (positionTransformG.X - 1500);
    positionTransformG.Z = (positionTransformG.Z - 1350);


    %% flipping transformation

    q1= (positionTransformG.X > 0) & (positionTransformG.Z >0);
    q2= (positionTransformG.X > 0) & (positionTransformG.Z <0);
    q3= (positionTransformG.X < 0) & (positionTransformG.Z <0);
    q4= (positionTransformG.X < 0) & (positionTransformG.Z >0);

    positionTransformG{q1,2} = positionTransformG{q1,2}* (-1);
    positionTransformG{q2,2} = positionTransformG{q2,2}* (-1);
    positionTransformG{q3,2} = positionTransformG{q3,2}* (-1);
    positionTransformG{q4,2} = positionTransformG{q4,2}* (-1);

    %% rotating values 90 degrees
%     theta= 90;
     posRotG = positionTransformG;
% 
%     posRotG.X = cosd(theta)*(positionTransformG.X) - sind(theta)*(positionTransformG.Z);
%     posRotG.Z = sind(theta)*(positionTransformG.X) + cosd(theta)*(positionTransformG.Z);
    posRotG.X = posRotG.X + 1350;
    posRotG.Z = posRotG.Z + 1500;
    
    
%% display it on map
    % display map
    figure(index5+100)
    imshow(map2);
    alpha(0.1)
    hold on;
    
    
    %markerND = centrality(graphy,'degree')';
    plotty0 = scatter(posRotI.X,posRotI.Z, 5,'g', 'filled');%,60,markerND,'filled');
    plotty = scatter(posRotG.X,posRotG.Z, 10, 'b', 'filled');%,60,markerND,'filled');
    startPlotty = scatter(posRotI{1,1},posRotI{1,2},'y', 'filled');
   
    %originP= scatter(0,0,'black','filled');
    
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    plottyHouse = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat('H ',houseName,' viewing positions (all participants)' ),'Interpreter', 'none');
   % saveas(gcf, strcat(savepath,num2str(index5+100), 'positionPlot.png'));


end


%% flipped and rotated:
for index3 = 1:length(houses)
    
    % gazes
    houseName = houses{index3};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;
%     positionsG.X = [gazes_allParts(houseIndexG).PosX]'*2.64;
%     positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*2.26;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;
    
    % interpol

    houseIndexI = strcmp({interpolData_allParts.Collider}, houseName);
    
    %% norm values
    positionsI = table;
    positionsI.X = [interpolData_allParts(1:5500).PosX]'*xT+xA;
    positionsI.Z = [interpolData_allParts(1:5500).PosZ]'*zT+zA;

    positionTransformI= positionsI;
    positionTransformI.X = (positionTransformI.X - 1500);
    positionTransformI.Z = (positionTransformI.Z - 1350);


    %% flipping transformation

    q1= (positionTransformI.X > 0) & (positionTransformI.Z >0);
    q2= (positionTransformI.X > 0) & (positionTransformI.Z <0);
    q3= (positionTransformI.X < 0) & (positionTransformI.Z <0);
    q4= (positionTransformI.X < 0) & (positionTransformI.Z >0);

    positionTransformI{q1,2} = positionTransformI{q1,2}* (-1);
    positionTransformI{q2,2} = positionTransformI{q2,2}* (-1);
    positionTransformI{q3,2} = positionTransformI{q3,2}* (-1);
    positionTransformI{q4,2} = positionTransformI{q4,2}* (-1);

    %% rotating values 90 degrees
    theta= 90;
    posRotI = positionTransformI;

    posRotI.X = cosd(theta)*(positionTransformI.X) - sind(theta)*(positionTransformI.Z);
    posRotI.Z = sind(theta)*(positionTransformI.X) + cosd(theta)*(positionTransformI.Z);
    posRotI.X = posRotI.X + 1350;
    posRotI.Z = posRotI.Z + 1500;
%% same with gazes:
    %% norm values
    positionsG = table;
    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;

    positionTransformG= positionsG;
    positionTransformG.X = (positionTransformG.X - 1500);
    positionTransformG.Z = (positionTransformG.Z - 1350);


    %% flipping transformation

    q1= (positionTransformG.X > 0) & (positionTransformG.Z >0);
    q2= (positionTransformG.X > 0) & (positionTransformG.Z <0);
    q3= (positionTransformG.X < 0) & (positionTransformG.Z <0);
    q4= (positionTransformG.X < 0) & (positionTransformG.Z >0);

    positionTransformG{q1,2} = positionTransformG{q1,2}* (-1);
    positionTransformG{q2,2} = positionTransformG{q2,2}* (-1);
    positionTransformG{q3,2} = positionTransformG{q3,2}* (-1);
    positionTransformG{q4,2} = positionTransformG{q4,2}* (-1);

    %% rotating values 90 degrees
    theta= 90;
    posRotG = positionTransformG;

    posRotG.X = cosd(theta)*(positionTransformG.X) - sind(theta)*(positionTransformG.Z);
    posRotG.Z = sind(theta)*(positionTransformG.X) + cosd(theta)*(positionTransformG.Z);
    posRotG.X = posRotG.X + 1350;
    posRotG.Z = posRotG.Z + 1500;
    
    
%% display it on map
    % display map
    figure(index3+200)
    imshow(map);
    alpha(0.1)
    hold on;
    
    
    %markerND = centrality(graphy,'degree')';
    plotty0 = scatter(posRotI.X,posRotI.Z, 5,'g', 'filled');%,60,markerND,'filled');
    plotty = scatter(posRotG.X,posRotG.Z, 10, 'b', 'filled');%,60,markerND,'filled');
    startPlotty = scatter(posRotI{1,1},posRotI{1,2},'y', 'filled');
   
    %originP= scatter(0,0,'black','filled');
    
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
    plottyHouse = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat('H ',houseName,' viewing positions (all participants)' ),'Interpreter', 'none');
    %saveas(gcf, strcat(savepath,num2str(index3+200), 'positionPlot.png'));

end
