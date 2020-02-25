%% ------------------ graphAnalysis_Degree_V2---------------------------------
% script written by Jasmin Walter

% created overview table of node degree information of all participants

clear all;

savepath = 'E:\NBP\SeahavenEyeTrackingData\90minVR\analysis\graphs\node_degree\';

cd 'E:\NBP\SeahavenEyeTrackingData\90minVR\duringProcessOfCleaning\graphs\'

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {21 22 23 24 26 27 28 30 31 33 34 35 36 37 38 41 43 44 45 46};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%load house list
housedata= load('C:\Users\Jaliminchen\Documents\GitHub\NBP-VR-Eyetracking\EyeTracking_VR_Seahaven\additional_files\HouseList.mat');
houseList= housedata.houseList;

overviewNodeDegree = cell2table(houseList);



for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    file = strcat(num2str(currentPart),'_Graph.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2

        %load graph
        graphy = load(file);
        graphy= graphy.graphy;
        
        % save degree nodes, edge nodes
        
        % create table with houses and node degree info
        degreeG= degree(graphy);
        
        nodeDegreeTable = graphy.Nodes;
        nodeDegreeTable.Edges = degreeG;
        
        % update overview NodeDegree
        
        currentPartName= strcat('Part_',num2str(currentPart));
        extraVar= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});

        
       for n= 1: height(nodeDegreeTable)
           changer = strcmp(overviewNodeDegree.houseList(:),nodeDegreeTable{n,1});
           
           extraVar(changer,1)= nodeDegreeTable(n,2);        
            
       end
        
        % concatinage extraVar and overview
        overviewNodeDegree= [overviewNodeDegree extraVar];
             
        
        
    else
        disp('something went really wrong with participant list');
    end

end


% save nodedegree overview
save([savepath 'Overview_NodeDegree.mat'],'overviewNodeDegree');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');