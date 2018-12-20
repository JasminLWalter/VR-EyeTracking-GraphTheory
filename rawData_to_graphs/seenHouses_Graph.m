%% ------------------ seenHouses_Graph-------------------------------------
% script written by Jasmin Walter

% removes all repetition and self references
% creates graph objects using seenHouses files
% output: graph objects for every participant

clear all;


savepath= 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\graphs\';

saveID_overview='10.08';

cd 'E:\Data_SeaHaven_Backup_sortiert\Jasmin Eyetracking data\Data_after_Script\seen_vs_glanced\'

PartList = {1882,1809,5699,1003,3961,6525,2907,5324,3430,4302,7561,6348,4060,6503,7535,1944,8457,3854,2637,7018,8580,1961,6844,1119,5287,3983,8804,7350,7395,3116,1359,8556,9057,4376,8864,8517,9434,2051,4444,5311,5625,1181,9430,2151,3251,6468,8665,4502,5823,2653,7666,8466,3093,9327,7670,3668,7953,1909,1171,8222,9471,2006,8258,3377,1529,9364,5583};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;


overviewGraph= cell2table(houseList,'VariableNames',{'House'});


for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat('seen_Houses_',num2str(currentPart),'.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        % load data
        seenHouses = load(file);
        seenHouses = seenHouses.seenHouses;
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        % remove all NH and sky elements
        nohouse=strcmp(seenHouses.House(:),cellstr('NH')) | strcmp(seenHouses.House(:),cellstr('sky'));
        housesTable = seenHouses;
        housesTable(nohouse,:)=[];
        
        % create nodetable
        uniqueHouses= unique(housesTable.House);
        NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});
        
        % create edge table
        
        fullEdgeT= cell2table(housesTable.House,'VariableNames',{'Column1'});
        
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
        
     for n=1:height(uniqueTable)
         % in first round create edgetable
         if n==1
             noRepsTable= uniqueTable(1,:);
             noRepsTable.Properties.VariableNames = {'Column1','Column2'};
             
             repetitions={};
             selfReferences={};
             
        
         else
            % then continue
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
               
            
     end
    
      
        % create edgetable in merging column 1 and 2 into one variable EndNodes
        EdgeTable= mergevars(noRepsTable,{'Column1','Column2'},'NewVariableName','EndNodes');
                
  %% create graph
        
        
        % create graph and plot it
        %nameGraphy= strcat(num2str(currentPart),'_Graph');
        %figure('Name',nameGraphy,'IntegerHandle', 'off');
        
        graphy = graph(EdgeTable,NodeTable);
        % in this case nodenames are only shown if there is enought space
        % to see them
        %plot(graphy)
        % if nodenames should always be shown:
        %plot(graphy,'NodeLabelMode','auto')
        
        % save graph
        save([savepath num2str(currentPart) '_Graph.mat'],'graphy');
        

        
%         % create table with houses and node degree info
%         uniqueEInfo= degree(uniqueGraph);
%         
%         UniqueNodeEdgesTable = nodetable;
%         UniqueNodeEdgesTable.Edges = uniqueEInfo;
%         
%         % update overview unique graph
%         
%         extraVar= array2table(uniqueEInfo,'VariableNames',{currentPartName});
%         
%         overviewUniqueGraph=[overviewUniqueGraph extraVar];
%         

%         %% Plot a boxplot of unique nodes
%         housesEdges= UniqueNodeEdgesTable;
%         
%         % remove sky and NH catagory
%         housesEdges(length(housesEdges.Edges),:)=[];
%         housesEdges(length(housesEdges.Edges),:)=[];
%         
%         % remove Zeros
%         iszero = housesEdges.Edges==0;
%         
%         housesEdges(iszero,:)=[];
%         
%         
%         
%         name3= 'distribution of degrees of nodes in unique Graph';
%         figure('Name',name3,'IntegerHandle', 'off');
%         boxplot(housesEdges.Edges,'Label','NodeDegrees')
%         
%         title(name3);
       
        
%         % create table with houses and node degree info
%         nhEInfo= degree(nhGraph);
%         
%         nhNodeEdgesTable = NHnodetable;
%         nhNodeEdgesTable.Edges = nhEInfo;
%         
%         % update overview unique graph
%         
%         extraVar= array2table(nhEInfo,'VariableNames',{currentPartName});
              
    
        

        
    else
        disp('something went really wrong with participant list');
    end

end
% % save overviews
% save([savepathOV saveID_overview '_overview_full_Graphs.mat'],'overviewFullGraph');
% save([savepathOV saveID_overview '_overview_unique_Graphs.mat'],'overviewUniqueGraph');
% save([savepathOV saveID_overview '_overview_without_NH_Graphs.mat'],'overviewNHGraph');
% save([savepathOV saveID_overview '_overview_directed_Graphs.mat'],'overviewDirGraph');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');