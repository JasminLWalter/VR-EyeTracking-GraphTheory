%% ------------------ match_map_coordinates----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

cd 'F:\Cyprus_project_overview\data\maps\'

map = imread ('Limassol_color2.jpg');
map2 = imread ('Limassol_lines2.jpg');
map3 = imread ('Limassol_grey2.jpg');


poligon1 = readtable('Copy of Final Map Limassol City Center (numbered buildings) 23.8. Jasmin- Unbenannte Ebene.csv');

clistpath = 'F:\Cyprus_project_overview\data\buildings\';
clist = readtable(strcat(clistpath, "building_coordinate_list.csv"));



%% extract polygon1
% Remove the 'POLYGON ((' and '))'
coord_str = extractBetween(poligon1{1,1}, 'POLYGON ((', '))');

% Split the string by commas first to get individual coordinate pairs
coord_pairs = strsplit(coord_str{1}, ',');

% Preallocate a matrix for the coordinates
num_coords = numel(coord_pairs);
coordinates = zeros(num_coords, 2);

% Loop through each coordinate pair and split into individual numbers
for i = 1:num_coords
    % Split by space and convert to numbers
    coord = str2double(strsplit(strtrim(coord_pairs{i})));
    coordinates(i, :) = coord;
end

% Convert the matrix to a table with appropriate column names
coord_table1 = array2table(coordinates, 'VariableNames', {'Longitude', 'Latitude'});

%% extract polygon2
% Remove the 'POLYGON ((' and '))'
coord_str = extractBetween(poligon1{2,1}, 'POLYGON ((', '))');

% Split the string by commas first to get individual coordinate pairs
coord_pairs = strsplit(coord_str{1}, ',');

% Preallocate a matrix for the coordinates
num_coords = numel(coord_pairs);
coordinates = zeros(num_coords, 2);

% Loop through each coordinate pair and split into individual numbers
for i = 1:num_coords
    % Split by space and convert to numbers
    coord = str2double(strsplit(strtrim(coord_pairs{i})));
    coordinates(i, :) = coord;
end

% Convert the matrix to a table with appropriate column names
coord_table2 = array2table(coordinates, 'VariableNames', {'Longitude', 'Latitude'});





%% plot all
% % plot the map
% 
% figure(1)
% imshow(map);
% hold on
% 
% corner = 10;
% width = 8192-corner;
% height = 5051-corner;
% 
% % Define the coordinates of the four corners
% x_coords = [corner, width, width, corner, corner];
% y_coords = [corner, corner, height, height, corner];
% 
% % Plot the rectangle
% plot(x_coords, y_coords, '-o', 'LineWidth', 2); % Plot with lines connecting the points and markers at each vertex
% 
% hold off
% 
% % dim image 8192x5051; 1090330, 1144300, -266*(8192/2); -453*(5051/2);
% % (mod_mult_long/125),(mod_mult_lat/73)
% mod_mult_long = 200000;
% mod_mult_lat = 200000;
% 
% mod_add_long = - (mod_mult_long/100) *(8192/2);
% mod_add_lat = - (mod_mult_lat/73)*(5051/2);
% 
% 
% 
% coord_table1.Longitude = (coord_table1.Longitude*mod_mult_long) + mod_add_long;
% coord_table1.Latitude = (coord_table1.Latitude*mod_mult_lat) + mod_add_lat;
% 
% coord_table2.Longitude = (coord_table2.Longitude*mod_mult_long)  + mod_add_long;
% coord_table2.Latitude = (coord_table2.Latitude*mod_mult_lat) + mod_add_lat;
% 
% figure(2)
% % Plot the polygon by connecting the points
% plot(coord_table1.Longitude, coord_table1.Latitude, '-o', 'LineWidth', 2); % Plot with lines connecting the points and markers at each vertex
% 
% hold on
% % Close the polygon by connecting the last point to the first
% plot([coord_table1.Longitude(end), coord_table1.Longitude(1)], [coord_table1.Latitude(end), coord_table1.Latitude(1)], '-o', 'LineWidth', 2);
% 
% plot(coord_table2.Longitude, coord_table2.Latitude, '-o', 'LineWidth', 2); % Plot with lines connecting the points and markers at each vertex
% 
% % Close the polygon by connecting the last point to the first
% plot([coord_table2.Longitude(end), coord_table2.Longitude(1)], [coord_table2.Latitude(end), coord_table2.Latitude(1)], '-o', 'LineWidth', 2);
% 
% plot(x_coords, y_coords, '-o', 'LineWidth', 2); % Plot with lines connecting the points and markers at each vertex
% 
% % Add labels and title
% xlabel('Longitude');
% ylabel('Latitude');
% title('Polygon Plot');
% 
% % Optional: Enhance the plot with grid and axis equal
% grid on;
% axis equal;
% 
% hold off
% 

