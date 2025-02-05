%% ------------------ nodeDegree_weighted_createOverview_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 
% Creates the node degree overview file used in other analysis scripts. It
% reads in the graphs from all participants, calculates the node degree
% centrality values for every house and saves it in the overview

% Input: 
% Graph_V3.mat = the gaze graph object for every participant
% CoordinateListNew.txt = csv list of the house names and x,y coordinates 
%                         corresponding to the map of Seahaven


% Output: 
% Overview_NodeDegree.mat = table consisting of all node degree values for
%                           all participants
% Missing_Participant_Files.mat =contains all participant numbers where
%                                the data file could not be loaded



clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\Weighted\NodeDegree_weighted\';
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\graphs_weighted\';
%--------------------------------------------------------------------------

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%load coordinate list

listname = strcat(clistpath,'building_collider_list.csv');
coordinateList = readtable(listname);

houseNames = unique(coordinateList.target_collider_name);

overviewNodeDegreeW = cell2table(houseNames);



for ii = 1:Number
    tic
    disp(ii)
    currentPart = cell2mat(PartList(ii));   
    
    file = strcat(num2str(currentPart),'_Graph_weighted_WB.mat');
 
    % check for missing files
    if exist(file)==0
        countMissingPart = countMissingPart+1;
        
        noFilePartList = [noFilePartList;currentPart];
        disp(strcat(file,' does not exist in folder'));
    %% main code   
    elseif exist(file)==2

        %load graph
        graphy = load(file);
        graphy= graphy.graphyW;
        
        % save degree nodes, edge nodes
        
        % create table with houses and node degree info
        degreeG= centrality(graphy,'degree','Importance',graphy.Edges.Weight);
%         degreeG = centrality(graphy,'degree');
        nodeDegreeTable = graphy.Nodes;
        nodeDegreeTable.Edges = degreeG;
        
        % update overview NodeDegree
        
        currentPartName= strcat('Part_',num2str(currentPart));
        extraVar= array2table(zeros(height(overviewNodeDegreeW),1),'VariableNames',{currentPartName});

        
       for n= 1: height(nodeDegreeTable)
           changer = strcmp(overviewNodeDegreeW.houseNames(:),nodeDegreeTable{n,1});
           
           extraVar(changer,1)= nodeDegreeTable(n,2);        
            
       end
        
        % concatinage extraVar and overview
        overviewNodeDegreeW= [overviewNodeDegreeW extraVar];
             
        
        
    else
        disp('something went really wrong with participant list');
    end
toc
end


% save nodedegree overview
save([savepath 'Overview_NodeDegree_weighted.mat'],'overviewNodeDegreeW');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');