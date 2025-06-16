%% ------------------extract_building_coordinate_list----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

cd 'E:\Cyprus_project_overview\data\buildings\'

buildingCoordinates = readtable('Final Map Limassol City Center (numbered buildings)- Building Labels.csv');

imagepath = 'E:\Cyprus_project_overview\data\maps\'; % path to the map image location


% Example of table data:
% T.Var1 = {'POINT (33.0400824 34.6756093)', 'POINT (33.0412345 34.6723456)'};
% T.Var2 = {'Text123', 'AnotherText456'};

% Preallocate arrays for longitude, latitude, and extracted numbers

numRows = height(buildingCoordinates);
longitude = zeros(numRows, 1);
latitude = zeros(numRows, 1);
extractedNumbers = cell(numRows, 1);

% Loop through each row of the table
for i = 1:numRows
    % Extract longitude and latitude from Var1
    pointString = buildingCoordinates.WKT{i};
    tokens = regexp(pointString, 'POINT \(([^ ]+) ([^ ]+)\)', 'tokens');
    longitude(i) = str2double(tokens{1}{1});
    latitude(i) = str2double(tokens{1}{2});
    
    % Extract numbers from Var2
    nameString = buildingCoordinates.Name{i};
    numbers = regexp(nameString, '\d+', 'match');
    extractedNumbers{i} = strjoin(numbers, ''); % Join the extracted numbers if there are multiple
end

% Add extracted data to the table
buildingCoordinates.Longitude = longitude;
buildingCoordinates.Latitude = latitude;
buildingCoordinates.buildingNames = extractedNumbers;


colliderList = buildingCoordinates; % save unedited version for later analysis and plotting


%% check for duplications (in building names and coordinate locations)


% Identify duplicate rows based on all columns
[~, idx] = unique(buildingCoordinates.buildingNames); 
duplicated_rows = setdiff(1:height(buildingCoordinates.buildingNames), idx);


duplicated_data = buildingCoordinates(duplicated_rows, :);

isDupl = ismember(buildingCoordinates.buildingNames, duplicated_data.buildingNames);

allDuplicates_name = buildingCoordinates(isDupl, :);

% to handle the duplicates, rename them


% Handle the duplicates by renaming them
for i = 1:height(duplicated_data)
    % Get the name of the current duplicated building
    current_name = duplicated_data.buildingNames{i};
    
    % Find all occurrences of this name
    duplicate_indices = find(strcmp(buildingCoordinates.buildingNames, current_name));
    
    % Skip the first occurrence and rename the rest
    
    buildingCoordinates.buildingNames{duplicate_indices(2)} = char(string(str2num(current_name) + 500));


end

    
% now check for duplicates in coordinates

[~, idx2] = unique(buildingCoordinates(:,5:6),'rows');
duplicated_rows2 = setdiff(1:height(buildingCoordinates.buildingNames), idx2);

duplicated_data2 = buildingCoordinates(duplicated_rows2, :);

isDupl2 = (buildingCoordinates.Latitude == duplicated_data2.Latitude) & (buildingCoordinates.Longitude == duplicated_data2.Longitude);

allDuplicates_coord = buildingCoordinates(isDupl2, :);

% there is one duplicate, but this is already handled in the data frame.
% Although 2 identical locations are here marked with 2 names (77 & 76),
% only 77 is in the graph


% writetable(buildingCoordinates, 'building_coordinate_list.csv');


%% plot duplicates on map to investigate them (optional)

map = imread(strcat(imagepath,'map2.jpg'));


% pixel values map picture  8192x5051
dimMap = size(map);
pixel_width = dimMap(2);  % Width of the image in pixels
pixel_height = dimMap(1);   % Height of the image in pixels


% big map --> map 2 data
% latitude and longitude of the edges of the map image 
corner_lat_top =  34.677833; % Latitude of the top edge of the map
corner_lat_bottom = 34.6714944;  % Latitude of the bottom edge of the map
corner_lon_left = 33.0378529;  % Longitude of the left edge of the map
corner_lon_right = 33.0496599; % Longitude of the right edge of the map


% Calculate differences in latitude and longitude
delta_lat = corner_lat_top - corner_lat_bottom;
delta_lon = corner_lon_right - corner_lon_left;

% Calculate conversion ratio from degrees to pixels
lat_to_pixel = pixel_height / delta_lat;
lon_to_pixel = pixel_width / delta_lon;

% Assuming df contains 'latitude' and 'longitude' columns
% Convert GPS coordinates to pixel coordinates
colliderList.Longitude= (colliderList.Longitude - corner_lon_left) * lon_to_pixel;
colliderList.Latitude = (corner_lat_top - colliderList.Latitude) * lat_to_pixel;

% display map
figure(1)
imshow(map);
alpha(0.7)
hold on;


 % plot visualization
%          plotty = scatter(x,y,40,'filled','YDataMode','manual');

hold on

x = colliderList.Longitude(isDupl);
y = colliderList.Latitude(isDupl);

plotty = scatter(x, y, 15 ,'b','filled');

saveas(gcf,strcat('All duplicated building locations.png'));



% x = colliderList.Longitude(duplicated_rows);
% y = colliderList.Latitude(duplicated_rows);
% 
% plotty = scatter(x, y, 12 ,'r','filled');

hold off

%% plot the individual duplicated nodes with their edges --> only do when you have the graph already

% load graph

graphy = load('E:\Cyprus_project_overview\data\analysis\exploration\graphs\graph_limassol.mat');
graphy= graphy.graphy;

edgeCell = graphy.Edges.EndNodes;


for index = 1:height(duplicated_data)

    duplName = duplicated_data.buildingNames(index);
    duplLocs = strcmp(colliderList.buildingNames, duplName);  

    e1 = strcmp(edgeCell(:,1), duplName);
    e2 = strcmp(edgeCell(:,2), duplName);

    edges = edgeCell(e1|e2,:);

    % display map
    figure;
    imshow(map);
    alpha(0.7)
    hold on;


    for ee = 1:length(edges)

        if not(strcmp(edges(ee,1), duplName))

            loc = strcmp(colliderList.buildingNames,edges(ee,1));
    
            x = colliderList.Longitude(loc);
            y = colliderList.Latitude(loc);
        
            plotty = scatter(x, y, 15 ,'r','filled');

        end


        % [Xhouse,Xindex] = ismember(edges(ee,1), colliderList.buildingNames);
        % 
        % [Yhouse,Yindex] = ismember(edges(ee,2), colliderList.buildingNames);
        % 
        % x1 = colliderList.Longitude(Xindex);
        % y1 = colliderList.Latitude(Xindex);
        % 
        % x2 = colliderList.Longitude(Yindex);
        % y2 = colliderList.Latitude(Yindex);
        % 
        % line([x1,x2],[y1,y2],'Color','k','LineWidth',1); 
    
    end
    
    
    x = colliderList.Longitude(duplLocs);
    y = colliderList.Latitude(duplLocs);
    
    plotty = scatter(x, y, 15 ,'b','filled');
    
    
    % x = colliderList.Longitude(duplicated_rows);
    % y = colliderList.Latitude(duplicated_rows);
    % 
    % plotty = scatter(x, y, 12 ,'r','filled');

    title(strcat(duplName,' building duplicate + edge buildings'))
    
    hold off
    saveas(gcf,strcat(string(duplName),'_duplicated_building_and_edgeBuildings.png'));




end





