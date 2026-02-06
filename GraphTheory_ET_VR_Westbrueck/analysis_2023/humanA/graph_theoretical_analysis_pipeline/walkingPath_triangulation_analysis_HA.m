%% ------------------ walkingPath_triangulation_analysis_HA----------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description:
% Script analyses how many gaze-graph-defined landmarks were viewed from 
% each location participants visited in the city. In addition, it analyses
% how much of the total experiment time participants spend in these areas 
% where the theoretical basis for triangulation would be given. 
% The analysis is performed with a spatial resolution of 4x4m and an 
% additional smoothing with a 3x3 unity kernel. 


% Input: 
% gazes_allParticipants.mat        = data file containing all gazes from all
%                                    participants
%                                    - created when running script...

% interpolData_allParticipants.mat = data file containing all interpolated
%                                    data from all participants
%                                    - created when running script

% Overview_NodeDegree.mat  =  table consisting of all node degree values
%                             for all participants (alternatively the list
%                             of the rich club count for all houses)
%                          
% Map_Houses_New.png       = image of the map of Seahaven 
% CoordinateListNew.txt    = csv list of the house names and x,y coordinates
%                            corresponding to the map of Seahaven


% Output: 
% Figure 1: visibility of top 10 houses - rich club and node degree
% = map plot color coded for all top 10 houses

% Figure 2: Visibility of top 10 houses - rich club & node degree'
% = like figure 1, but here the map is only color coded to differentiate
% areas where 0 top 10 houses, 1 top 10 house, and 2 or more top 10 houses
% were viewed (Fig. 9 of the paper)

% Figure 3: grid size_vibility plots.png
% = visualization of the 4x4 grid dividing the city

% Figure 20: Percentage of possibility to triangulate in walked area
% = pie plot of the percentages of the different city areas participants 
% were located in

% Figure 21: Percentage of times triangulation was possible
% = pie plot of the percentages of experiment time participants spend in
% triangulation areas (same visualization as Figure 20, but different data)

% table_percentage_triangulation.mat
% = table listing the percentages of the areas in the city where participants
% viewed 0, 1, 2 or more houses

% table_times_triangulation_possible.mat
% = table listing the percentage of experiment time participants spend in
% areas where 0, 1, 2 or more houses where visible

clear all;

%% adjust the following variables: 
% savepath, imagepath, clistpath, overviewNDpath and current folder-----------------------

savepath= 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\graph-theoretical-analysis\walkingPaths_triangulation\';


imagepath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location


%  path to the overviewNodeDegree file created when running script nodeDegree_createOverview_V3
landmarkspath = 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\graph-theoretical-analysis\nodeDegree_analysis\';

% location of file containing all gaze data and all interpolated of all participants
cd 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\pre-processing\velocity_based\step3_gazeProcessing\'


%------------------------------------------------------------------------

% load map

map_flipped = imread (strcat(imagepath,'map_natural_white_flipped.png'));
map_normal = imread (strcat(imagepath,'map_natural_white.png'));

% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);


%% load the data of the gaze-graph-defined landmarks
% using the gaze-graph-defined landmarks list

landmarks = readtable(strcat(landmarkspath, 'landmarkOverview.csv'));

%% define grid and do hist count
[rows, columns, numberOfColorChannels] = size(map_flipped);

%calculate additive factor to match coordinates to map image
additiveF = rows/2;
multipFactor = 4.15;

% ca 4m x 4m
% 1 m corresponds to roughly 4.15 pixels in the image
% meaning, 16.6 pixels correspond to about 4 m
% pixel size of image/16.6 is  246.7470, so we have to use 247 squares that
% all have the size of 16.6504 pixels/ 3.9959 m

nrSquares = 247;
edgesRows = linspace(1,rows,nrSquares);
edgesCol = linspace(1,columns,nrSquares);

