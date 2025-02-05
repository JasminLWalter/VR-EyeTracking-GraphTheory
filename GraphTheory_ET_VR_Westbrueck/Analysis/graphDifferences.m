%% ------------------ compare graphs-------------------------------------
% script written by Jasmin Walter



clear all;


savepath= 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\differences_old_2023_graphs\';

datapath1 = 'F:\WestbrookProject\Spa_Re\control_group\Pre-processsing_pipeline\graphs\';
datapath2 = 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs\';

% 26 participants with 5x30min VR trainging less than 30% data loss
PartList = {1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080};


Number = length(PartList);
noFilePartList = [];
countMissingPart = 0;

overviewTable = table;
diffNodesOverview= [];
diffEdgesOverview = [];

for ii = 1:Number
    currentPart = cell2mat(PartList(ii));
    
    
    file1 = strcat(datapath1, num2str(currentPart),'_Graph_WB.mat');
    file2 = strcat(datapath2, num2str(currentPart),'_Graph_WB.mat');

        
    % load data
    graphy1_old = load(file1);
    graphy1_old = graphy1_old.graphy;

    graphy2_new = load(file2);
    graphy2_new = graphy2_new.graphy;

    % Find different nodes
    diffNodes = setxor(graphy1_old.Nodes.Name, graphy2_new.Nodes.Name);
    diffNodesOverview = [diffNodesOverview; diffNodes];
    numDiffNodes = length(diffNodes);
    numDiffNodes_p1 = length(diffNodes)/height(graphy1_old.Nodes.Name);
    numDiffNodes_p2 = length(diffNodes)/height(graphy2_new.Nodes.Name);


    % Find different edges
    diffEdges = setxor(categorical(graphy1_old.Edges.EndNodes), categorical(graphy2_new.Edges.EndNodes), 'rows');
    diffEdgesOverview = [diffEdgesOverview; diffEdges];

    % Number of different edges
    numDiffEdges = height(diffEdges);
    numDiffEdges_p1 = height(diffEdges)/height(graphy1_old.Edges.EndNodes);
    numDiffEdges_p2 = height(diffEdges)/height(graphy2_new.Edges.EndNodes);

    % calculate the diameter
    distance1 = distances(graphy1_old);
    checkInf = isinf(distance1);
    distance1(checkInf) = 0;
    diameter1 = max(max(distance1));

    distance2 = distances(graphy2_new);
    checkInf = isinf(distance2);
    distance2(checkInf) = 0;
    diameter2 = max(max(distance2));

    
    % Create overview table
    summary = table(currentPart, height(graphy1_old.Nodes.Name), height(graphy2_new.Nodes.Name),...
        height(graphy1_old.Edges.EndNodes), height(graphy2_new.Edges.EndNodes),...
        numDiffNodes, {diffNodes}, ...
        numDiffNodes_p1, numDiffNodes_p2,...
        numDiffEdges, {diffEdges}, ...
        numDiffEdges_p1, numDiffEdges_p2,...
        diameter1, diameter2,...
        'VariableNames', {'Participant', 'NrNodesGraphy1old','NrNodesGraphy2new',...
        'NrEdgesGraphy1old', 'NrEdgesGraphy2new',...
        'NumDifferentNodes', 'DifferentNodes', ...
        'NumDiffNodes_p1old', 'NumDiffNodes_p2new',...
        'NumDifferentEdges', 'DifferentEdges',...
        'NumDiffEdges_p1old', 'NumDiffEdges_p2new',...
        'DiameterGraphy1old', 'DiameterGraphy2new'});

    overviewTable = [overviewTable; summary];



    
end

writetable(overviewTable,strcat(savepath, 'overviewGraphDifferences_dur_vel.csv'))

varNames = overviewTable.Properties.VariableNames;

figure(1)

plotty1 = boxplot(overviewTable{:,2:3},'Labels',varNames(2:3));
title('Nodes') 
ax = gca;
saveas(ax,strcat(savepath, 'node_graph_diffs.png'))


figure(2)

plotty2 = boxplot(overviewTable{:,4:5},'Labels',varNames(4:5));
title('Edges') 
ax = gca;
saveas(ax,strcat(savepath, 'edges_graph_diffs.png'))



figure(3)
plotty3 = boxplot(overviewTable{:,6},'Labels',varNames(6));
title('Nr differences nodes') 
ax = gca;
saveas(ax,strcat(savepath, 'nrDiffNodes_graph_diffs.png'))



figure(35)
plotty35 = boxplot(overviewTable{:,8:9},'Labels',varNames(8:9));
title('Nr differences nodes in %') 
ax = gca;
saveas(ax,strcat(savepath, 'nrDiffNodesPer_graph_diffs.png'))



figure(4)
plotty4 = boxplot(overviewTable{:,10},'Labels',varNames(10));
title('Nr differences edges') 
ax = gca;
saveas(ax,strcat(savepath, 'nrDiffEdges_graph_diffs.png'))



figure(45)
plotty45 = boxplot(overviewTable{:,12:13},'Labels',varNames(12:13));
title('Nr differences edges in %') 

ax = gca;
saveas(ax,strcat(savepath, 'nrDiffEdgesPer_graph_diffs.png'))



figure(5)
plotty5 = boxplot(overviewTable{:,14:15},'Labels',varNames(14:15));
title('differences diameter') 

ax = gca;
saveas(ax,strcat(savepath, 'diffsDiameter_graph_diffs.png'))



% diffNodes = [];
% diffEdges = [];
% for index = 1: height(overviewTable)
%     diffNodes = [diffNodes; overviewTable{index,7}{:}];
%     diffEdges = [diffNodes; overviewTable{index,11}{:}];
% end

figure(6)
plotty6 = histogram(categorical(diffNodesOverview));
title('Differences Nodes')

ax = gca;

ax.TickLabelInterpreter = 'none'; 

saveas(ax,strcat(savepath, 'differencesNodes_graph_diffs.png'))




% Combine the house names into a single variable
combinations = strcat(string(diffEdgesOverview(:,1)), '_', string(diffEdgesOverview(:,2)));

% Count the occurrences of each combination
[counts, names] = histcounts(categorical(combinations));

% Plot the histogram
figure(7);
bar(counts);
% xticks(1:length(names));
% xticklabels(names);
xlabel('House Combinations');
ylabel('Frequency');
title('Histogram of House Name Combinations');

ax = gca;
ax.TickLabelInterpreter = 'none'; 

saveas(ax,strcat(savepath, 'hist_combis_node_diffs_graph_diffs.png'))


% 
% figure(7)
% plotty7 = histogram(categorical(diffEdgesOverview),'rows');
% title('Differences Edges')
