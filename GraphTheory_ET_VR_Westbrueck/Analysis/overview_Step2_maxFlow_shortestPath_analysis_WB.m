%% ------------------ maxFlow_shortestPath_analysis_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


clear all;

%% adjust the following variables: 

savepath = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

cd 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Analysis\P2B_controls_analysis\';

pathGraphs = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\graphs\';
pathGraphsWeighted = 'F:\Westbrueck Data\SpaRe_Data\1_Exploration\Pre-processsing_pipeline\graphs_weighted\';

overviewTableP2BPrep1 = readtable('selectedData_P2B_control.csv');


% 26 participants
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

lastPart = 0;
for index = 1:height(overviewTableP2BPrep1)
    
    
    currentPart = overviewTableP2BPrep1.SubjectID(index);   
   
    if not(currentPart == lastPart)
        %load graph
        disp(currentPart)
        graphy = load(strcat(pathGraphs,num2str(currentPart),'_Graph_WB.mat'));
        graphy= graphy.graphy;

        graphyW = load(strcat(pathGraphsWeighted, num2str(currentPart),'_Graph_weighted_WB.mat'));
        graphyW = graphyW.graphyW;
        
        degreeT1 = degree(graphy);
        degreeT2weighted = centrality(graphyW,'degree','Importance',graphyW.Edges.Weight);
    end
    
    %% node degree
    
    sB = strcmp(overviewTableP2BPrep1.StartBuildingName(index),graphy.Nodes.Name);
    tB = strcmp(overviewTableP2BPrep1.TargetBuildingName(index),graphy.Nodes.Name);
    overviewTableP2BPrep1.NodeDegreeStartBuilding(index) = degreeT1(sB);
    overviewTableP2BPrep1.NodeDegreeTargetBuilding(index) = degreeT1(tB);
    
    overviewTableP2BPrep1.NodeDegreeWeightedStartBuilding(index) = degreeT2weighted(sB);
    overviewTableP2BPrep1.NodeDegreeWeightedTargetBuilding(index) = degreeT2weighted(tB);
    
  

    %% max Flow
    maxFlowS = maxflow(graphy,overviewTableP2BPrep1.StartBuildingName(index),overviewTableP2BPrep1.TargetBuildingName(index));
    maxFlowWeighted = maxflow(graphyW,overviewTableP2BPrep1.StartBuildingName(index),overviewTableP2BPrep1.TargetBuildingName(index));

    [Path,distance]=shortestpath(graphy, overviewTableP2BPrep1.StartBuildingName(index),overviewTableP2BPrep1.TargetBuildingName(index));
    
    overviewTableP2BPrep1.MaxFlowS(index) = maxFlowS;
    overviewTableP2BPrep1.MaxFlowWeighted(index) = maxFlowWeighted;
    overviewTableP2BPrep1.ShortestPathDistance(index) = distance;
    
    %% edgeweight
    
%     selection1 = ismember(cell2table(graphyW.Edges.EndNodes), table(overviewTableP2BPrep1.StartBuildingName(index),overviewTableP2BPrep1.TargetBuildingName(index)),'rows');
%     selection2 = ismember(cell2table(graphyW.Edges.EndNodes), table(overviewTableP2BPrep1.TargetBuildingName(index),overviewTableP2BPrep1.StartBuildingName(index)),'rows');
%     
%     selection12 = selection1 | selection2;
%     if(sum(selection12) == 0)
%         overviewTableP2BPrep1.EdgeWeight(index) = NaN;
%     elseif (sum(selection12) == 2)
%         disp('BIG PROBLEM EDGE WEIGHT!!!!!!!!');
%     else
%         overviewTableP2BPrep1.EdgeWeight(index) = graphyW.Edges.Weight(selection12);
%     
%     end
%     
%     
    
    lastPart = currentPart;

end

% 
save overview
save([savepath 'overviewTable_P2B_Prep_stage1.mat'],'overviewTableP2BPrep1');
writetable(overviewTableP2BPrep1, [savepath, 'overviewTable_P2B_Prep_stage1.csv']);

disp('Data saved')


disp(strcat(num2str(Number), ' Participants analysed'));
disp(strcat(num2str(countMissingPart),' files were missing'));

csvwrite(strcat(savepath,'Missing_Participant_Files'),noFilePartList);
disp('saved missing participant file list');

disp('done');

