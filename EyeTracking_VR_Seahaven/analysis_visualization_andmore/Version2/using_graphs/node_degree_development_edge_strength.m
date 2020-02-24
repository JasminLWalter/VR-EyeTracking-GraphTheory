%% ------------------ node_degree_development_edge_strength-------------------------------------
% script written by Jasmin Walter


clear all;


savepath= 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree_development\edge_strength\';


cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\gazes_vs_noise\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21};% 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


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
        
        % table
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
 
        
         
      
        % create edgetable in merging column 1 and 2 into one variable EndNodes
        EdgeTable= mergevars(fullEdgeT,{'Column1','Column2'},'NewVariableName','EndNodes');
                
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