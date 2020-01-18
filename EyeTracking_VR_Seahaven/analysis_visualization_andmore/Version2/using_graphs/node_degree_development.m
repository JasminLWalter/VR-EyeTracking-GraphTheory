%% ------------------ node_degree_development-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\individual\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file = strcat('gazes_data_',num2str(currentPart),'.mat');
 
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
        
        % create houseList
        uniqueHouses= unique(gazedObjects.House);
        houseList = uniqueHouses;
        % remove noData, NH, sky
        iNH = strcmp(houseList(:),cellstr('NH'));
        houseList(iNH,:) =[];
        
        isky = strcmp(houseList(:),cellstr('sky'));
        houseList(isky,:) =[];
        
        inoData = strcmp(houseList(:),cellstr('noData'));
        houseList(inoData,:) =[];
            
        
%         NodeTable= cell2table(uniqueHouses, 'VariableNames',{'Name'});
        
        % 30 samples in one second - 1 min has 1800 samples
        indexTimeStamps = [];
        lastI = 1;
        for index = 1 : height(gazedObjects)
            sumSamples = sum(gazedObjects.Samples(lastI:index));
            
            if sumSamples >= 1800
               indexTimeStamps = [indexTimeStamps, index];
               lastI = index;
                
            end
            
        end
        
        % struct - 
        a = length(houseList);
        b = length(indexTimeStamps);
        

        degreeNaN = array2table(NaN(a,b));
        degreeHouses = table(houseList);
        degreeDevelopment = [degreeHouses,degreeNaN];
        
        for index2 = 1:length(indexTimeStamps)
            
            currentIndex = indexTimeStamps(index2);
            currentObjects = gazedObjects(1:currentIndex,:);
            
            % remove all NH and sky elements
            nohouse=strcmp(currentObjects.House(:),cellstr('NH')) | strcmp(currentObjects.House(:),cellstr('sky'));
            housesTable = currentObjects;
            housesTable(nohouse,:)=[];   




        
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
        
        
        graphynoData = graph(EdgeTable);
        
        
        
        %% remove node noData from graph
      
        if findnode(graphynoData, 'noData') > 0 
    
            graphy = rmnode(graphynoData, 'noData');
        else
            graphy = graphynoData;
            
        end
        
        %% get node degree info
        degreeG= degree(graphy);
        nodeDegreeTable = graphy.Nodes;
        nodeDegreeTable.Edges = degreeG;
        
        for index3= 1:height(nodeDegreeTable)            
           houseIndex = strcmp(nodeDegreeTable{index3,1},degreeDevelopment{:,1});
           degreeDevelopment(houseIndex,index2+1) = nodeDegreeTable(index3,2);
        end
        
   
        end
        

%         
%        save degreeDevelopment Overview
         save([savepath num2str(currentPart) '_degreeDevelopment.mat'],'degreeDevelopment');
      
    else
        disp('something went really wrong with participant list');
    end

end


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

 csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
 disp('saved missing participant file list');

disp('done');