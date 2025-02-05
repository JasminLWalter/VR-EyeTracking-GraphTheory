%% ------------------ P2B_graph_properties_create_overview_shortFormat_withPlots_WB.m-----------------------

% --------------------script written by Jasmin L. Walter-------------------
% -----------------------jawalter@uni-osnabrueck.de------------------------

% Description: 


% Input: 

% Output:

%% start script
clear all;

%% adjust the following variables: 

savepath = 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\P2B_analysis\graph_measures\';

cd 'F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\P2B_analysis\data_overviews\';

graphPath = 'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs\';

graphPath_W =  'F:\WestbrookProject\Spa_Re\control_group\pre-processing_2023\velocity_based\step4_graphs_WEIGHTED\';

clistpath = 'D:\Github\NBP-VR-Eyetracking\GraphTheory_ET_VR_Westbrueck\additional_Files\'; % path to the coordinate list location

PartList = [1004 1005 1008 1010 1011 1013 1017 1018 1019 1021 1022 1023 1054 1055 1056 1057 1058 1068 1069 1072 1073 1074 1075 1077 1079 1080];



%% load overview of the mean performance of each participant
overviewPerformance = load('overviewPerformance.mat');
overviewPerformance = overviewPerformance.overviewPerformance;

% load hierarchy index

hierarchyIndex = load('F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\Seahaven_repl_pipeline\hierarchyIndex\HierarchyIndex_Table.mat');

hierarchyIndex = hierarchyIndex.HierarchyIndex;


% load gaze-graph-defined landmark list

commonGGLandmarks = readtable('F:\WestbrookProject\Spa_Re\control_group\analysis_velocityBased_2023\Seahaven_repl_pipeline\nodeDegreeCentrality\landmarkOverview.csv');
commonGGLandmarks = commonGGLandmarks.houseNames;


%% load graphs and calculate missing measures

%load coordinate list

listname = strcat(clistpath,'building_collider_list.csv');
coordinateList = readtable(listname);

houseNames = unique(coordinateList.target_collider_name);

overviewNodeDegreeW = cell2table(houseNames);

overviewGraphMeasures = overviewPerformance; 
% overviewGraphMeasures.Participants = PartList';


overviewGraphMeasures_longFormat = table;

for index = 1:length(PartList)
    currentPart = PartList(index);   
    
    file = strcat(graphPath,num2str(currentPart),'_Graph_WB.mat');
   
    %load graph
    graphy = load(file);
    graphy= graphy.graphy;

    graphyW = load(strcat(graphPath_W,num2str(currentPart),'_Graph_weighted_WB.mat'));
    graphyW= graphyW.graphyW;
    
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
    
    % calculate some gaze-graph-defined landmark stats
    
    nodeDegrees = degree(graphy);
          
    
    nodeDegreeTable = table;
    nodeDegreeTable = graphy.Nodes;
    nodeDegreeTable.nodeDegrees = nodeDegrees;
    
    threshold = mean(nodeDegrees) + (2* std(nodeDegrees));
    selection = nodeDegreeTable.nodeDegrees >= threshold;
    
    
    allLandmarks = nodeDegreeTable(selection,:); 
    nrAllLandmarks = height(allLandmarks);
       
    nrCommonLandmarks = sum(ismember(allLandmarks.Name, commonGGLandmarks));  
    nrIndividualLandmarks = nrAllLandmarks - nrCommonLandmarks;
    meanND = mean(nodeDegrees);

    % calculate other graph measures as well

    closeness = centrality(graphy, 'closeness');
    betweenness = centrality(graphy,'betweenness');
    pagerank = centrality(graphy,'pagerank');
    eigenvector = centrality(graphy,'eigenvector');


    nodeDegreeW = centrality(graphyW, 'degree', 'Importance', graphyW.Edges.Weight);
    pagerankW = centrality(graphyW,'pagerank','Importance', graphyW.Edges.Weight);
    eigenvectorW = centrality(graphyW,'eigenvector','Importance', graphyW.Edges.Weight);

   

    % calculate dwelling time as well
    
    
    % add data to overview
    
    overviewGraphMeasures.nrViewedHouses(index) = nrNodes;
    overviewGraphMeasures.nrEdges(index) = nrEdges;
    overviewGraphMeasures.density(index) = density;
    overviewGraphMeasures.diameter(index) = diameter;
    overviewGraphMeasures.avgShortestPath(index) = avgShortestPath;
    
    overviewGraphMeasures.nrAllLandmarks(index) = nrAllLandmarks;
    overviewGraphMeasures.nrCommonLandmarks(index) = nrCommonLandmarks;
    overviewGraphMeasures.nrIndividualLandmarks(index) = nrIndividualLandmarks;
    overviewGraphMesures.thresholdL(index) = threshold;

    overviewGraphMeasures.nodeDegree_mean(index) = meanND;

    overviewGraphMeasures.closeness_mean(index) = mean(closeness);
    overviewGraphMeasures.betweenness_mean(index) = mean(betweenness);
    overviewGraphMeasures.pagerank_mean(index) = mean(pagerank);
    overviewGraphMeasures.eigenvector_mean(index) = mean(eigenvector);

    overviewGraphMeasures.nodeDegree_W_mean(index) = mean(nodeDegreeW);
    overviewGraphMeasures.pagerank_W_mean(index) = mean(pagerankW);
    overviewGraphMeasures.eigenvector_W_mean(index) = mean(eigenvectorW);


    % % create long data format as well
    % lengthPart = sum(dataP2B.SubjectID == currentPart);   
    % 
    % longTable = table;
    % longTable.Participants(1:lengthPart) = currentPart;
    % longTable.nrViewedHouses(1:lengthPart) = nrNodes;
    % longTable.nrEdges(1:lengthPart) = nrEdges;
    % longTable.density(1:lengthPart) = density;
    % longTable.diameter(1:lengthPart) = diameter;
    % longTable.avgShortestPath(1:lengthPart) = avgShortestPath;
    % 
    % longTable.nrAllLandmarks(1:lengthPart) = nrAllLandmarks;
    % longTable.nrCommonLandmarks(1:lengthPart) = nrCommonLandmarks;
    % longTable.nrIndividualLandmarks(1:lengthPart) = nrIndividualLandmarks;
    % longTable.meanND(1:lengthPart) = meanND;
    % longTable.thresholdL(1:lengthPart) = threshold;
    % 
    % 
    % overviewGraphMeasures_longFormat = [overviewGraphMeasures_longFormat; longTable];
    

