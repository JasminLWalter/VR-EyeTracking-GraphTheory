%% ------------------graph_properties_overview_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath = 'E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\graphMeasures\';


graphPath = 'E:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs\';

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];

%% load hierarchy index

hierarchyIndex = load('E:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\graph-theoretical-analysis\hierarchyIndex\HierarchyIndex_Table.mat');

hierarchyIndex = hierarchyIndex.HierarchyIndex;


%% load graphs and calculate missing measures

% %load coordinate list
% 
% listname = strcat(clistpath,'building_collider_list.csv');
% coordinateList = readtable(listname);
% 
% houseNames = unique(coordinateList.target_collider_name);
% 
% overviewNodeDegreeW = cell2table(houseNames);

overviewGraphMeasures = table;
overviewGraphMeasures.Participants = PartList';


for index = 1:length(PartList)
    currentPart = PartList(index);   
    
    file = strcat(graphPath,num2str(currentPart),'_Graph_WB.mat');
   
    %load graph
    graphy = load(file);
    graphy= graphy.graphy;
    
    % calculate graph measures
    nrNodes = height(graphy.Nodes);
    nrEdges = height(graphy.Edges);
    maxEdges = (nrNodes * (nrNodes -1)) / 2;
    density = height(graphy.Edges) / maxEdges;
    
    % get diameter
    distanceM = distances(graphy);
    checkInf = isinf(distanceM);
    distanceM(checkInf) = 0;
    diameter = max(max(distanceM));
    avgShortestPath = mean(distanceM, "all");
    
    
    % add data to overview
    
    overviewGraphMeasures.nrViewedHouses(index) = nrNodes;
    overviewGraphMeasures.nrEdges(index) = nrEdges;
    overviewGraphMeasures.density(index) = density;
    overviewGraphMeasures.diameter(index) = diameter;
    overviewGraphMeasures.avgShortestPath(index) = avgShortestPath;
    
    
   
end

overviewGraphMeasures.hierarchyIndex = hierarchyIndex.Slope;



% calculate and save the graph measure stats

varNames = overviewGraphMeasures.Properties.VariableNames;
isNumericVar = varfun(@isnumeric, overviewGraphMeasures, 'OutputFormat', 'uniform');
numericVarNames = varNames(isNumericVar);
numericVarNames = setdiff(numericVarNames, {'Participants'}, 'stable');  % exclude ID column

helper = table2array(overviewGraphMeasures(:, numericVarNames));  % N x K


statLabels = {'min'; 'max'; 'median'; 'mean'; 'std'};
statMat = [
    min(helper, [], 1, 'omitnan');
    max(helper, [], 1, 'omitnan');
    median(helper, 1, 'omitnan');
    mean(helper, 1, 'omitnan');
    std(helper, 0, 1, 'omitnan')     % sample std (N-1)
];

overviewGraphMeasureStats = array2table(statMat, 'VariableNames', numericVarNames);
overviewGraphMeasureStats = addvars(overviewGraphMeasureStats, statLabels, ...
'Before', 1, 'NewVariableNames', 'Participants'); 


% saving

writetable(overviewGraphMeasures, [savepath 'overviewGraphMeasures.csv']);
writetable(overviewGraphMeasureStats, [savepath 'overviewGraphMeasureStats.csv']);

disp('done')
