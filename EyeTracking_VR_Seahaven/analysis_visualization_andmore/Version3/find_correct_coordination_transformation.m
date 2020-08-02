%% ------------------ find_correct_coordinate transformation Version 3-------------------------------------
% script written by Jasmin Walter

clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\'


%houses = {'008_0','007_0', '038_0','201_3','188_6'};

% disp('load data')
% % load data
% 
% gazes_allParts = load('gazes_allParticipants.mat');
% gazes_allParts = gazes_allParts.gazes_allParticipants;
% 
% 
% interpolData_allParts = load('interpolData_allParticipants.mat');
% interpolData_allParts = interpolData_allParts.interpolData_allParticipants;
% 
% disp('data loaded')
% load map

map = imread ('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');

% load house list with coordinates

listname = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
cList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
cList.Properties.VariableNames = {'House','X','Y'};

oldListName = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\analysis_visualization_andmore\Version3\OldCoordinateHouseList.txt';
oldcList = readtable(oldListName,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);


startX = (455.0700);%*(-10.1626))+4466.3736;
startZ = (735.5200);%*(-3.5378))+2615.1315;
%overviewNrgazes = struct;

%    % display map
%     figure(1)
%     imshow(map);
%     alpha(0.5)
%     hold on;
%     
%     testPlotty = scatter(startX,startZ,'g', 'filled');


%for index = 1:length(houses)
    

%     houseName = houses{index};
%     % gazes
%     %houseName = houses{index};
%     houseIndex = strcmp(cList.House, houseName);
%     oldhouseIndex = strcmp(oldcList.Var1, houseName);
%     
%     x = cList{houseIndex,2};
%     y = cList{houseIndex,3};
%     oldx1 = (oldcList{oldhouseIndex,2}*2.64);%(-10.1626))+4466.3736;
%     oldy1 = (oldcList{oldhouseIndex,3}*2.26);%(-3.5378))+2615.1315;
%     oldx2 = oldcList{oldhouseIndex,2};%-180;
%     oldy2 = oldcList{oldhouseIndex,3};%-535;
    oldx1 = (oldcList{:,2}*2.64);%(-10.1626))+4466.3736;
    oldy1 = (oldcList{:,3}*2.26);%(-3.5378))+2615.1315;
    oldx2 = oldcList{:,2};
    oldy2 = oldcList{:,3};


    
    
    figure(2)
    mapOld = imread('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\map5.png'); 
    map2 = imresize(mapOld,[500 450]);
    
%     % mapC = map;
    imshow(map2);
    alpha(0.5)
    hold on;
    plotty3 = scatter(oldx2,oldy2, 'b', 'filled');%,60,markerND,'filled');
    hold off

    figure(3)
    map3 = imrotate(map2,90);
    imshow(map3);
    alpha(0.5)
    hold on;
    plotty4 = scatter(oldx2,oldy2, 'b', 'filled');%,60,markerND,'filled');
    hold off

    
    map4 = imresize(mapOld,[500*1.7 450*1.7]);
    map4 = imrotate(map4, 90);
    map4 = flip(map4 ,1);
    
    figure(4)
    imshow(map4);
    alpha(0.5)
    hold on;
    plotty5 = scatter(oldx2,oldy2, 'b', 'filled');%,60,markerND,'filled');
    hold off
    
    map5 = imresize(mapOld,[500 450]);
    map5 = imrotate(map5, 90);
    map5 = flip(map5 ,1);
    
    figure(5)
    imshow(map5);
    alpha(0.5)
    hold on;
    plotty6 = scatter(oldx2,oldy2, 'b', 'filled');%,60,markerND,'filled');
    hold off


%end










