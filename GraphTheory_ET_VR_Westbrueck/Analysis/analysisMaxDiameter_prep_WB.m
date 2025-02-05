%% --------------------- analysisMaxDiameter_prep_WB.m------------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------
savepath = 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\tempDevelopment\1minSections\AnalysisDiameter\';
imagepath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the map image location
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

cd 'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\gazes_vs_noise\';

pathOverviews = 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\tempDevelopment\1minSections\';

PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};





overviewDiameter = load(strcat(pathOverviews,'overviewDiameter_1min.mat'));
overviewDiameter = overviewDiameter.overviewDiameter;

overviewIndices = load(strcat(pathOverviews, 'overviewIndices_1min.mat'));
overviewIndices  = overviewIndices.overviewIndices;


overviewMaxDiameter = struct;





for indexParts = 1:length(PartList)
    tic
    currentPart = cell2mat(PartList(indexParts));
    disp(currentPart)
    
    file = strcat(num2str(currentPart),'_gazes_data_WB.mat');
         
    % load data
    gazesData = load(file);
    gazesData = gazesData.gazes_data;
    % create table with necessary fields

%         gazedTable.Samples = [gazedObjects.Samples]';

    currentPartName= strcat('Participant_',num2str(currentPart));



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

    gazedTable = table;
    gazedTable.hitObjectColliderName = [gazesData.hitObjectColliderName]';

    currentData = gazedTable(1:currentLoc,:);
    % remove all NH and sky elements
    nohouse=strcmp(currentData.hitObjectColliderName(:),{'NH'});
    currentData(nohouse,:)=[];

    % check the duration of the data section


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

    uniqueTable= unique(fullEdgeT);

    % 2nd round using for loop

    %check if first entry is a self-reference
    %create edgetable

    if (strcmp(uniqueTable{1,1},uniqueTable{1,2}))
        % if self-reference start noRepsTable with second entry
         noRepsTable= uniqueTable(2,:);
         noRepsTable.Properties.VariableNames = {'Column1','Column2'};

         repetitions={};
         selfReferences={};
         start = 3;
    else

         noRepsTable= uniqueTable(1,:);
         noRepsTable.Properties.VariableNames = {'Column1','Column2'};

         repetitions={};
         selfReferences={};
         start = 2;
    end

    for n=start:height(uniqueTable)

        node1=uniqueTable{n,1};
        node2=uniqueTable{n,2};
        combi2= cell2table([node2,node1],'VariableNames',{'Column1','Column2'});

        % check if there is a self-reference and don't add it
        if strcmp(node1,node2)
            selfReferences=[selfReferences;[node1,node2]];

        % check if node is already in edgetable (should not be the case
        % if unique worked correctly)                    
        elseif sum(ismember(noRepsTable,uniqueTable(n,:),'rows')) == 0

            % check if other combination of node is in edgetable
            % if it is not as well, add first combination of node to edgetable 
            % else, add it to repetition list

            if sum(ismember(noRepsTable,combi2,'rows')) == 0          
               noRepsTable=[noRepsTable;uniqueTable(n,:)]; 

            else    
                repetitions=[repetitions;uniqueTable(n,:)];

            end
        else
            disp('something went wrong with unique');
        end



    end


    % create edgetable in merging column 1 and 2 into one variable EndNodes
    EdgeTable= mergevars(noRepsTable,{'Column1','Column2'},'NewVariableName','EndNodes');

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

        overviewMaxDiameter(indexParts).BodyPosition_x = [gazesData(timeIndexB:timeIndex).playerBodyPosition_x]; 
        overviewMaxDiameter(indexParts).BodyPosition_z = [gazesData(timeIndexB:timeIndex).playerBodyPosition_z];








end




save([savepath 'overviewMaxDiameter.mat'],'overviewMaxDiameter');










