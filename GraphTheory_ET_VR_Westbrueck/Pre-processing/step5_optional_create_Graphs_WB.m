%% ------------------ step5_optional_create_Graphs_WB----------------------

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


savepath= 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_durationBased_2023\150_min_combined\Step5_graphs\';


cd 'E:\WestbrookProject\SpaRe_Data\control_data\pre-processing_durationBased_2023\150_min_combined\Step4_gazes\';

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};

%-------------------------------------------------------------------------------

Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_gazes_data_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        % load data
        gazesData = load(file);
        gazesData = gazesData.gazes_data;
        % create table with necessary fields
        
        gazedTable = table;
        gazedTable.pipelineDur_collider_name = [gazesData.pipelineDur_collider_name]';
%         gazedTable.Samples = [gazedObjects.Samples]';
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        % remove all NH and sky elements
        nohouse=strcmp(gazedTable.pipelineDur_collider_name(:),{'NH'});
        housesTable = gazedTable;
        housesTable(nohouse,:)=[];
        
        % create nodetable
        uniqueHouses= unique(housesTable.pipelineDur_collider_name(:));
        NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});
        
        % create edge table
        
        fullEdgeT= cell2table(housesTable.pipelineDur_collider_name,'VariableNames',{'Column1'});
        
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
        
    else
        disp('something went really wrong with participant list');
    end

end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');