% if we want to have 4x4 m exact, we need to define one smaller square at 
% the edge of the image (rest square, so we would have 246 regular sauqre
% and one rest square. In this case the rest square at the end would have
% has a size of 12.4 pixesl (2.988 m), but because the plotting later on
% will be very difficult (imgsc would plot the squares regularly scaled) we
% wont do this unequal squares and use the 247 squares of size 3.9959 m
% instead

% sizeSquares = 16.6; % in pixels (= 4 m in the virtual world)

% rows
% edgeEnd = nrSquares*sizeSquares;
% edgesRows = linspace(1,edgeEnd,nrSquares);
% edgesCol = linspace(1,edgeEnd,nrSquares);
% edgesRows = [edgesRows,rows];
% edgesCol = [edgesCol, columns];


% plot applied grid over map
% figure(1)
% imshow(map);
% alpha(0.3)
% hold on
% 
% for row = 1 : length(edgesRows)
%     line([1, rows], [edgesRows(row), edgesRows(row)], 'Color', 'r', 'LineWidth', 0.1);
% end
% for col = 1 : length(edgesCol)
%     line([edgesCol(col), edgesCol(col)], [1, columns], 'Color', 'r', 'LineWidth', 0.1);
% end
% 
% hold off
% set(gca,'xdir','normal','ydir','normal')
% 
% saveas(gcf, strcat(savepath, 'gridSize_4x4_plot'));

%% analysis

% save all walking coordinates
% check area covered for each participant 
% check area covered over all participants

% create density of walking paths plot
% create triangulation plot

% participant data loop
partList = [365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7412 7842 8007 8469 8673 9472 9502 9586 9601];

countMatrix_logical_5sess_150Min = [];
countMatrix_logical_150Min = [];

allData = table;


squares = table;


%% plot the walking path density, so how many participants were in each city area
% plus save the allData variable by concatinating all data files

for indexPart = 1:length(partList)
    tic
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = partList(indexPart);

    countMatrix_allETSess = zeros(length(edgesRows)-1,length(edgesCol)-1);
    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:5
        
        % get eye tracking sessions and loop over them (amount of ET files
        % can vary
        dirSess = dir([num2str(currentPart) '_Session_' num2str(indexSess) '*_data_processed_gazes.csv']);
        

        if isempty(dirSess)
            
            disp('missing session file !!!!!!!!!!!!')
            hMF = table;
            hMF.Participant = currentPart;
            hMF.Session = indexSess;
            missingFiles = [missingFiles; hMF];
        
        else

            % sort the list to be sure
            fileNames = {dirSess.name}';
            fileNames_sorted = sortrows(fileNames, 'ascend');



            %% Main part - runs if files exist!        
            % loop over ET sessions and check data            
            for indexET = 1:length(fileNames_sorted)
                disp(['Process file: ', fileNames_sorted{indexET}]);
                % read in the data
                % data = readtable([num2str(1004) '_Session_1_ET_1_data_correTS_mad_wobig.csv']);
                data = readtable(fileNames_sorted{indexET});
                data.sampleDur = [0;diff(data.timeStampRS)];

                dSelect = table;
               

                dSelect.sampleDur = data.sampleDur;
                dSelect.isFix = data.isFix;
                dSelect.length = data.length;
                dSelect.namesNH = data.namesNH;
                dSelect.hmdPosition_x = data.hmdPosition_x;
                dSelect.hmdPosition_z = data.hmdPosition_z;
                % dSelect.file = repmat(fileNames_sorted{indexET}, height(dSelect), 1);


                allData = [allData; dSelect];
            
                
                %% calculated the visited area 
            
                
                [currentCountMatrix,rowEdges, colEdges, binX, binY] = histcounts2([data.hmdPosition_x]' *multipFactor +additiveF, [data.hmdPosition_z]' *multipFactor +additiveF, edgesRows, edgesCol);
        
                current_coutM_logical = currentCountMatrix;
                isVisited = current_coutM_logical >= 1;
                current_coutM_logical(isVisited) = 1; 
        
                countMatrix_allETSess = countMatrix_allETSess + current_coutM_logical;
            
                
            end
        end
    end

    % add count Matrix to the matrix of all participants
    countMatrix150(:,:,indexPart) = countMatrix_allETSess;


    coutM_logical150 = countMatrix_allETSess;
    isVisited150 = coutM_logical150 >= 1;
    coutM_logical150(isVisited150) = 1; 

    countMatrix_logical_150Min(:,:,indexPart) = coutM_logical150;
    

    toc

end


% transform count matrix to a logical one
bigger1 = countMatrix_logical_150Min ==0;
logical_countM_150 = countMatrix_logical_150Min;
logical_countM_150(not(bigger1)) = 1;
sumCM_150 = sum(logical_countM_150,3);

alphaD = sumCM_150';
findzeros = alphaD(:,:)==0;
alphaD(findzeros) = 0.3;
alphaD(~findzeros) = 1;

figure(8)

imshow(map_normal);
alpha(0.3)
hold on

plotty8 = imagesc([1,rows],[columns,1],sumCM_150','AlphaData', alphaD);
colorbar
hold off
title(strcat("Density of all walking paths of all participants"))

saveas(gcf,strcat(savepath,'Density of all walking paths of all participants.png'));

%% landmark visibility in city areas
% start with: which area was visited by all participants for the
% visualization

countMatrixAll = sum(countMatrix_logical_150Min,3);


% % use this code to apply kernal smoothing / convolution 
% kernel  = [1,1,1;1,1,1;1,1,1];
% convCountAll = countMatrixAll;
% convCountAll = conv2(convCountAll,kernel,'same');
convCountAll = countMatrixAll; % comment line if kernel smoothing is applied)

% get alpha data so that all areas that were not visited in the first place
% can be set to 0 transparency in the plot
alphaDAll = convCountAll';
findzeros = alphaDAll(:,:)==0;
alphaDAll(~findzeros) = 0.6;

% get logical array of grid and how many gaze-graph-defined landmarks 
% were viewed at that location
fullCount = struct;

% only use gazes for this calculation
isGaze = ~isnan(allData.isFix);
gazeData = allData(isGaze,:);

for index = 1:height(landmarks)
        
    houseName = landmarks.houseNames(index);
    houseIndex =  strcmp(gazeData.namesNH,houseName);
    positions = table;
    positions.X = gazeData.hmdPosition_x(houseIndex)*multipFactor + additiveF;
    positions.Z = gazeData.hmdPosition_z(houseIndex)*multipFactor + additiveF;
    
    [countMatrix,colEdges,rowEdges] = histcounts2(positions.X, positions.Z, edgesRows,edgesCol);
    fullCount(index).columnEdges = colEdges;
    fullCount(index).rowEdges = rowEdges;
    fullCount(index).countMatrix = countMatrix;
 
end

% apply kernal smoothing / convolution
% kernel  = [1,1,1;1,1,1;1,1,1];
% convCount = fullCount; 


% for index11 = 1:length(fullCount)
% 
%     convCount(index11).countMatrix = conv2(convCount(index11).countMatrix,kernel,'same');
% end

logicalCount = fullCount;

for index2 = 1:length(fullCount)

    logicalCount(index2).countMatrix = fullCount(index2).countMatrix > 0;
 
end

logicalCell = struct2cell(logicalCount);

logical3D = [];

for index3 = 1:length(fullCount)
    logical3D(:,:,index3) = logicalCell{3,1,index3};
    
end

save([savepath 'logical3D.mat'],'logical3D');


sumAll = sum(logical3D,3);




%% plot the summed matrix - use alpha for alphadata to only colour space
% that was actually visited
colours = [ 0.24,0.15,0.66;0.01,0.72,0.80;0.96,0.73,0.23];

figure(12)
imshow(map_normal);
alpha(0.3)
hold on
plotty12 = imagesc([1,rows],[columns,1],sumAll','AlphaData', alphaDAll);
% plotty12 = imagesc([1,rows],[columns,1],sumAll')

colorbar
title('visibility of the gaze-graph-defined landmarks');
saveas(gcf, strcat(savepath, 'visibility of the gaze-graph-defined landmarks.png'));
hold off

%% final aspect - only display 0,1,2 or more

more2 = sumAll >= 2;

sumAll2cut = sumAll;
sumAll2cut(more2) = 2;

colormap3 = [
    0.24,0.15,0.66
    0.18,0.77,0.64
    0.97,0.85,0.17];

figure(13)
imshow(map_normal);
alpha(0.3)
hold on
plotty13 = imagesc([1,rows],[columns,1],sumAll2cut','AlphaData', alphaDAll);
colormap(colormap3);
colorbar('Ticks',[0.35,1,1.65], 'TickLabels',{'0 houses','1 house','2 or more houses'})
title('Visibility of gaze-graph-defined landmarks - 0,1,2 or more');

saveas(gcf, strcat(savepath, 'visibility of the gaze-graph-defined landmarks - Triangulation.png'));
saveas(gcf, strcat(savepath, 'visibility of the gaze-graph-defined landmarks  - Triangulation.fig'));

hold off

%% percentage of triangulation area vs walked area

walkedGridAll = convCountAll ~= 0;
sumWalkedGridAll = sum(walkedGridAll,'all');

saw1 = sumAll2cut == 1;
saw2 = sumAll2cut == 2;

sumGrid1 = sum(saw1, 'all');
sumGrid2 = sum(saw2, 'all');

percTable = table;
percTable.percentage_0Houses = ((sumWalkedGridAll-(sumGrid1+sumGrid2))/sumWalkedGridAll)*100;
percTable.percentage_1House = (sumGrid1/sumWalkedGridAll)*100;
percTable.percentage_2Houses = (sumGrid2/sumWalkedGridAll)*100;
save([savepath,'table_percentage_triangulation.mat'],'percTable');


figure(20)
labelsData = {'0 houses','1 house','2 or more houses'};
figgy20 = pie([sumWalkedGridAll-sumGrid1-sumGrid2, sumGrid1, sumGrid2]);
legend(labelsData,'location', 'northeastoutside')
title('Percentage of possibility to triangulate in walked area');
saveas(gcf, strcat(savepath, 'piePlot_triangualationPercentage.png'));




%% how much of the experiment time did participants spend in areas where
% triangulation is possible?

% here the analysis does not depend on the eye tracking data, 
% therefore all the data is used (not only gazes)

% [countMatrixID,colEdgesAll,rowEdgesAll] = histcounts2(positionsID.Z, positionsID.X, edgesCol,edgesRows);


%% calculate the time spend in each area

% get binXA and binYA which has the information in which bin each data
% sample belongs
[allCountMatrix,rowEdges, colEdges, binXA, binYA] = histcounts2(allData.hmdPosition_x *multipFactor +additiveF, allData.hmdPosition_z *multipFactor +additiveF, edgesRows, edgesCol);
            
uniqueSqX150 = unique(binXA);
uniqueSqY150 = unique(binYA);

countMatrix_timeSpend_150min = zeros(size(countMatrixAll));

% loop through each square and count the sample durations that fall into it
for indexI = 1:length(uniqueSqX150)
    squareI = uniqueSqX150(indexI);
    locBinX = binXA == squareI;

    for indexJ = 1:length(uniqueSqY150)

        squareJ = uniqueSqY150(indexJ);
        locBinY = binYA == squareJ;

        % identify the duration of the selected squares
        locXY = locBinX & locBinY;

        countMatrix_timeSpend_150min(squareI,squareJ) = sum(allData.sampleDur(locXY));

    end
end


% use area categories to calculate the duration spend in each area type
logicSaw2 = sumAll2cut == 2;
logicSaw1 = sumAll2cut == 1;
logicSaw0 = sumAll2cut == 0;

sumCountM_duration = countMatrix_timeSpend_150min;

timeTr2 = sumCountM_duration(logicSaw2);
timeTr1 = sumCountM_duration(logicSaw1);
timeTr0 = sumCountM_duration(logicSaw0);

% now sum the areas
sumTTri2 = sum(timeTr2);
sumTTri1 = sum(timeTr1);
sumTTri0 = sum(timeTr0);
sumAllInterpol = sum(sumCountM_duration, 'all');

percTableTimeTri = table;
percTableTimeTri.percentage_Time0Houses = (sumTTri0 /sumAllInterpol)*100;
percTableTimeTri.percentage_Time1House = (sumTTri1/sumAllInterpol)*100;
percTableTimeTri.percentage_Time2Houses = (sumTTri2/sumAllInterpol)*100;
save([savepath,'table_times_triangulation_possible.mat'],'percTableTimeTri');

figure(21)
labelsData = {'0 houses','1 house','2 or more houses'};
figgy20 = pie([sumTTri0, sumTTri1, sumTTri2]);
legend(labelsData,'location', 'northeastoutside')
title('Percentage of experiment time spend in areas with more or less landmarks visible');
saveas(gcf, strcat(savepath, 'piePlot_TimesTriangualationPossible.png'));


figure(22)

imshow(map_normal);
alpha(0.3)
hold on
plotty13 = imagesc([1,rows],[columns,1],sumCountM_duration','AlphaData', alphaDAll);
colorbar

title('Duration spend within the walking paths - city areas');

saveas(gcf, strcat(savepath, 'Duration spend within the walking paths - city areas.png'));
saveas(gcf, strcat(savepath, 'Duration spend within the walking paths - city areas.fig'));

hold off


%% save overviews

save([savepath 'sumCountM_duration.mat'],'sumCountM_duration');
save([savepath 'countMatrix_timeSpend_150min.mat'],'countMatrix_timeSpend_150min');
save([savepath 'countMatrix_allETSess.mat'],'countMatrix_allETSess');



%% get some statistics on the visibility

visL = table;

visL.landmarks = landmarks.houseNames;

for index4 = 1:length(fullCount)

    sumL = sum(logical3D(:,:,index4),'all');
    visL.VisibilityCount(index4) = sumL;

end

visL.VisibilityPer = visL.VisibilityCount ./ sumWalkedGridAll;

meanVisibilityLandmarks = mean(visL.VisibilityPer);
stdVisibilityLandmarks = std(visL.VisibilityPer);

disp('---------------------------')
disp('landmarks were visible in the city on average and std: ')
disp(meanVisibilityLandmarks)
disp(stdVisibilityLandmarks)
disp('---------------------------')


save([savepath 'visibilityLandmarks.mat'],'visL');

%% now check visibility of all buildings:

% depends on gazes, so using gaze data

fullCount2 = struct;

for index5 = 1:height(uhouses)
        
    houseName = uhouses(index5);
    houseIndex =  strcmp(gazeData.namesNH,houseName);
    positions = table;
    positions.X = gazeData.hmdPosition_x(houseIndex)*multipFactor + additiveF;
    positions.Z = gazeData.hmdPosition_z(houseIndex)*multipFactor + additiveF;
    
    [countMatrix,colEdges,rowEdges] = histcounts2(positions.X, positions.Z, edgesRows,edgesCol);
    fullCount2(index5).columnEdges = colEdges;
    fullCount2(index5).rowEdges = rowEdges;
    fullCount2(index5).countMatrix = countMatrix;
 
end

% % apply kernal smoothing / convolution
% kernel  = [1,1,1;1,1,1;1,1,1];
% convCount2 = fullCount2;
% 
% 
% for index6 = 1:length(fullCount2)
% 
%     convCount2(index6).countMatrix = conv2(convCount2(index6).countMatrix,kernel,'same');
% end

logicalCount2 = fullCount2;

for index7 = 1:length(fullCount2)

    logicalCount2(index7).countMatrix = fullCount2(index7).countMatrix > 0;
 
end

logicalCell2 = struct2cell(logicalCount2);

logical3D2 = [];

for index8 = 1:length(fullCount2)
    logical3D2(:,:,index8) = logicalCell2{3,1,index8};
    
end

save([savepath 'logical3D_allbuildings.mat'],'logical3D2');



% get some statistics on the visibility

visL2 = table;

visL2.houseNames = uhouses;

for index9 = 1:length(fullCount2)

    sumL2 = sum(logical3D2(:,:,index9),'all');
    visL2.VisibilityCount(index9) = sumL2;

end

visL2.VisibilityPer = visL2.VisibilityCount ./ sumWalkedGridAll;

isLandmark = ismember(uhouses,landmarks.houseNames);

meanVisibilityBuildings = mean(visL2.VisibilityPer(not(isLandmark)));
stdVisibilityBuildings = std(visL2.VisibilityPer(not(isLandmark)));

disp('---------------------------')
disp('no landmark buildings were visible in the city on average and std: ')
disp(meanVisibilityBuildings)
disp(stdVisibilityBuildings)
disp('---------------------------')

save([savepath 'visibilityNoLandmarkBuildigns.mat'],'visL2');


meanVisibilityL2 = mean(visL2.VisibilityPer(isLandmark));
stdVisibilityL2 = std(visL2.VisibilityPer(isLandmark));

disp('---------------------------')
disp('(2nd calc) landmark buildings were visible in the city on average and std: ')
disp(meanVisibilityL2)
disp(stdVisibilityL2)
disp('---------------------------')