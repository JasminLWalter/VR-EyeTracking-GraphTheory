%% ------------------visualizations_first 5 min - walking paths_gazes-------------------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Visualizes, for each selected participant, the first 5 minutes of VR exploration by
%          plotting walking paths and gaze hit points over the Westbrook map.
%
% Usage:
% - Adjust: imagepath, clistpath, working directory (cd), and PartList.
% - Run the script in MATLAB. The first ~300,000 ms of data (clusterDuration) are used per participant.
%
% Inputs:
% - Per participant: <ParticipantID>_interpolatedColliders_5Sessions_WB.mat (variable: interpolatedData)
% - Map image: additional_Files/map_natural_white_flipped.png
% - Optional (loaded but not used in this script): additional_Files/building_collider_list.csv
%
% Outputs:
% - Figures displayed in MATLAB:
%   - Walking paths (first 5 min) colored by participant
%   - Gaze hit points (first 5 min) colored by participant
% - Note: No files are saved by default; use saveas/exportgraphics if needed.
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

clear all;

%% adjust the following variables: 

savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\visualization_graph_plots\Gif_walkingPaths\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location



cd 'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\interpolatedColliders\'

% PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
PartList = {1004 1005 1008 1017 1018 1021};

%-----------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


% map = imread (strcat(imagepath,'map_white_flipped.png'));
map = imread (strcat(imagepath,'map_natural_white_flipped.png'));



% load house list with coordinates

listname = strcat(clistpath,'building_collider_list.csv');
colliderList = readtable(listname);

[uhouses,loc1,loc2] = unique(colliderList.target_collider_name);

houseList = colliderList(loc1,:);


overview5minData = struct;
% overviewWalkingPathsZ = struct;


for ii = 1:Number
    tic
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_interpolatedColliders_5Sessions_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        
        % load data
        data = load(file);
        data = data.interpolatedData;
        
        currentSum = 0;
        findIndex = 0;
        while currentSum <= 300000 % find index to get 5 min of data
            findIndex = findIndex +1;
            currentSum = currentSum + data(findIndex).clusterDuration;

        end


        overview5minData(ii).x = [data(1:findIndex).playerBodyPosition_x]; 
        overview5minData(ii).z = [data(1:findIndex).playerBodyPosition_z];

        data5min = data(1:findIndex);
        gazes = [data5min.clusterDuration] > 250;
        gazes_data = data5min(gazes);

        overview5minData(ii).hitPointOnObjectX = [data(1:findIndex).hitPointOnObject_x];
        overview5minData(ii).hitPointOnObjectY = [data(1:findIndex).hitPointOnObject_y];
        overview5minData(ii).hitPointOnObjectZ = [data(1:findIndex).hitPointOnObject_z];


    end      
    toc

end

figure(1)
imshow(map);
alpha(0.3)
hold on;

colors = parula(ii);

for column = 1:ii
        
        plot(overview5minData(column).x*4.2+2050,overview5minData(column).z*4.2+2050, 'LineWidth',2,'Color',colors(column,:));

        
end
    
set(gca,'xdir','normal','ydir','normal')
hold off

figure(2)
imshow(map);
alpha(0.3)
hold on;

colors = parula(ii);

for column = 1:ii

        scatter(overview5minData(column).hitPointOnObjectX*4.2+2050,overview5minData(column).hitPointOnObjectZ *4.2+2050,5,colors(column,:),'filled');


end

set(gca,'xdir','normal','ydir','normal')
hold off


% sumTime = 
  






