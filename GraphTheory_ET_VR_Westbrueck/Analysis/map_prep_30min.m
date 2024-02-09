%% ------------------ map_prep_M----------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all

savepath= 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\map prep 30 min\';

savepath30minPlots = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\walkingPaths_30min_individual\';
savepath150minPlots = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\walkingPaths_150min_individual\';
savepathWPD = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\walkingPathDensity\';

imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

%  path to the overviewNodeDegree file created when running script nodeDegree_createOverview_V3
landmarkspath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\';

% location of file containing all gaze data and all interpolated of all participants
cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\'

pathAllParts = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\walkingPaths_triangulation\';


% load map

map_flipped = imread (strcat(imagepath,'map_natural_white_flipped.png'));
map_normal = imread (strcat(imagepath,'map_natural_white.png'));


% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);

%% define grid and do hist count
[rows, columns, numberOfColorChannels] = size(map_flipped);

%calculate additive factor to match coordinates to map image
additiveF = rows/2;
multipFactor = 4.15;



% load count matrix


countMatrix = load('countMatrix_timeSpend_150min.mat');
countMatrix = countMatrix.countMatrix_timeSpend_150min;
countMatrixSum = sum(countMatrix,3);


% 150 min
findzeros = countMatrixSum(:,:)==0;
countMatrixSum(findzeros) = 0;
countMatrixSum(~findzeros) = 1;%0.6;
alphaD = countMatrixSum';



% figure(1)
% imshow(map_normal);
% % alpha(0.3)
% hold on
% 
% plotty1 = imagesc([1,rows],[columns,1],countMatrixSum','AlphaData', alphaD);
% colorbar
% title(strcat("count matrix 150 min"))
% 
% hold off

newArea = countMatrixSum;
newArea(135:end, :) = 2;
newArea(130:135, 1:115) = 2;
newArea(125:130, 1:110) = 2;
newArea(120:125, 1:105) = 2;
newArea(110:120, 1:100) = 2;
newArea(100:110, 1:90) = 2;
newArea(95:100, 1:85) = 2;
newArea(1:95, 1:78) = 2;
newArea(50:60, 1:90) = 2;

newArea(131:135, 136:end) = 2;
newArea(128:131, 140:end) = 2;
newArea(125:128, 150:end) = 2;
newArea(122:125, 165:end) = 2;


newArea(1:50, 110:end) = 2;
newArea(50:55, 115:end) = 2;
newArea(55:60, 120:end) = 2;

newArea(60:65, 125:160) = 2;
newArea(65:70, 130:160) = 2;
newArea(70:75, 135:155) = 2;
newArea(75:80, 140:150) = 2;
newArea(80:84, 143:148) = 2;

newArea(1:85, 148:end) = 2;
newArea(85:95, 155:end) = 2;
newArea(95:135, 165:end) = 2;

newArea(60:100, 1:90) = 2; %(last bit)

figure(2)
imshow(map_normal);
% alpha(0.3)
hold on

plotty2 = imagesc([1,rows],[columns,1],newArea','AlphaData', alphaD);

sum_totalArea150min = sum(countMatrixSum == 1,'all');
sum_newArea = sum(newArea == 1,'all');
percentageNewArea = sum_newArea/sum_totalArea150min;

% disp(sum_newArea)
% disp(sum_totalArea150min)
% disp(sum_newArea/sum_totalArea150min)


title(strcat("new area marked equals ",num2str(percentageNewArea*100), "% of original walkable area"))
hold off

saveas(gcf, strcat(savepath, 'map_newArea_marked.fig'));
saveas(gcf, strcat(savepath, 'map_newArea_marked.png'));



%% go even smaller to 20%
newArea2 = newArea;

newArea2(1:65, 1:160) = 2;
newArea2(65:80, 1:100) = 2;
newArea2(80:82, 1:97) = 2;

figure(3)
imshow(map_normal);
% alpha(0.3)
hold on

plotty3 = imagesc([1,rows],[columns,1],newArea2','AlphaData', alphaD);




sum_totalArea150min = sum(countMatrixSum == 1,'all');
sum_newArea = sum(newArea2 == 1,'all');
percentageNewArea = sum_newArea/sum_totalArea150min;

disp(sum_newArea)
disp(sum_totalArea150min)
disp(sum_newArea/sum_totalArea150min)



title(strcat("new area marked equals ",num2str(percentageNewArea*100), "% of original walkable area"))
hold off

saveas(gcf, strcat(savepath, 'map_newArea2_marked.fig'));
saveas(gcf, strcat(savepath, 'map_newArea2_marked.png'));


