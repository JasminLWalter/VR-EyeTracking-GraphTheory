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

savepath= 'E:\WestbrookProject\SpaRe_Data\control_data\Analysis\tempDevelopment\1minSections\';

cd 'E:\WestbrookProject\SpaRe_Data\control_data\Pre-processsing_pipeline\gazes_vs_noise\';

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

timeSegment = 60; %(1 min)
%-------------------------------------------------------------------------------

Number = length(PartList);


% overviews
overviewClusterDuration = zeros(Number,1);
overviewNrViewedBuildings = zeros(Number,150);
overviewNrEdges = zeros(Number,150);
overviewDensity = zeros(Number,150);
overviewDiameter = zeros(Number,150);
overviewIndices = zeros(Number,150);



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


    overviewClusterDuration(indexParts,1) = (sum([gazesData.clusterDuration])/1000)/60;
    
    
    %% do 1 min segments based on the time stamps - keep track of the session changes
    
    indexList = [];
    timeStampIndex = [];
    firstTS_session = gazesData(1).timeStampDataPointStart(1);
    sumPreviousSessions = 0;
    newSum = 0;
    
    for indexCalc = 2:length(gazesData)
        % if a new session is started, update the overall sum until this
        % point, then update the first time stamp, to correctly calculate
        % the experiment time
        if(strcmp(gazesData(indexCalc).hitObjectColliderName, 'newSession'))
            if(not(indexCalc == length(gazesData)))
                newSum = gazesData(indexCalc-1).timeStampDataPointStart(1) - firstTS_session;
                sumPreviousSessions = sumPreviousSessions + newSum;
                firstTS_session = gazesData(indexCalc+1).timeStampDataPointStart(1);
                
            end
        else
            newSum = gazesData(indexCalc).timeStampDataPointStart(1) - firstTS_session;
            currentSum = sumPreviousSessions + newSum;
            if(currentSum >= (timeSegment + timeSegment*(length(indexList))))
                indexList = [indexList,indexCalc];
            end
        end
        
    end
    indexList = [indexList, length(gazesData)];
    
    overviewIndices(indexParts,:) = indexList;

    
    for index1min = 1:length(indexList)
        currentLoc = indexList(index1min);

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
        overviewNrViewedBuildings(indexParts,index1min)= nrNodes;
        overviewNrEdges(indexParts,index1min)= nrEdges;
        overviewDensity(indexParts,index1min)= density;
        overviewDiameter(indexParts,index1min)= diameter;


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