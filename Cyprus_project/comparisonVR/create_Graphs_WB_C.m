%% ------------------ step4_create_Graphs_velocityBased_WB----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% 5th and last step of prepreocessing pipeline.
% The script creates the gaze graphs from the gaze events
% This step is unnecessary if analysis does not involve graphs
% The script creates unweighted and binary graph objects the gaze events. 
% To achieve this it removes all repetition and self references from graphs
% and removes noData node after creation of graph

% Input:  
% gazes_data_V3.mat = a new data file containing all gazes

% Output:
% Graph_V3.mat = the gaze graph object for every participant
% Missing_Participant_Files.mat = contains all participant numbers where the
%                                  data file could not be loaded


clear all;

%% adjust the following variables: savepath, current folder and participant list!-----------


savepath= 'F:\Cyprus_project_overview\data\comparison2VR\graphs_WB\';



cd 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step3_gazeProcessing\';

colliderList = readtable('D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\building_collider_list.csv');

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};
% PartList = {1004 1005 1008 1010 1011 1013};

%-------------------------------------------------------------------------------


Number = length(PartList);
noFilePartList = [Number];
missingFiles = table;



for indexPart = 1:Number
    tic
    
    disp(['Paritipcant ', num2str(indexPart)])
    currentPart = cell2mat(PartList(indexPart));

    gazesData = table;

    
    % loop over recording sessions (should be 5 for each participant)
    for indexSess = 1:2
        
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
            %% Main part - runs if files exist!        
            % loop over ET sessions and check data  

             if indexSess == 2

                maxET = 1;
            else
                maxET = length(dirSess);
            end

            for indexET = 1:maxET
                tic
                disp(['Process file: ', num2str(currentPart), '_Session_', num2str(indexSess),'_ET_', num2str(indexET)]);
                % read in the data
                % data = readtable([num2str(1004) '_Session_1_ET_1_data_correTS_mad_wobig.csv']);
                data = readtable(dirSess(indexET).name);

                fixations = data.events == 2.0;
                noData = data.events == 3;
                data.namesNH(noData) = {'noData'};

                gazesTable = table;
                gazesTable.name = data.namesNH(fixations|noData);
                gazesTable.name(end+1) = {'newSession'};

                isEmpty = ismissing(gazesTable.name);
                gazesTable.name(isEmpty) = {'noData'};

                gazesData = [gazesData; gazesTable];


            end
        end
    end

                
    % remove all elements that are not a building 
    % and not the new session and noData markers

    uniqueBuildingNames = unique(colliderList.target_collider_name);
    
    isInColliderList = false(height(gazesData),1);
    
    for indexNH = 1: length(uniqueBuildingNames)
        
        currentB = uniqueBuildingNames(indexNH);
        locBuilding1 = strcmp(currentB, gazesData.name);
        
        isInColliderList = isInColliderList | locBuilding1;
        
    end

    gazesData(~isInColliderList,:) = [];
                
    % create nodetable
    uniqueHouses= unique(gazesData.name(:));
    NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});
    
    % create edge table
    
    fullEdgeT= cell2table(gazesData.name,'VariableNames',{'Column1'});
    
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
    
%% save graph
    save([savepath num2str(currentPart) '_Graph_WB.mat'],'graphy');

  toc
end

if(height(missingFiles)<1)
    disp('no files were missing')
else
    disp(missingFiles)
end


disp('done');