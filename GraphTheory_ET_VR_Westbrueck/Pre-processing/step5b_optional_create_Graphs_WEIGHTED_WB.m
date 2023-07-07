%% ------------------ create_Graphs b - weighted - Version Westbrook-------------------------------------
% script written by Jasmin Walter

% 5th and last step of prepreocessing pipeline to create graphs from VR
% data
% step unnecessary if analysis does not involve graphs
% creates graph objects using gazesObject files
% removes all repetition and self references from graphs
% removes noData node after creation of graph
% output: graph objects for every participant

clear all;


savepath= 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\graphs_weighted\';


cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\gazes_vs_noise\'

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


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
        gazedTable.hitObjectColliderName = [gazesData.hitObjectColliderName]';
%         gazedTable.Samples = [gazedObjects.Samples]';
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        % remove all NH and sky elements
        nohouse=strcmp(gazedTable.hitObjectColliderName(:),{'NH'});
        housesTable = gazedTable;
        housesTable(nohouse,:)=[];
        
        
         % create nodetable
        uniqueHouses= unique(housesTable.hitObjectColliderName(:));
        NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});
        
        % create edge table
        
        fullEdgeT= cell2table(housesTable.hitObjectColliderName,'VariableNames',{'Column1'});
        
        
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

    
        graphyW = rmnode(graphyNoData, 'noData');
        graphyW = rmnode(graphyW, 'newSession');
        
%% add weights
        
        graphEdges = graphyW.Edges.EndNodes;
        weights = zeros(length(graphEdges),1);
        helperT = table;
        
        for index = 1: length(graphEdges)
            edge1 = graphEdges(index,1);
            edge2 = graphEdges(index,2);
            
            % find first edge direction
            helperT.Column1 = edge1;
            helperT.Column2 = edge2;
            find1 = ismember(fullEdgeT, helperT);
            sum1 = sum(find1);
            
            % find second edge direction
            helperT.Column1 = edge2;
            helperT.Column2 = edge1;
            find2 = ismember(fullEdgeT, helperT);
            sum2 = sum(find2);
            
            weights(index,1) = sum1+sum2;

        end
        
        graphyW.Edges.Weight = weights;
        
%% save graph
        save([savepath num2str(currentPart) '_Graph_weighted_WB.mat'],'graphyW');
        
    else
        disp('something went really wrong with participant list');
    end

end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');