%% 

coord_table = coord_table1;

% Step 1: Calculate the bounding box of the polygon
min_longitude = min(coord_table.Longitude);
max_longitude = max(coord_table.Longitude);
min_latitude = min(coord_table.Latitude);
max_latitude = max(coord_table.Latitude);

% Polygon width and height
polygon_width = max_longitude - min_longitude;
% polygon_width = 1776;

polygon_height = max_latitude - min_latitude;

% Step 2: Calculate the center of the map
map_center_x = 4096;
map_center_y = 2525.5;

% Step 3: Calculate the scaling factor
% Scaling factors to make the polygon slightly bigger than the map
scale_factor_x = 8192 / polygon_width * 1.1; % 10% larger
scale_factor_y = 5051 / polygon_height * 1.1;

% Use the smaller of the two scaling factors to preserve aspect ratio
% scale_factor = min(scale_factor_x, scale_factor_y);
scale_factor_long = 660000;
scale_factor_lat = 799900;



% Step 4: Scale and center the polygon
% scaled_longitudes = (coord_table.Longitude - (min_longitude)) * scale_factor;
scaled_longitudes = (coord_table.Longitude) * scale_factor_long;

% scaled_longitudes = (coord_table.Longitude - (-158)) * scale_factor;

% scaled_latitudes = (coord_table.Latitude - min_latitude) * scale_factor;
scaled_latitudes = (coord_table.Latitude) * scale_factor_lat;

long_add = 3300; % minus --> to the right
lat_add = 800; % minus --> to the top

% Translate to center the polygon on the map
centered_longitudes = scaled_longitudes + (map_center_x - (mean(scaled_longitudes+long_add )));
% centered_longitudes = scaled_longitudes + (map_center_x -26434600);

% centered_longitudes = scaled_longitudes + (map_center_x - 5332);
centered_latitudes = scaled_latitudes + (map_center_y - mean(scaled_latitudes + lat_add));
% centered_latitudes = scaled_latitudes + (map_center_y -27739500);

%% coordinate table 2

scaled_longitudes2 = (coord_table2.Longitude) * scale_factor_long;

scaled_latitudes2 = (coord_table2.Latitude) * scale_factor_lat;

centered_longitudes2 = scaled_longitudes2 + (map_center_x - (mean(scaled_longitudes+long_add )));
centered_latitudes2 = scaled_latitudes2 + (map_center_y - mean(scaled_latitudes + lat_add));


% Plot the scaled and centered polygon on the map
figure(3); % Create a new figure

flipped_map = flipud(map);
imshow(flipped_map)
hold on;


% Plot the polygon on the map
plot(centered_longitudes, centered_latitudes, '-o', 'LineWidth', 2);

% Optional: Close the polygon by connecting the last point to the first
plot([centered_longitudes(end), centered_longitudes(1)], ...
     [centered_latitudes(end), centered_latitudes(1)], '-o', 'LineWidth', 2);


% Plot the polygon on the map
plot(centered_longitudes2, centered_latitudes2, '-o', 'LineWidth', 2);

% Optional: Close the polygon by connecting the last point to the first
plot([centered_longitudes2(end), centered_longitudes2(1)], ...
     [centered_latitudes2(end), centered_latitudes2(1)], '-o', 'LineWidth', 2);



% Enhance the plot
xlabel('X Coordinate (pixels)');
ylabel('Y Coordinate (pixels)');
title('Scaled and Centered Polygon on Map');

% Set axis limits to the size of the map
xlim([0, 8192]);
ylim([0, 5051]);
axis equal;
grid on;

