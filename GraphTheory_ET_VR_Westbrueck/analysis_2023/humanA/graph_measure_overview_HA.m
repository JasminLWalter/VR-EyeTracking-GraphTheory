%% ------------------graph_properties_overview_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------


% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath = 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\graph_measures\';


graphPath = 'E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\pre-processing\velocity_based\step4_graphs\';

PartList = [365 1754 2258 2693 3310 4176 4597 4796 4917 5741 6642 7093 7412 7842 8007 8469 8673 9472 9502 9586 9601];

%% load hierarchy index

hierarchyIndex = load('E:\WestbrookProject\HumanA_Data\Experiment1\Exploration_short\analysis\graph-theoretical-analysis\hierarchyIndex\HierarchyIndex_Table.mat');

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

