%% ------------------ temp_development_1min_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 
% Input:  
% gazes_data_V3.mat = a new data file containing all gazes

% Output:
% 


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------

savepath= 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\tempDevelopment\1minSections\';

cd 'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step3_gazeProcessing\';

colliderList = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\building_collider_list.csv');

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

timeSegment = 60; %(1 min)  
%-------------------------------------------------------------------------------

Number = length(PartList);


% overviews
% overviewClusterDuration = zeros(Number,1);
overviewNrViewedBuildings = zeros(Number,151);
overviewNrEdges = zeros(Number,151);
overviewDensity = zeros(Number,151);
overviewDiameter = zeros(Number,151);
overviewIndices = zeros(Number,151);



for indexParts = 1:Number
    tic

    %% load and combine gaze data

    disp(['Paritipcant ', num2str(indexParts)])
    currentPart = cell2mat(PartList(indexParts));

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
    
    
    %% do 1 min segments based on the time stamps - keep track of the session changes
    
    
    indexList = [];
    timeStampIndex = [];
    firstTS_session = gazesData.timeStampRS(1);
    sumPreviousSessions = 0;
    newSum = 0;
    
    for indexCalc = 2:height(gazesData)
        % if a new session is started, update the overall sum until this
        % point, then update the first time stamp, to correctly calculate
        % the experiment time
        if(strcmp(gazesData.hitObjectColliderName(indexCalc), 'newSession'))
            if(not(indexCalc == height(gazesData)))
                newSum = gazesData.timeStampRS(indexCalc-1) - firstTS_session;
                sumPreviousSessions = sumPreviousSessions + newSum;
                firstTS_session = gazesData.timeStampRS(indexCalc+1);
                
            end
        else
            newSum = gazesData.timeStampRS(indexCalc) - firstTS_session;
            currentSum = sumPreviousSessions + newSum;
            if(currentSum >= (timeSegment + timeSegment*(length(indexList))))
                indexList = [indexList,indexCalc];
            end
        end
        
    end
    indexList = [indexList, height(gazesData)];

    if (length(indexList) < 151)

        indexList = [indexList, height(gazesData)];
    end
    
    overviewIndices(indexParts,:) = indexList;

    
    for index1min = 1:length(indexList)
        currentLoc = indexList(index1min);

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



     %    %% 2nd round using for loop
     % 
     %    %check if first entry is a self-reference
     %    %create edgetable
     % 
     %    if (strcmp(uniqueTable{1,1},uniqueTable{1,2}))
     %        % if self-reference start noRepsTable with second entry
     %         noRepsTable= uniqueTable(2,:);
     %         noRepsTable.Properties.VariableNames = {'Column1','Column2'};
     % 
     %         repetitions={};
     %         selfReferences={};
     %         start = 3;
     %    else
     % 
     %         noRepsTable= uniqueTable(1,:);
     %         noRepsTable.Properties.VariableNames = {'Column1','Column2'};
     % 
     %         repetitions={};
     %         selfReferences={};
     %         start = 2;
     %    end
     % 
     % for n=start:height(uniqueTable)
     % 
     %        node1=uniqueTable{n,1};
     %        node2=uniqueTable{n,2};
     %        combi2= cell2table([node2,node1],'VariableNames',{'Column1','Column2'});
     % 
     %        % check if there is a self-reference and don't add it
     %        if strcmp(node1,node2)
     %            selfReferences=[selfReferences;[node1,node2]];
     % 
     %        % check if node is already in edgetable (should not be the case
     %        % if unique worked correctly)                    
     %        elseif sum(ismember(noRepsTable,uniqueTable(n,:),'rows')) == 0
     % 
     %            % check if other combination of node is in edgetable
     %            % if it is not as well, add first combination of node to edgetable 
     %            % else, add it to repetition list
     % 
     %            if sum(ismember(noRepsTable,combi2,'rows')) == 0          
     %               noRepsTable=[noRepsTable;uniqueTable(n,:)]; 
     % 
     %            else    
     %                repetitions=[repetitions;uniqueTable(n,:)];
     % 
     %            end
     %        else
     %            disp('something went wrong with unique');
     %        end
     % 
     % 
     % 
     % end
     % 
     % 
     %    % create edgetable in merging column 1 and 2 into one variable EndNodes
     %    EdgeTable= mergevars(noRepsTable,{'Column1','Column2'},'NewVariableName','EndNodes');

    %% create graph


        graphyNoData = graph(EdgeTable,NodeTable);



    %% remove node noData and newSession from graph


        graphy = rmnode(graphyNoData, 'noData');
        graphy = rmnode(graphy, 'newSession');


        %% calculate and save graph measures

        nrNodes = height(graphy.Nodes);
        nrEdges = height(graphy.Edges);
        maxEdges = (nrNodes * (nrNodes -1)) / 2;
        density = nrEdges / maxEdges;

        % get diameter
        distanceM = distances(graphy);
        checkInf = isinf(distanceM);
        distanceM(checkInf) = 0;
        diameter = max(max(distanceM));

        % save into overviews
        overviewNrViewedBuildings(indexParts,index1min)= nrNodes;
        overviewNrEdges(indexParts,index1min)= nrEdges;
        overviewDensity(indexParts,index1min)= density;
        overviewDiameter(indexParts,index1min)= diameter;

        if(index1min == length(indexList))

            save([savepath 'graphs\' num2str(currentPart) '_Graph_WB.mat'],'graphy');

        end


    end
    index1min = 1;
    
    toc
end

save([savepath 'overviewNrViewedBuildings_1min.mat'],'overviewNrViewedBuildings');
save([savepath 'overviewNrEdges_1min.mat'],'overviewNrEdges');
save([savepath 'overviewDensity_1min.mat'],'overviewDensity');
save([savepath 'overviewDiameter_1min.mat'],'overviewDiameter');
save([savepath 'overviewIndices_1min.mat'],'overviewIndices');

disp('done');