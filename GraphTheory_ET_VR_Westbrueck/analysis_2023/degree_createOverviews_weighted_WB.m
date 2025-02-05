%% ------------------ degree_createOverviews_WEIGHTED_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 
% 

% Output: 



clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\degree_overviews\';
clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

cd 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs_WEIGHTED\';
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

overviewNodeDegree_weighted = cell2table(houseNames);
overviewPagerank_weighted = cell2table(houseNames);
overviewEigenvector_weighted = cell2table(houseNames);




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
        graphyW = load(file);
        graphyW= graphyW.graphyW;
        
        % save degree nodes, edge nodes
        
        % create table with houses and node degree info
        degreeG_node= degree(graphyW);
        
        nodeDegreeTable = graphyW.Nodes;
        nodeDegreeTable.NodeDegree = centrality(graphyW, 'degree', 'Importance', graphyW.Edges.Weight);

        nodeDegreeTable.Pagerank = centrality(graphyW,'pagerank','Importance', graphyW.Edges.Weight);
        nodeDegreeTable.Eigenvector = centrality(graphyW,'eigenvector','Importance', graphyW.Edges.Weight);
        
        % update overview NodeDegree
        
        currentPartName= strcat('Part_',num2str(currentPart));
        extraVar1= array2table(zeros(height(overviewNodeDegree_weighted),1),'VariableNames',{currentPartName});
        extraVar2= array2table(zeros(height(overviewNodeDegree_weighted),1),'VariableNames',{currentPartName});
        extraVar3= array2table(zeros(height(overviewNodeDegree_weighted),1),'VariableNames',{currentPartName});

        
       for n= 1: height(nodeDegreeTable)
           changer = strcmp(overviewNodeDegree_weighted.houseNames(:),nodeDegreeTable{n,1});
           
           extraVar1(changer,1)= nodeDegreeTable(n,2);        
           extraVar2(changer,1)= nodeDegreeTable(n,3);        
           extraVar3(changer,1)= nodeDegreeTable(n,4);        
    

       end
        
        % concatinage extraVar and overview
        overviewNodeDegree_weighted= [overviewNodeDegree_weighted, extraVar1];
        overviewPagerank_weighted= [overviewPagerank_weighted, extraVar2];
        overviewEigenvector_weighted= [overviewEigenvector_weighted, extraVar3];
                
             
        
        
    else
        disp('something went really wrong with participant list');
    end
toc
end


% save nodedegree overview
% save([savepath 'Overview_NodeDegree.mat'],'overviewNodeDegree');
% save([savepath 'Overview_Closeness.mat'],'overviewCloseness');
% save([savepath 'Overview_Betweeness.mat'],'overviewBetweeness');
% save([savepath 'Overview_Pagerank.mat'],'overviewPagerank');
% save([savepath 'Overview_Eigenvector.mat'],'overviewEigenvector');

writetable(overviewNodeDegree_weighted,strcat(savepath,'Overview_NodeDegree_weighted.csv'));
writetable(overviewPagerank_weighted,strcat(savepath,'Overview_Pagerank_weighted.csv'));
writetable(overviewEigenvector_weighted,strcat(savepath,'Overview_Eigenvector_weighted.csv'));


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');