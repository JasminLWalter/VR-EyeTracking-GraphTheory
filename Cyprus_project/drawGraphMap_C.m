%% ------------------- drawGraphMap_C.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;


%% adjust the following variables: 
% savepath, imagepath, clistpath, current folder and participant list!-----

imagepath = 'E:\Cyprus_project_overview\data\maps\'; % path to the map image location

cd 'E:\Cyprus_project_overview\data\analysis\exploration\graphs\';


clistpath = 'E:\Cyprus_project_overview\data\buildings\';
colliderList = readtable(strcat(clistpath, "building_coordinate_list.csv"));
colliderList.buildingNames = cellstr(string(colliderList.buildingNames));


nodecolor = parula;

map = imread(strcat(imagepath,'map2.jpg'));


% transform coordinates to match map

% pixel values map picture  8192x5051
dimMap = size(map);
pixel_width = dimMap(2);  % Width of the image in pixels
pixel_height = dimMap(1);   % Height of the image in pixels

% small map --> map 1
% % latitude and longitude of the edges of the map image 
% corner_lat_top =  34.6776114; % Latitude of the top edge of the map
% corner_lat_bottom = 34.6718491;  % Latitude of the bottom edge of the map
% corner_lon_left = 33.0379205;  % Longitude of the left edge of the map
% corner_lon_right = 33.0492816; % Longitude of the right edge of the map

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






% load graph

graphy = load('graph_limassol.mat');
graphy= graphy.graphy;

nodeTable = graphy.Nodes;
edgeTable = graphy.Edges;
edgeCell = edgeTable.EndNodes;
        
% display map
figure(1)
imshow(map);
alpha(0.7)
hold on;


for ee = 1:length(edgeCell)

   
    [Xhouse,Xindex] = ismember(edgeCell(ee,1),colliderList.buildingNames);
    
    [Yhouse,Yindex] = ismember(edgeCell(ee,2),colliderList.buildingNames);
    
    x1 = colliderList.Longitude(Xindex);
    y1 = colliderList.Latitude(Xindex);
    
    x2 = colliderList.Longitude(Yindex);
    y2 = colliderList.Latitude(Yindex);
    
    line([x1,x2],[y1,y2],'Color','k','LineWidth',0.05); 
    
end
%---------comment code until here to only show nodes without edges--------




%% visualize nodes color coded according to the node degree values

node = ismember(colliderList.buildingNames,nodeTable.Name);

x = colliderList.Longitude(node);
y = colliderList.Latitude(node);

 % plot visualization
%          plotty = scatter(x,y,40,'filled','YDataMode','manual');
 plotty = scatter(x, y, 12 ,'k','filled');


saveas(gcf,'graph_visualizationMap');
ax = gca;
exportgraphics(ax,'graph_visualizationMap.png')

hold off



    
























