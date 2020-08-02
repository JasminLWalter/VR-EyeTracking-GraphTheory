%% ------------------ map viewingRadius Version 3-------------------------------------
% script written by Jasmin Walter

clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\viewing_radius\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\'


%houses = {'008_0','007_0', '004_0'};

disp('load data')
% load data

gazes_allParts = load('gazes_allParticipants.mat');
gazes_allParts = gazes_allParts.gazes_allParticipants;
% 
% 
% interpolData_allParts = load('interpolData_allParticipants.mat');
% interpolData_allParts = interpolData_allParts.interpolData_allParticipants;

disp('data loaded')
% load map

map = imread ('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');
% load house list with coordinates

listname = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};

houses = coordinateList.House;

oldListName = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\analysis_visualization_andmore\Version3\OldCoordinateHouseList.txt';
oldcList = readtable(oldListName,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);


%%  transformation - 2 factors (mulitply and additive factor)
xT = 6.05;
zT = 6.1;
xA = -1100;
zA = -3290;




for index = 1:length(houses)
    
    % gazes
    houseName = houses{index};
    houseIndexG = strcmp({gazes_allParts.Collider}, houseName);
    
    positionsG = table;

    positionsG.X = [gazes_allParts(houseIndexG).PosX]'*xT+xA;
    positionsG.Z = [gazes_allParts(houseIndexG).PosZ]'*zT+zA;
    
    % identify house coordinates
    hPoint = ismember(coordinateList.House,houseName);
    xH = coordinateList{hPoint,2};
    yH = coordinateList{hPoint,3};
   

    % display map
    figure(1);
    imshow(map);
    alpha(0.1)
    hold on;
    
    %markerND = centrality(graphy,'degree')';
    plotty = scatter(positionsG.Z, positionsG.X, 5, 'b', 'filled');%,60,markerND,'filled');
    plottyHouse = scatter(xH,yH, 60, 'r', 'filled');%,60,markerND,'filled');
    title(strcat(' H ',houseName,' viewing radius' ),'Interpreter', 'none');
    saveas(gcf, strcat(savepath, houseName, '_viewingRadius.png'));
    hold off;

end
