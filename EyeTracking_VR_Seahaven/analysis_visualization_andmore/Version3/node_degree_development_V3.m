%% ------------------ node_degree_development_V3-------------------------------------

% --------------------script written by Jasmin L. Walter----------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------



clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\analysis\time_development\nodeDegree_development\individual_files\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\Version03\preprocessing\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};

houseList = load('D:\Github\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\HouseList.mat');
houseList = houseList.houseList;


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;



for ii = 1:Number
    
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat(num2str(currentPart),'_gazes_data_V3.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2
        
        
        % load data
        gazedObjects = load(file);
        gazedObjects = gazedObjects.gazedObjects;
        
        currentPartName= strcat('Participant_',num2str(currentPart));
        
        % identify the session switches
        sessIndex= find(strcmp({gazedObjects.Collider}, 'newSession'));
        
        %identify lengths of each sessions
        length1 = sessIndex(1)-1;
        length2 = sessIndex(2)-1;
        length3 = length(gazedObjects);
        

        
        %% take care of the first session
        
        structIndex = [];
        stampEndPoints = [];
        goalStamp = 60; % timestamps are in seconds
        
        for index1 = 1: length1
            
            currentStamp = gazedObjects(index1).TimeStamp(end);
            if currentStamp >= goalStamp
                dist1 = currentStamp - goalStamp;
                dist2 = goalStamp - gazedObjects(index1-1).TimeStamp(end);
                if(dist1 <= dist2)
                    structIndex = [structIndex, index1];
                    stampEndPoints = [stampEndPoints, currentStamp];
                else
                    structIndex = [structIndex, index1-1];
                    stampEndPoints = [stampEndPoints, gazedObjects(index1-1).TimeStamp(end)];     
                end 
                goalStamp = goalStamp + 60;
            end
        end
        
        % add last data until the end of the first session (data < 1min)
        if not(structIndex(end)==length1)
            structIndex = [structIndex, length1];
            stampEndPoints = [stampEndPoints, gazedObjects(length1).TimeStamp(end)];     
                    
        end
        
        
        % build table overview
        rows = ['TimeStampEndPoint';houseList];
        degreeNaN = array2table(NaN(length(rows),length(stampEndPoints)));
        degreeHouses = table(rows);
        degreeDevelopment = [degreeHouses,degreeNaN];
        
        degreeDevelopment{1,2:end} = stampEndPoints;
        
        % build the graph
        for indexSL1 = 1:length(structIndex)
            
            currentIndex = structIndex(indexSL1);
            currentObjects = gazedObjects(1:currentIndex);
            
            
            gazedTable = table;
            gazedTable.Collider = {currentObjects.Collider}';
            gazedTable.Samples = [currentObjects.Samples]';

            currentPartName= strcat('Participant_',num2str(currentPart));

            % remove all NH and sky elements
            nohouse=strcmp(gazedTable.Collider(:),cellstr('NH')) | strcmp(gazedTable.Collider(:),cellstr('sky'));
            housesTable = gazedTable;
            housesTable(nohouse,:)=[];

            % create nodetable
            uniqueHouses= unique(housesTable.Collider);
            NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

            % create edge table

            fullEdgeT= cell2table(housesTable.Collider,'VariableNames',{'Column1'});

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

      % create graph


            graphyNoData = graph(EdgeTable,NodeTable);



    % remove node noData and newSession from graph if they are in graph

            
            if findnode(graphyNoData, 'noData') > 0 
                graphy = rmnode(graphyNoData, 'noData');
                
            elseif findnode(graphy, 'newSession') > 0
                graphy = rmnode(graphy, 'newSession');
                
            else
                graphy = graphyNoData;

            end
          

            % get node degree info
            degreeG= degree(graphy);
            nodeDegreeTable = graphy.Nodes;
            nodeDegreeTable.Edges = degreeG;

            for index3= 1:height(nodeDegreeTable)            
               houseIndex = strcmp(nodeDegreeTable{index3,1},degreeDevelopment{:,1});
               degreeDevelopment(houseIndex,indexSL1+1) = nodeDegreeTable(index3,2);
            end


         end
        

%         
%        save degreeDevelopment Overview
         save([savepath num2str(currentPart) '_degreeDevelopment_Session1.mat'],'degreeDevelopment');
      %% taking care of the second session (a bit uggly coding with the repetition)
      
        structIndex = [];
        stampEndPoints = [];
        goalStamp = 60; % timestamps are in seconds
        
        for index1 = length1 : length2
            
            currentStamp = gazedObjects(index1).TimeStamp(end);
            if currentStamp >= goalStamp
                dist1 = currentStamp - goalStamp;
                dist2 = goalStamp - gazedObjects(index1-1).TimeStamp(end);
                if(dist1 <= dist2)
                    structIndex = [structIndex, index1];
                    stampEndPoints = [stampEndPoints, currentStamp];
                else
                    structIndex = [structIndex, index1-1];
                    stampEndPoints = [stampEndPoints, gazedObjects(index1-1).TimeStamp(end)];     
                end 
                goalStamp = goalStamp + 60;
            end
        end
        
        % add last data until the end of the first session (data < 1min)
        if not(structIndex(end)==length2)
            structIndex = [structIndex, length2];
            stampEndPoints = [stampEndPoints, gazedObjects(length2).TimeStamp(end)];     
                    
        end
        
        
        % build table overview
        rows = ['TimeStampEndPoint';houseList];
        degreeNaN = array2table(NaN(length(rows),length(stampEndPoints)));
        degreeHouses = table(rows);
        degreeDevelopment = [degreeHouses,degreeNaN];
        
        degreeDevelopment{1,2:end} = stampEndPoints;
        
        % build the graph
        for indexSL1 = 1:length(structIndex)
            
            currentIndex = structIndex(indexSL1);
            currentObjects = gazedObjects(1:currentIndex);
            
            
            gazedTable = table;
            gazedTable.Collider = {currentObjects.Collider}';
            gazedTable.Samples = [currentObjects.Samples]';

            currentPartName= strcat('Participant_',num2str(currentPart));

            % remove all NH and sky elements
            nohouse=strcmp(gazedTable.Collider(:),cellstr('NH')) | strcmp(gazedTable.Collider(:),cellstr('sky'));
            housesTable = gazedTable;
            housesTable(nohouse,:)=[];

            % create nodetable
            uniqueHouses= unique(housesTable.Collider);
            NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

            % create edge table

            fullEdgeT= cell2table(housesTable.Collider,'VariableNames',{'Column1'});

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

      % create graph


            graphyNoData = graph(EdgeTable,NodeTable);



    % remove node noData and newSession from graph if they are in graph

            
            if findnode(graphyNoData, 'noData') > 0 
                graphy = rmnode(graphyNoData, 'noData');
                
            elseif findnode(graphy, 'newSession') > 0
                graphy = rmnode(graphy, 'newSession');
                
            else
                graphy = graphyNoData;

            end
          

            % get node degree info
            degreeG= degree(graphy);
            nodeDegreeTable = graphy.Nodes;
            nodeDegreeTable.Edges = degreeG;

            for index3= 1:height(nodeDegreeTable)            
               houseIndex = strcmp(nodeDegreeTable{index3,1},degreeDevelopment{:,1});
               degreeDevelopment(houseIndex,indexSL1+1) = nodeDegreeTable(index3,2);
            end


         end
        

%         
%        save degreeDevelopment Overview
         save([savepath num2str(currentPart) '_degreeDevelopment_Session2.mat'],'degreeDevelopment');
         
         %% taking care of the third session
         
        structIndex = [];
        stampEndPoints = [];
        goalStamp = 60; % timestamps are in seconds

        for index1 = length2: length3

            currentStamp = gazedObjects(index1).TimeStamp(end);
            if currentStamp >= goalStamp
                dist1 = currentStamp - goalStamp;
                dist2 = goalStamp - gazedObjects(index1-1).TimeStamp(end);
                if(dist1 <= dist2)
                    structIndex = [structIndex, index1];
                    stampEndPoints = [stampEndPoints, currentStamp];
                else
                    structIndex = [structIndex, index1-1];
                    stampEndPoints = [stampEndPoints, gazedObjects(index1-1).TimeStamp(end)];     
                end 
                goalStamp = goalStamp + 60;
            end
        end

        % add last data until the end of the first session (data < 1min)
        if not(structIndex(end)==length3)
            structIndex = [structIndex, length3];
            stampEndPoints = [stampEndPoints, gazedObjects(length3).TimeStamp(end)];     

        end


        % build table overview
        rows = ['TimeStampEndPoint';houseList];
        degreeNaN = array2table(NaN(length(rows),length(stampEndPoints)));
        degreeHouses = table(rows);
        degreeDevelopment = [degreeHouses,degreeNaN];

        degreeDevelopment{1,2:end} = stampEndPoints;

        % build the graph
        for indexSL1 = 1:length(structIndex)

            currentIndex = structIndex(indexSL1);
            currentObjects = gazedObjects(1:currentIndex);


            gazedTable = table;
            gazedTable.Collider = {currentObjects.Collider}';
            gazedTable.Samples = [currentObjects.Samples]';

            currentPartName= strcat('Participant_',num2str(currentPart));

            % remove all NH and sky elements
            nohouse=strcmp(gazedTable.Collider(:),cellstr('NH')) | strcmp(gazedTable.Collider(:),cellstr('sky'));
            housesTable = gazedTable;
            housesTable(nohouse,:)=[];

            % create nodetable
            uniqueHouses= unique(housesTable.Collider);
            NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});

            % create edge table

            fullEdgeT= cell2table(housesTable.Collider,'VariableNames',{'Column1'});

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

      % create graph


            graphyNoData = graph(EdgeTable,NodeTable);



    % remove node noData and newSession from graph if they are in graph


            if findnode(graphyNoData, 'noData') > 0 
                graphy = rmnode(graphyNoData, 'noData');

            elseif findnode(graphy, 'newSession') > 0
                graphy = rmnode(graphy, 'newSession');

            else
                graphy = graphyNoData;

            end


            % get node degree info
            degreeG= degree(graphy);
            nodeDegreeTable = graphy.Nodes;
            nodeDegreeTable.Edges = degreeG;

            for index3= 1:height(nodeDegreeTable)            
               houseIndex = strcmp(nodeDegreeTable{index3,1},degreeDevelopment{:,1});
               degreeDevelopment(houseIndex,indexSL1+1) = nodeDegreeTable(index3,2);
            end


         end


%         
%        save degreeDevelopment Overview
         save([savepath num2str(currentPart) '_degreeDevelopment_Session3.mat'],'degreeDevelopment');


      
    else
        disp('something went really wrong with participant list');
    end

end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');