%% --------------------- analysisDiameter_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\tempDevelopment\1minSections\AnalysisDiameter\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\tempDevelopment\1minSections\';

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};





overviewDiameter = load('overviewDiameter_1min.mat');
overviewDiameter = overviewDiameter.overviewDiameter;

overviewIndices = load('overviewIndices_1min.mat');
overviewIndices  = overviewIndices.overviewIndices;


overviewClusterDur = load('overviewClusterDuration.mat');
overviewClusterDur = overviewClusterDur.overviewClusterDuration;

% Number of rows in the matrix
numRows = size(overviewDiameter, 1);

% Preallocate vectors
maxValues = zeros(numRows, 1);
maxIndices = zeros(numRows, 1);
lastValues = zeros(numRows, 1);

% Loop through each row
for i = 1:numRows
    % Extract the row
    row = overviewDiameter(i, :);
    
    % Find the maximum value and its index
    [maxValues(i), maxIndices(i)] = max(row);
    
    % Get the last value of the row
    lastValues(i) = row(150);
end

overviewEndDiameter = table;

overviewEndDiameter.Participants = PartList';
overviewEndDiameter.maxDiameter = maxValues;
overviewEndDiameter.timeIndexMaxDiameter = maxIndices;
overviewEndDiameter.endDiameter = lastValues;


is7 = lastValues == 7;
is8 = lastValues == 8;
is9 = lastValues == 9;

colors = parula(3);

figure(1)

for index = 7:9

    isI = lastValues == index;
    plotty1 = scatter(maxIndices(isI),maxValues(isI),20,colors(index-6,:), 'filled','DisplayName', num2str(index));
    hold on


end


xlabel('timeIndex of max diameter')
ylabel('max diameter')
title('time index of max diameter and max diameter')
legend
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'time index of max diameter and max diameter.png'),'Resolution',600)
hold off 


figure(2);
hold on;

uniqueLastValues = unique(lastValues);

labels = cell(length(uniqueLastValues), 1);

for k = 1:length(uniqueLastValues)
    % Filter maxIndices by the current unique lastValue
    isI = lastValues == uniqueLastValues(k);
    % Plot the boxplot for the current filtered maxIndices
    boxplot(maxIndices(isI), 'Positions', k);
    % Save the label for the current unique lastValue
    labels{k} = num2str(uniqueLastValues(k));
end

% Set x-axis labels
set(gca, 'XTick', 1:length(uniqueLastValues), 'XTickLabel', labels);
xlabel('Last Values');
ylabel('Max Indices');
title('Boxplots of Max Indices Filtered by Last Values');
hold off;

ax = gca;
exportgraphics(ax,strcat(savepath, 'Boxplots of Max Indices Filtered by Last Values.png'),'Resolution',600)
hold off 



figure(3);
hold on;

uniqueLastValues = unique(lastValues);

labels = cell(length(uniqueLastValues), 1);

for k = 1:length(uniqueLastValues)
    % Filter maxIndices by the current unique lastValue
    isI = lastValues == uniqueLastValues(k);
    % Plot the boxplot for the current filtered maxIndices
    boxplot(overviewClusterDur(isI), 'Positions', k);
    % Save the label for the current unique lastValue
    labels{k} = num2str(uniqueLastValues(k));
end

% Set x-axis labels
set(gca, 'XTick', 1:length(uniqueLastValues), 'XTickLabel', labels);
xlabel('Last Values');
ylabel('Cluster Duration');
title('cluster duration and end value - missing data effect');
hold off;
ax = gca;
exportgraphics(ax,strcat(savepath, 'cluster duration and end value - missing data effect.png'),'Resolution',600)
hold off 


cd 'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\graphs\'

overviewEndDiameter = struct;


for indexParts = 1:length(PartList)
    tic
    currentPart = cell2mat(PartList(indexParts));
    disp(currentPart)
    
    overviewEndDiameter(indexParts).Participant = currentPart;
    overviewEndDiameter(indexParts).endDiameter = overviewDiameter(indexParts,end);



    file = strcat(num2str(currentPart),'_Graph_WB.mat');
         
    % load data
    graphy = load(file);
    graphy = graphy.graphy;
    % create table with necessary fields

%         gazedTable.Samples = [gazedObjects.Samples]';

    currentPartName= strcat('Participant_',num2str(currentPart));



    % get diameter
    distanceM = distances(graphy);
    checkInf = isinf(distanceM);
    distanceM(checkInf) = 0;
    
    diameter = max(max(distanceM));

   
    % Find the indices of the nodes corresponding to the diameter
    [row, col] = find(distanceM == diameter);

    numMaxDistances = 0; % Number of unique maximum distances found
   
   
    
    % Get the node names of the graph
    nodeNames = graphy.Nodes.Name;

    % Initialize a table to keep track of processed node pairs
    processedPairs = table([], [], 'VariableNames', {'StartNode', 'EndNode'});
    
    pathStruct = struct;
    startNodeList = struct;
    endNodeList = struct;
    % Loop through each pair of nodes that have the maximum distance
    for k = 1:length(row)
        startNode = row(k);
        endNode = col(k);
        
        % Check if this node pair or its reverse has already been processed
        if ~any((processedPairs.StartNode == startNode & processedPairs.EndNode == endNode) | ...
                (processedPairs.StartNode == endNode & processedPairs.EndNode == startNode))
            % Add this pair to the table
            processedPairs = [processedPairs; {startNode, endNode}];
            numMaxDistances = numMaxDistances + 1;
    
            % Find the nodes in the longest shortest path
            path = shortestpath(graphy, startNode, endNode);
            
            % Get the names of the nodes in the path
            nodeNamesInPath = nodeNames(path);
            
            % Store the path in the structure
            pathStruct(numMaxDistances).path = nodeNamesInPath;
            startNodeList(numMaxDistances).name = nodeNames{startNode};
            endNodeList(numMaxDistances).name = nodeNames{endNode};
        end

        % Store the path in the structure
        overviewEndDiameter(indexParts).NumMaxDiameters = numMaxDistances;
        overviewEndDiameter(indexParts).Path = pathStruct;
        overviewEndDiameter(indexParts).StartNode = startNodeList;
        overviewEndDiameter(indexParts).EndNode = endNodeList;
    end










end



save([savepath 'overviewEndDiameter.mat'],'overviewEndDiameter');