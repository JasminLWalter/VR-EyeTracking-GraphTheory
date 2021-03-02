%% ------------------ walking heatmap_individual_ Version 3-------------------------------------
% script written by Jasmin Walter

clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\all_participants\position\walking_heatmaps\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\gazes_vs_noise\'


%houses = {'008_0','007_0', '004_0'};

disp('load data')
% load data
% gazes_allParts = load('gazes_allParticipants.mat');
% gazes_allParts = gazes_allParts.gazes_allParticipants;
gazes = load('35_gazes_data_V3.mat');
gazes = gazes.gazedObjects;


disp('data loaded')

% load map

map = imread ('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\Map_Houses_SW2.png');
% load house list with coordinates

listname = 'C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\CoordinateListNew.txt';
coordinateList = readtable(listname,'delimiter',{':',';'},'Format','%s%f%f','ReadVariableNames',false);
coordinateList.Properties.VariableNames = {'House','X','Y'};





%%  transformation - 2 factors (mulitply and additive factor)
xT = 6.05;
zT = 6.1;
xA = -1100;
zA = -3290;



%% rich club

positions.X = [gazes.PosX]'*xT+xA;
positions.Z = [gazes.PosZ]'*zT+zA;


% define grid and do hist count
[rows, columns, numberOfColorChannels] = size(map);

% % ca 5m x 5m
% edgesRows = linspace(1,rows,100);
% edgesCol = linspace(1,columns,90);

% ca 4m x 4m
edgesRows = linspace(1,rows,125);
edgesCol = linspace(1,columns,112);

[countMatrix,colEdges,rowEdges] = histcounts2(positions.Z, positions.X, edgesCol,edgesRows);
% 
% % plot countMatrix
% figure(3);
% imshow(map);
% %alpha(0.1)
% 
% hold on
% plottyT = imagesc(colEdges,rowEdges,countMatrix', 'AlphaData', 0.7);
% colorbar
% 
% figure(4)
% imshow(map)
% figure(5)
% plottyT = imagesc(colEdges,rowEdges,countMatrix', 'AlphaData', 0.7);
% 
% figure(6)
% imshow(map);
% alpha(0.1)
% hold on
% scatty = scatter(positions10.Z, positions10.X, 4, 'filled');
% 

% apply kernal smoothing / convolution
kernel  = [1,1,1;1,1,1;1,1,1];
convCount = countMatrix;



convCount = conv2(convCount,kernel,'same');

alpha = convCount';
zeros = alpha(:,:)==0;
alpha(:,:) = 0.7;
alpha(zeros) = 0;


% % plot the summed matrix
% testi = countMatrix==19876;
% countMatrix(testi)=0;

figure(1)
imshow(map);
hold on
plotty1 = imagesc(colEdges,rowEdges,convCount', 'AlphaData', 0.7);
colormap jet
colorbar
title('walking heatmap - all participants');
saveas(gcf, strcat(savepath, 'walking_heatmap_indv.png'));
hold off

%% session1

session1 = strcmp({gazes.Session}, 'Session1');

sess1D = gazes(session1);

positions1.X = [sess1D.PosX]'*xT+xA;
positions1.Z = [sess1D.PosZ]'*zT+zA;

[countMatrix1,colEdges,rowEdges] = histcounts2(positions1.Z, positions1.X, edgesCol,edgesRows);
convCount1 = countMatrix1;



convCount1 = conv2(convCount1,kernel,'same');

figure(2)
imshow(map);
hold on
plotty2 = imagesc(colEdges,rowEdges,convCount1', 'AlphaData', 0.7);
colormap jet
colorbar
title('walking heatmap - session 1');

saveas(gcf, strcat(savepath, 'walking_heatmap_indv_session1.png'));
hold off
%% session2

session2 = strcmp({gazes.Session}, 'Session2');

sess2D = gazes(session2);

positions2.X = [sess2D.PosX]'*xT+xA;
positions2.Z = [sess2D.PosZ]'*zT+zA;

[countMatrix2,colEdges,rowEdges] = histcounts2(positions2.Z, positions2.X, edgesCol,edgesRows);
convCount2 = countMatrix2;
convCount2 = conv2(convCount2,kernel,'same');

figure(3)
imshow(map);
hold on
plotty3 = imagesc(colEdges,rowEdges,convCount2', 'AlphaData', 0.7);
colormap jet
colorbar
title('walking heatmap - session 2');

saveas(gcf, strcat(savepath, 'walking_heatmap_indv_session2.png'));
hold off

%% session3

session3 = strcmp({gazes.Session}, 'Session3');

sess3D = gazes(session3);

positions3.X = [sess3D.PosX]'*xT+xA;
positions3.Z = [sess3D.PosZ]'*zT+zA;

[countMatrix3,colEdges,rowEdges] = histcounts2(positions3.Z, positions3.X, edgesCol,edgesRows);
convCount3 = countMatrix3;



convCount3 = conv2(convCount3,kernel,'same');

figure(4)
imshow(map);
hold on
plotty3 = imagesc(colEdges,rowEdges,convCount3', 'AlphaData', 0.7);
colormap jet
colorbar
title('walking heatmap - session 3');

saveas(gcf, strcat(savepath, 'walking_heatmap_indv_session3.png'));
hold off


%%

h1(:,1)= rowEdges';
h1(:,2) = 0;

h2(:,1)= rowEdges';
h2(:,1)= rowEdges';
% bin plot
figure(12)
imshow(map);
% xticks(colEdges)
% yticks(rowEdges)
% grid minor


% [rows, columns, numberOfColorChannels] = size(map);

stepSize = 30; % Whatever you want.
for row = 1 : length(rowEdges)
    line([1, 2700], [rowEdges(row), rowEdges(row)], 'Color', 'r', 'LineWidth', 0.1);
end
for col = 1 : length(colEdges)
    line([colEdges(col), colEdges(col)], [1, 3000], 'Color', 'r', 'LineWidth', 0.1);
end
%saveas(gcf, strcat(savepath, 'grid size_vibility plots.png'));
