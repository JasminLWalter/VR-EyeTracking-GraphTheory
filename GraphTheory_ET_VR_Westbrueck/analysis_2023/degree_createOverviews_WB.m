%% ------------------ degree_createOverviews_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 
% 

% Output: 



clear all;

%% adjust the following variables: 
% savepath, clistpath, current folder and participant list!----------------


savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\degree_overviews\';

clistpath = 'D:\Github\VR-EyeTracking-GraphTheory\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location
             

cd 'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs\';
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
overviewCloseness = cell2table(houseNames);
overviewBetweeness = cell2table(houseNames);
overviewPagerank = cell2table(houseNames);
overviewEigenvector = cell2table(houseNames);




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
        degreeG_node= degree(graphy);
        
        nodeDegreeTable = graphy.Nodes;
        nodeDegreeTable.NodeDegree = degreeG_node;
        nodeDegreeTable.Closeness = centrality(graphy, 'closeness');
        nodeDegreeTable.Betweenness = centrality(graphy,'betweenness');
        nodeDegreeTable.Pagerank = centrality(graphy,'pagerank');
        nodeDegreeTable.Eigenvector = centrality(graphy,'eigenvector');
        
        % update overview NodeDegree
        
        currentPartName= strcat('Part_',num2str(currentPart));
        extraVar1= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});
        extraVar2= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});
        extraVar3= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});
        extraVar4= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});
        extraVar5= array2table(zeros(height(overviewNodeDegree),1),'VariableNames',{currentPartName});

        
       for n= 1: height(nodeDegreeTable)
           changer = strcmp(overviewNodeDegree.houseNames(:),nodeDegreeTable{n,1});
           
           extraVar1(changer,1)= nodeDegreeTable(n,2);        
           extraVar2(changer,1)= nodeDegreeTable(n,3);        
           extraVar3(changer,1)= nodeDegreeTable(n,4);        
           extraVar4(changer,1)= nodeDegreeTable(n,5);        
           extraVar5(changer,1)= nodeDegreeTable(n,6);        

       end
        
        % concatinage extraVar and overview
        overviewNodeDegree= [overviewNodeDegree, extraVar1];
        overviewCloseness= [overviewCloseness, extraVar2];
        overviewBetweeness= [overviewBetweeness, extraVar3];
        overviewPagerank= [overviewPagerank, extraVar4];
        overviewEigenvector= [overviewEigenvector, extraVar5];
                
             
        
        
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

writetable(overviewNodeDegree,strcat(savepath,'Overview_NodeDegree.csv'));
writetable(overviewCloseness,strcat(savepath,'Overview_Closeness.csv'));
writetable(overviewBetweeness,strcat(savepath,'Overview_Betweeness.csv'));
writetable(overviewPagerank,strcat(savepath,'Overview_Pagerank.csv'));
writetable(overviewEigenvector,strcat(savepath,'Overview_Eigenvector.csv'));


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');