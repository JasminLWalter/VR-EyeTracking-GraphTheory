%% --------------------- analysisMaxDiameter_prep_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\tempDevelopment\1minSections\AnalysisDiameter\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
colliderList = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\building_collider_list.csv');

cd 'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step3_gazeProcessing\';

pathOverviews = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\tempDevelopment\1minSections\';

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};





overviewDiameter = load(strcat(pathOverviews,'overviewDiameter_1min.mat'));
overviewDiameter = overviewDiameter.overviewDiameter;

overviewIndices = load(strcat(pathOverviews, 'overviewIndices_1min.mat'));
overviewIndices  = overviewIndices.overviewIndices;


overviewMaxDiameter = struct;





for indexParts = 1:length(PartList)
    tic
    disp(['Paritipcant ', num2str(indexParts)])
    currentPart = cell2mat(PartList(indexParts));
    

    [maxDiameter, maxIndex] = max(overviewDiameter(indexParts,:));


    timeIndex = overviewIndices(indexParts, maxIndex);
    timeIndexB = overviewIndices(indexParts, maxIndex-1);

    overviewMaxDiameter(indexParts).Participant = currentPart;
    overviewMaxDiameter(indexParts).endDiameter = overviewDiameter(indexParts,end);
    overviewMaxDiameter(indexParts).maxDiameter = maxDiameter;
    overviewMaxDiameter(indexParts).maxIndex = maxIndex;
    overviewMaxDiameter(indexParts).rowIndexMax = timeIndex;


    %% create the graph with the max diameter
    
    currentLoc = timeIndex;

    %% load the data


    %% load and combine gaze data


    gazesData = table;

    
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

                gazesTable = table;
                gazesTable.timeStampRS = data.timeStampRS;
                gazesTable.hitObjectColliderName = data.namesNH;
                gazesTable.events = data.events;
                
                gazesTable.hmdPosition_x = data.hmdPosition_x;
                gazesTable.hmdPosition_z = data.hmdPosition_z;

                gazesTable.hitObjectColliderName(end+1) = {'newSession'};

                gazesData = [gazesData; gazesTable];


            end
        end
    end

   
    % overviewClusterDuration(indexParts,1) = (sum([gazesData.clusterDuration])/1000)/60;

       % remove all elements that are not a building 
    % and not the new session and noData markers

    uniqueBuildingNames = unique(colliderList.target_collider_name);
    
    isInColliderList = false(height(gazesData),1);
    
    for indexNH = 1: length(uniqueBuildingNames)
        
        currentB = uniqueBuildingNames(indexNH);
        locBuilding1 = strcmp(currentB, gazesData.hitObjectColliderName);
        
        isInColliderList = isInColliderList | locBuilding1;
        
    end

    gazesData.isInColliderList = isInColliderList;
    

    %% 

    currentData = gazesData(1:currentLoc,:);


    currentData(~currentData.isInColliderList,:) = [];

    % identify fixations and no data
    fixations = currentData.events == 2.0;
    noData = currentData.events == 3;
    currentData.hitObjectColliderName(noData) = {'noData'};
    
    isEmpty = ismissing(currentData.hitObjectColliderName);
    currentData.hitObjectColliderName(isEmpty) = {'noData'};

    currentData(not(fixations|noData),:) = [];


    % create the graph for the current data snippet

    % create nodetable
    uniqueHouses= unique(currentData.hitObjectColliderName(:));
    NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

    % create edge table

    fullEdgeT= cell2table(currentData.hitObjectColliderName,'VariableNames',{'Column1'});

    % prepare second column to add to specify edges
    secondColumn = fullEdgeT.Column1;
    % remove first element of 2nd column
    secondColumn(1,:)=[];  
    % remove last element of 1st column
    fullEdgeT(end,:)= [];

    % add second column to table
    fullEdgeT.Column2 = secondColumn;


    % remove all repetitions
    % 1st round- using unique


    % Remove duplicate edges (first round)
    uniqueTable = unique(fullEdgeT);
    
    % Create reversed pairs explicitly
    reversedPairs = uniqueTable(:, [2, 1]); 
    reversedPairs.Properties.VariableNames = {'Column1', 'Column2'};
    
    % Combine original and reversed tables
    combinedPairs = [uniqueTable; reversedPairs];
    
    % Convert to string arrays for sorting (handles mixed types)
    column1Str = string(combinedPairs.Column1);
    column2Str = string(combinedPairs.Column2);
    
    % Sort each row to normalize bidirectional edges
    sortedPairs = sort([column1Str, column2Str], 2);
    
    % Find unique bidirectional edges
    [~, uniqueIdx] = unique(sortedPairs, 'rows', 'stable');
    noRepsTable = combinedPairs(uniqueIdx, :);
    
    % Remove self-references *after* deduplication
    selfRefMask = strcmp(noRepsTable.Column1, noRepsTable.Column2);
    selfReferences = noRepsTable(selfRefMask, :);
    noRepsTable(selfRefMask, :) = [];
    
    % Find repeated edges (optional, for debugging)
    repetitions = setdiff(combinedPairs, noRepsTable, 'rows');
    
    % Create final EdgeTable
    EdgeTable = mergevars(noRepsTable, {'Column1', 'Column2'}, 'NewVariableName', 'EndNodes');

%% create graph


    graphyNoData = graph(EdgeTable,NodeTable);



%% remove node noData and newSession from graph


    graphy = rmnode(graphyNoData, 'noData');
    graphy = rmnode(graphy, 'newSession');


    %% calculate the diameter


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
        overviewMaxDiameter(indexParts).NumMaxDiameters = numMaxDistances;
        overviewMaxDiameter(indexParts).Path = pathStruct;
        overviewMaxDiameter(indexParts).StartNode = startNodeList;
        overviewMaxDiameter(indexParts).EndNode = endNodeList;
    end

     




    %% next step save walking path in max segment (roughly based on gazes)

        overviewMaxDiameter(indexParts).BodyPosition_x = [gazesData.hmdPosition_x(timeIndexB:timeIndex)]; 
        overviewMaxDiameter(indexParts).BodyPosition_z = [gazesData.hmdPosition_z(timeIndexB:timeIndex)];








end




save([savepath 'overviewMaxDiameter.mat'],'overviewMaxDiameter');










