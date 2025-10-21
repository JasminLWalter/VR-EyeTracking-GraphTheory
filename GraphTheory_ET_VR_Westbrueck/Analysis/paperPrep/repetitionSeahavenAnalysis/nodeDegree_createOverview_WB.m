%% ------------------ nodeDegree_createOverview_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Purpose: Creates a node-degree overview across participants. Loads each participant's gaze
%          graph, computes node degree centrality per building, and aggregates into one table.
%
% Usage:
% - Adjust: savepath, clistpath, input folder (cd), and PartList.
% - Run the script in MATLAB.
%
% Inputs:
% - Per participant MAT graph file: <ParticipantID>Graph_WB.mat (variable: graphy)
% - Building list CSV: additional_Files/building_collider_list.csv (column: target_collider_name)
%
% Outputs:
% - Overview (savepath): Overview_NodeDegree.mat (table: houseNames + Part<ID> columns with degree)
% - Missing participant CSV: Missing_Participant_Files
% - Console summary of analyzed vs. missing files
%
% License: GNU General Public License v3.0 (GPL-3.0) (see LICENSE)

clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\NodeDegreeCentrality\';
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

cd 'E:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\graphs\';
%--------------------------------------------------------------------------

% 20 participants with 90 min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

%load coordinate list

listname = strcat(clistpath,'building_collider_list.csv');
coordinateList = readtable(listname);

houseNames = unique(coordinateList.target_collider_name);

overviewNodeDegree = cell2table(houseNames);



for ii = 1:Number
    tic
    disp(ii)
    currentPart = cell2mat(PartList(ii));   
    
    file = strcat(num2str(currentPart),'_Graph_WB.mat');
 
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
           changer = strcmp(overviewNodeDegree.houseNames(:),nodeDegreeTable{n,1});
           
           extraVar(changer,1)= nodeDegreeTable(n,2);        
            
       end
        
        % concatinage extraVar and overview
        overviewNodeDegree= [overviewNodeDegree extraVar];
             
        
        
    else
        disp('something went really wrong with participant list');
    end
toc
end


% save nodedegree overview
save([savepath 'Overview_NodeDegree.mat'],'overviewNodeDegree');


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');