end

overviewGraphMeasures.hierarchyIndex = hierarchyIndex.Slope;

%% save overviews
save('overviewGraphMeasures','overviewGraphMeasures');
writetable(overviewGraphMeasures, 'overviewGraphMeasures.csv');

% save([savepath 'overviewGraphMeasures_longFormat'],'overviewGraphMeasures_longFormat');
% writetable(overviewGraphMeasures_longFormat, [savepath, 'overviewGraphMeasures_longFormat.csv']);


%% create a sorted overview for the plots

% % combine both overviews
% overviewPerformance = [overviewPerformance, overviewGraphMeasures(:,2:end)];
% 
% % sort the participants according to their mean performance
% 
% sortedOverviewPerformance = sortrows(overviewPerformance,2);
% sortedParticipantIDs = sortedOverviewPerformance.Participants;

%% plot all measures sorted according to mean performance

%% nr viewed houses
edges1 = (220:1:245);
figure(1)

plotty1 = histogram(overviewGraphMeasures.nrViewedHouses,edges1);

xlabel('number of viewed houses')
ylabel('frequency')
title({'histogram: number of viewed houses', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_nrViewedHouses.png'),'Resolution',600)

% plot scatter of measure with performance

figure(2)
x= overviewGraphMeasures.nrViewedHouses;
y = overviewPerformance.meanPerformance;
plotty2 = scatter(x,y,'filled');
xlabel('nr viewed houses')
ylabel('mean error')
title('Number of viewed houses and performance')

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_nrViewedHouses.png'),'Resolution',600)

%% density

% edges1 = [210:1:245];
figure(3)

edges3 = (0.02:0.005:0.08);
plotty3 = histogram(overviewGraphMeasures.density, edges3);

xlabel('density')
ylabel('frequency')
title({'histogram: graph density', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_density.png'),'Resolution',600)

% plot scatter of measure with performance

figure(4)
x= overviewGraphMeasures.density;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel('density')
ylabel('mean error')
title('Graph density and performance')

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_density.png'),'Resolution',600)


%% diameter

figure(5)

plotty5 = histogram(overviewGraphMeasures.diameter);

xlabel('diameter')
ylabel('frequency')
title({'histogram: graph diameter', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_diameter.png'),'Resolution',600)

% plot scatter of measure with performance

figure(6)
x= overviewGraphMeasures.diameter;
y = overviewPerformance.meanPerformance;
plotty5 = scatter(x,y,'filled');
xlabel('diameter')
ylabel('mean error')
title('Graph diameter and performance')

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_diameter.png'),'Resolution',600)

%% hierarchy index

figure(7)

plotty7 = histogram(overviewGraphMeasures.hierarchyIndex);

xlabel('hierarchy index')
ylabel('frequency')
title({'histogram: hierarchy index', ' '});

ax = gca;
exportgraphics(ax,strcat(savepath, 'histogram_hierarchyIndex.png'),'Resolution',600)

% plot scatter of measure with performance

figure(8)
x= overviewGraphMeasures.hierarchyIndex;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel('hierarchyIndex')
ylabel('mean error')
title('Hierarchy index and performance')
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_hierarchyIndex.png'),'Resolution',600)



%% landmark plots

figure(9)
x= overviewGraphMeasures.nrAllLandmarks;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel('nr all landmarks')
ylabel('mean error')
title('Nr all landmarks and performance')
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_nrAllLandmarks.png'),'Resolution',600)


figure(10)
x= overviewGraphMeasures.nrCommonLandmarks;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel('nr common landmarks')
ylabel('mean error')
title('Nr common landmarks and performance')
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_nrCommonLandmarks.png'),'Resolution',600)


figure(11)
x= overviewGraphMeasures.nrIndividualLandmarks;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel('nr individual landmarks')
ylabel('mean error')
title('Nr individual landmarks and performance')
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_nrIndividualLandmarks.png'),'Resolution',600)

%% mean centrality measures

label = 'nodeDegree-mean';
figure(12)
x= overviewGraphMeasures.nodeDegree_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)


%-----------

label = 'closeness-mean';
figure(13)
x= overviewGraphMeasures.closeness_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)

%-----------

label = 'betweenness-mean';
figure(14)
x= overviewGraphMeasures.betweenness_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)


%-----------

label = 'pagerank-mean';
figure(15)
x= overviewGraphMeasures.pagerank_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)

%-----------

label = 'eigenvector-mean';
figure(16)
x= overviewGraphMeasures.eigenvector_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)


%-----------

label = 'nodeDegree-weighted-mean';
figure(17)
x= overviewGraphMeasures.nodeDegree_W_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)