set(gca,'xdir','normal','ydir','normal')





%% figure(4)




 % pixel values map picture  8192x5051
dimMap = size(map);
pixel_width = dimMap(2); %8192;  % Width of the image in pixels
pixel_height = dimMap(1); %5051;  % Height of the image in pixels


% latitude and longitude of the edges of the map image 
corner_lat_top =  34.67751;%34.6774+0.00011;%   34.67727;  % Latitude of the top edge of the map
corner_lat_bottom = 34.671293; %34.6712+0.000093; %34.6716;  % Latitude of the bottom edge of the map
corner_lon_left = 33.037658;% 33.0376 + 0.000058;  %33.03896;  % Longitude of the left edge of the map
corner_lon_right = 33.049882;%33.0498 +0.000082; %33.04995;  % Longitude of the right edge of the map

% corner_oben_links_lat = 34.6774 ;
% corner_oben_rechts_lat = 34.6774;
% 
% corner_unten_links_lat = 34.6712;
% corner_unten_rechts_lat = 34.6712;
% 
% corner_oben_links_long = 33.0376;
% corner_unten_links_long = 33.0376;
% 
% corner_oben_rechts_long = 33.0498;
% corner_unten_rechts_long = 33.0498;





% Calculate differences in latitude and longitude
delta_lat = corner_lat_top - corner_lat_bottom;
delta_lon = corner_lon_right - corner_lon_left;

% Calculate conversion ratio from degrees to pixels
lat_to_pixel = pixel_height / delta_lat;
lon_to_pixel = pixel_width / delta_lon;

% Assuming df contains 'latitude' and 'longitude' columns
% Convert GPS coordinates to pixel coordinates
longitudes_sc = (coord_table1.Longitude - corner_lon_left) * lon_to_pixel;
latitudes_sc = (corner_lat_top - coord_table1.Latitude) * lat_to_pixel;

longitudes_sc2 = (coord_table2.Longitude - corner_lon_left) * lon_to_pixel;
latitudes_sc2 = (corner_lat_top - coord_table2.Latitude) * lat_to_pixel;


figure(4)
% Plot the scaled and centered polygon on the map

% flipped_map = flipud(map);
imshow(map)
hold on;




% Plot the polygon on the map
plot(longitudes_sc, latitudes_sc, '-o', 'LineWidth', 2);

% Optional: Close the polygon by connecting the last point to the first
plot([longitudes_sc(end), longitudes_sc(1)], ...
     [latitudes_sc(end), latitudes_sc(1)], '-o', 'LineWidth', 2);

% Plot the polygon on the map
plot(longitudes_sc2, latitudes_sc2, '-o', 'LineWidth', 2);

% Optional: Close the polygon by connecting the last point to the first
plot([longitudes_sc2(end), longitudes_sc2(1)], ...
     [latitudes_sc2(end), latitudes_sc2(1)], '-o', 'LineWidth', 2);



% Enhance the plot
xlabel('X Coordinate (pixels)');
ylabel('Y Coordinate (pixels)');
title('Scaled and Centered Polygon on Map');

hold off

% Set axis limits to the size of the map
% xlim([0, 8192]);
% ylim([0, 5051]);
% axis equal;
% grid on;

% set(gca,'xdir','normal','ydir','normal')


%% merge both approaches

