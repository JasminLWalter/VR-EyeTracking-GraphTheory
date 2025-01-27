%% ------------------extract_building_coordinate_list----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

cd 'E:\Cyprus_project_overview\data\buildings\'

buildingCoordinates = readtable('Final Map Limassol City Center (numbered buildings)- Building Labels.csv');



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


writetable(buildingCoordinates, 'building_coordinate_list.csv');












