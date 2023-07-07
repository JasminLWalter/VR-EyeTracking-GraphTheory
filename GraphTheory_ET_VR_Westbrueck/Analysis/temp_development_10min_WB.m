%% ------------------ temp_development_10min_WB----------------------

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

savepath= 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\tempDevelopment\10minSections\';

cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\gazes_vs_noise\';

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

timeSegment = 480000; %(8 min)
%-------------------------------------------------------------------------------

Number = length(PartList);


% overviews
overviewNrViewedBuildings = zeros(Number,21);
overviewNrEdges = zeros(Number,21);
overviewDensity = zeros(Number,21);
overviewDiameter = zeros(Number,21);



for indexParts = 1:Number
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


    
    %% do 10 min segments
    indexList = [];
    timeSum = 0;
    for indexCalc = 1:length(gazesData)
        currentSum = sum([gazesData(1:indexCalc).clusterDuration]);
        if(currentSum >= (timeSegment + timeSegment*(length(indexList))))
            indexList = [indexList,indexCalc];
        end
        
    end
    indexList = [indexList, length(gazesData)];

    
    for index10min = 1:length(indexList)
        currentLoc = indexList(index10min);
        
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
        overviewNrViewedBuildings(indexParts,index10min)= nrNodes;
        overviewNrEdges(indexParts,index10min)= nrEdges;
        overviewDensity(indexParts,index10min)= density;
        overviewDiameter(indexParts,index10min)= diameter;
        
    
    end
    
    toc
end

save([savepath 'overviewNrViewedBuildings.mat'],'overviewNrViewedBuildings');
save([savepath 'overviewNrEdges.mat'],'overviewNrEdges');
save([savepath 'overviewDensity.mat'],'overviewDensity');
save([savepath 'overviewDiameter.mat'],'overviewDiameter');

disp('done');