%-----------

label = 'pagerank-weighted-mean';
figure(18)
x= overviewGraphMeasures.pagerank_W_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)

%-----------

label = 'eigenvector-weighted-mean';
figure(19)
x= overviewGraphMeasures.eigenvector_W_mean;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)


label = 'avgShortestPath';
figure(20)
x= overviewGraphMeasures.avgShortestPath;
y = overviewPerformance.meanPerformance;
plotty4 = scatter(x,y,'filled');
xlabel(label)
ylabel('mean error')
title(strcat(label, '& performance'))
% xlim([6,10]);

% Calculate regression line
p = polyfit(x, y, 1);  % Fit a first-order polynomial (i.e. a line)
yfit = polyval(p, x);

% Add regression line to plot
hold on
plot(x, yfit, 'r-')
% legend('Data', 'Regression Line')
hold off

ax = gca;
exportgraphics(ax,strcat(savepath, 'scatter_performance_', label, '.png'),'Resolution',600)





%%

% figure(4)

% imagescaly = imagesc(overviewTrialPerformance);
% colorbar
% title({'Image Scale Performance - all Trials','     '});
% ax = gca;
% ax.XTick = 0:10:213;
% ax.TickDir = 'out';
% ax.XMinorTick = 'on';
% ax.XAxis.MinorTickValues = 1:1:213;
% ax.XLabel.String = 'Trials';
% ax.YLabel.String = 'Participants';
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, 'imagescale_performance_participants_allTrials.png'),'Resolution',600)
% 

% 
% %% create the corresponding error plots
% 
% meanTrials = mean(overviewTrialPerformance);
% meanParticipants = mean(overviewTrialPerformance,2);
% 
% stdTrials = std(overviewTrialPerformance);
% stdParticipants = std(overviewTrialPerformance,0,2);
% 
% figure(5)
% x = [1:112];
% plotty2 = errorbar(meanTrials, stdTrials,'black','Linewidth',1);
% xlabel('Trials')
% ylabel('angular error')
% % xlim([-1 27])
% title({'Mean performance of each trial with error bars', ' '});
% hold on
% 
% plotty2a = plot(meanTrials,'b','Linewidth',3);
% 
% hold off
% ax = gca;
% exportgraphics(ax,strcat(savepath, 'errorbar_performance_allTrials.png'),'Resolution',600)
% 
% 
% figure(6)
% x = [1:26];
% plotty2 = errorbar(meanParticipants, stdParticipants,'black','Linewidth',1);
% xlabel('participants')
% ylabel('angular error')
% xlim([-1 27])
% title({'Mean performance of each participant with error bars', ' '});
% hold on
% 
% plotty2a = plot(meanParticipants,'b','Linewidth',3);
% 
% set(gca,'view',[90 90])
% hold off
% 
% 
% ax = gca;
% exportgraphics(ax,strcat(savepath, 'errorbar_performance_participants_vertical.png'),'Resolution',600)