% 
% longitudes_sc3 = (coord_table1.Longitude - corner_lon_left) * lon_to_pixel;
% latitudes_sc3 = (coord_table1.Latitude- corner_lat_top) * lat_to_pixel;
% 
% % longitudes_sc2 = (coord_table2.Longitude - corner_lon_left) * lon_to_pixel;
% % latitudes_sc2 = (corner_lat_top - coord_table2.Latitude) * lat_to_pixel;
% 
% 
% figure(5); % Create a new figure
% 
% flipped_map = flipud(map);
% imshow(flipped_map)
% hold on;
% 
% 
% % Plot the polygon on the map
% plot(longitudes_sc3, latitudes_sc3, '-o', 'LineWidth', 2);
% 
% % Optional: Close the polygon by connecting the last point to the first
% plot([longitudes_sc3(end), longitudes_sc3(1)], ...
%      [latitudes_sc3(end), latitudes_sc3(1)], '-o', 'LineWidth', 2);
% 
% 
% % Plot the polygon on the map
% plot(centered_longitudes2, centered_latitudes2, '-o', 'LineWidth', 2);
% 
% % Optional: Close the polygon by connecting the last point to the first
% plot([centered_longitudes2(end), centered_longitudes2(1)], ...
%      [centered_latitudes2(end), centered_latitudes2(1)], '-o', 'LineWidth', 2);
% 
% 
% 
% % Enhance the plot
% xlabel('X Coordinate (pixels)');
% ylabel('Y Coordinate (pixels)');
% title('Scaled and Centered Polygon on Map');
% 
% % Set axis limits to the size of the map
% xlim([0, 8192]);
% ylim([0, 5051]);
% axis equal;
% grid on;
% 
% set(gca,'xdir','normal','ydir','normal')






%% add the buildings

% 
% % Assuming df contains 'latitude' and 'longitude' columns
% % Convert GPS coordinates to pixel coordinates
% buildings_long = (clist.Longitude- corner_lon_left) * lon_to_pixel;
% buildings_lat = (corner_lat_top - clist.Latitude) * lat_to_pixel;
% 
% 
% 
% figure(6)
% % Plot the scaled and centered polygon on the map
% 
% 
% imshow(map)
% hold on;
% 
% color = [0.24 0.15,0.66];
% scatter(buildings_long, buildings_lat, 15, [0.24,0.15,0.66], 'filled');
% 
% 
% % Enhance the plot
% title('Experimental area and included buildings');
% 
% ax = gca;
% exportgraphics(ax,'experimentalAreaBuildings_Limassol_color.png');
% hold off 
% 
% 
% 
% figure(7)
% % Plot the scaled and centered polygon on the map
% 
% 
% imshow(map2)
% hold on;
% 
% color = [0.24 0.15,0.66];
% scatter(buildings_long, buildings_lat, 15, [0.24,0.15,0.66], 'filled');
% 
% 
% % Enhance the plot
% title('Experimental area and included buildings');
% 
% ax = gca;
% exportgraphics(ax,'experimentalAreaBuildings_Limassol_lines.png');
% hold off 
% 
% 
% 
% 
% figure(8)
% % Plot the scaled and centered polygon on the map
% 
% 
% imshow(map3)
% hold on;
% 
% color = [0.24 0.15,0.66];
% scatter(buildings_long, buildings_lat, 15, [0.24,0.15,0.66], 'filled');
% 
% 
% % Enhance the plot
% title('Experimental area and included buildings');
% 
% ax = gca;
% exportgraphics(ax,'experimentalAreaBuildings_Limassol_grey.png');
% hold off 
% 

%% 
p2Bcoordinates = readtable("F:\Cyprus_project_overview\store_cyprus_project\task_data\Mappe1");

p2Bpositions= readtable("F:\Cyprus_project_overview\store_cyprus_project\task_data\postion-per-location.ods");


% Assuming df contains 'latitude' and 'longitude' columns
% Convert GPS coordinates to pixel coordinates
p2Bbuildings_long = (p2Bcoordinates.longitude- corner_lon_left) * lon_to_pixel;
p2Bbuildings_lat = (corner_lat_top - p2Bcoordinates.latitude) * lat_to_pixel;

p2Bposition_long = (str2double(p2Bpositions.longitude) - corner_lon_left) * lon_to_pixel;
p2Bposition_lat = (corner_lat_top - str2double(p2Bpositions.latitude)) * lat_to_pixel;


figure(10)
% Plot the scaled and centered polygon on the map


imshow(map3)
alpha(0.5)
hold on;

scatter(p2Bposition_long, p2Bposition_lat, 60, [0.27,0.48,0.99], 'filled');
scatter(p2Bbuildings_long, p2Bbuildings_lat, 60,[0.24,0.15,0.66] , 'filled');
scatter(p2Bbuildings_long(1), p2Bbuildings_lat(1), 60, 'green', 'filled');



% Enhance the plot
title('task buildings');

ax = gca;
exportgraphics(ax,'task_buildings.png');
hold off 
            
