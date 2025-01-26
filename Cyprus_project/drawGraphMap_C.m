%% ------------------- drawGraphMap_C.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;


%% adjust the following variables: 
% savepath, imagepath, clistpath, current folder and participant list!-----

imagepath = 'F:\Cyprus_project_overview\data\maps\'; % path to the map image location

cd 'F:\Cyprus_project_overview\data\graphs\';


clistpath = 'F:\Cyprus_project_overview\data\buildings\';
colliderList = readtable(strcat(clistpath, "building_coordinate_list.csv"));
colliderList.buildingNames = cellstr(string(colliderList.buildingNames));


nodecolor = parula;

map = imread(strcat(imagepath,'Limassol_grey2.jpg'));


% transform coordinates to match map

% pixel values map picture  8192x5051
dimMap = size(map);
pixel_width = dimMap(2); %8192;  % Width of the image in pixels
pixel_height = dimMap(1); %5051;  % Height of the image in pixels


% latitude and longitude of the edges of the map image 
corner_lat_top =  34.67751; % Latitude of the top edge of the map
corner_lat_bottom = 34.671293;  % Latitude of the bottom edge of the map
corner_lon_left = 33.037658;  % Longitude of the left edge of the map
corner_lon_right = 33.049882; % Longitude of the right edge of the map


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

    if ~(strcmp(edgeCell(ee,1),'28') |strcmp(edgeCell(ee,2),'28'))

    [Xhouse,Xindex] = ismember(edgeCell(ee,1),colliderList.buildingNames);
    
    [Yhouse,Yindex] = ismember(edgeCell(ee,2),colliderList.buildingNames);
    
    x1 = colliderList.Longitude(Xindex);
    y1 = colliderList.Latitude(Xindex);
    
    x2 = colliderList.Longitude(Yindex);
    y2 = colliderList.Latitude(Yindex);
    
    line([x1,x2],[y1,y2],'Color','k','LineWidth',0.1); 
    end
    
end
%---------comment code until here to only show nodes without edges--------




%% visualize nodes color coded according to the node degree values
find28 = strcmp(nodeTable.Name, '28');
nodeTable(find28,:) = [];

node = ismember(colliderList.buildingNames,nodeTable.Name);

x = colliderList.Longitude(node);
y = colliderList.Latitude(node);

 % plot visualization
%          plotty = scatter(x,y,40,'filled','YDataMode','manual');
 plotty = scatter(x, y, 15 ,'k','filled');


saveas(gcf,'graph_visualizationMap');
ax = gca;
exportgraphics(ax,strcat(savepath,'graph_visualizationMap.png'))

hold off



    
























